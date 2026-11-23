/* ============================================================
   Apex Studio - model packs
   ------------------------------------------------------------
   WHY THIS EXISTS

   The converted .glb/.png the 3D viewer needs are plain files in a
   resource's files{} list. FXServer bundles every files{} entry of a
   resource into ONE archive (cache/files/<resource>/resource.rpf) that
   each player downloads on join. That archive is a GTA IV style "RPF2"
   and its table of contents stores every file's position as a 31-bit
   number: the format simply cannot address anything past 2 GiB.

   When a resource's files{} grow past that (a car pack converted whole
   does it easily: 200 cars = 2.7 GB of meshes and textures) the server
   still writes the archive, but every file placed after the 2 GiB mark
   gets a corrupt entry. templates.json is written LAST (alphabetical),
   so it is the first thing the studio asks for and the FiveM client
   crashes inside vfs-core.dll (bsearch over garbage) the moment the
   command is run. That exact crash was reproduced from a buyer's dump.

   THE FIX

   Models no longer live inside the studio resource. tools/convert.js
   writes them into generated sibling resources:

       <resource>_models/          (first pack)
       <resource>_models2/         (created when the first is full)
       ...

   each holding   fxmanifest.lua   (a files{} glob over models/, no scripts)
                  pack-index.json  (which model group lives here)
                  models/...       (the .glb/.png)

   and stays under a size budget (1 GiB by default, --pack-mb to change)
   that keeps every archive far from the 2 GiB cliff and the client's
   32-bit download counters. templates.json entries carry `res`, the
   resource that holds their files; the NUI fetches from
   https://cfx-nui-<res>/... (FiveM sends Access-Control-Allow-Origin: *
   for every resource file, so cross-resource loads are fine).

   Entries WITHOUT `res` keep working exactly as before (the files sit in
   the studio resource itself). A legacy stream/models/ tree from an
   older converter is moved into packs on the next run, and the entries
   are rewritten - so a server already over the limit is fixed by
   running the converter once more.

   Nothing here is FiveM-specific at run time: it is plain Node + fs.
   ============================================================ */
'use strict';

const fs = require('fs');
const path = require('path');

const MIB = 1024 * 1024;
const DEFAULT_BUDGET_MB = 1024;     // per pack; comfortable margin under the 2 GiB cliff
const MIN_BUDGET_MB = 16;           // --pack-mb floor (tests use tiny budgets)
const HARD_LIMIT_MB = 2048;         // the real limit: 31-bit file offsets in resource.rpf

function toPosix(p) { return String(p).split(path.sep).join('/'); }

function walk(dir, out, rel) {
    rel = rel || '';
    let names;
    try { names = fs.readdirSync(dir); } catch (e) { return out; }
    for (const name of names) {
        const abs = path.join(dir, name);
        let st; try { st = fs.statSync(abs); } catch (e) { continue; }
        const r = rel ? rel + '/' + name : name;
        if (st.isDirectory()) { walk(abs, out, r); }
        else { out.push({ abs: abs, rel: r, size: st.size }); }
    }
    return out;
}

function moveFile(src, dst) {
    if (path.resolve(src) === path.resolve(dst)) { return; }
    fs.mkdirSync(path.dirname(dst), { recursive: true });
    try { fs.renameSync(src, dst); }
    catch (e) {
        // Different drive / mount: copy then delete.
        fs.copyFileSync(src, dst);
        fs.unlinkSync(src);
    }
}

function removeEmptyDirs(dir, stopAt) {
    // Walk up from dir removing empty folders, never above stopAt.
    let cur = path.resolve(dir);
    const stop = path.resolve(stopAt);
    while (cur.startsWith(stop) && cur !== stop) {
        let names;
        try { names = fs.readdirSync(cur); } catch (e) { return; }
        if (names.length) { return; }
        try { fs.rmdirSync(cur); } catch (e) { return; }
        cur = path.dirname(cur);
    }
}

function fmtMb(bytes) { return (bytes / MIB).toFixed(bytes >= 100 * MIB ? 0 : 1) + ' MB'; }

/**
 * @param {object} opts
 * @param {string} opts.resourceRoot  absolute path of the studio resource (e.g. .../apex_vehicles)
 * @param {string} opts.resource      its resource name (e.g. 'apex_vehicles')
 * @param {number} [opts.budgetMb]    per-pack size budget (default 1024)
 * @param {function} [opts.log]
 */
function createPacks(opts) {
    const resourceRoot = path.resolve(opts.resourceRoot);
    const resource = String(opts.resource);
    const parent = path.dirname(resourceRoot);
    const log = opts.log || console.log;
    let budgetMb = Number(opts.budgetMb);
    if (!isFinite(budgetMb) || budgetMb <= 0) { budgetMb = DEFAULT_BUDGET_MB; }
    budgetMb = Math.max(MIN_BUDGET_MB, Math.min(HARD_LIMIT_MB - 64, Math.floor(budgetMb)));
    const budget = budgetMb * MIB;
    const baseName = resource + '_models';

    const packs = [];          // [{ name, dir, bytes, groups: { key: [rel, ...] }, dirty }]
    let dirty = false;

    function packDir(name) { return path.join(parent, name); }
    function nameFor(n) { return n === 1 ? baseName : baseName + String(n); }

    function readIndex(dir) {
        try {
            const d = JSON.parse(fs.readFileSync(path.join(dir, 'pack-index.json'), 'utf8'));
            return (d && typeof d.groups === 'object' && d.groups) ? d.groups : {};
        } catch (e) { return {}; }
    }

    function sizeOf(dir) {
        let total = 0;
        for (const f of walk(path.join(dir, 'models'), [])) { total += f.size; }
        return total;
    }

    function discover() {
        let names;
        try { names = fs.readdirSync(parent); } catch (e) { names = []; }
        const re = new RegExp('^' + baseName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '(\\d*)$', 'i');
        const found = [];
        for (const n of names) {
            const m = re.exec(n);
            if (!m) { continue; }
            const dir = path.join(parent, n);
            let st; try { st = fs.statSync(dir); } catch (e) { continue; }
            if (!st.isDirectory()) { continue; }
            found.push({ n: m[1] === '' ? 1 : parseInt(m[1], 10), name: n, dir: dir });
        }
        found.sort((a, b) => a.n - b.n);
        for (const f of found) {
            packs.push({ name: f.name, dir: f.dir, bytes: sizeOf(f.dir), groups: readIndex(f.dir), dirty: false });
        }
    }
    discover();

    function newPack() {
        let n = 1;
        const used = new Set(packs.map(p => p.name.toLowerCase()));
        while (used.has(nameFor(n).toLowerCase())) { n++; }
        const name = nameFor(n);
        const dir = packDir(name);
        fs.mkdirSync(path.join(dir, 'models'), { recursive: true });
        const p = { name: name, dir: dir, bytes: 0, groups: {}, dirty: true, created: true };
        packs.push(p);
        dirty = true;
        return p;
    }

    /* The pack that already holds `key`, verified against the disk. */
    function locate(key) {
        for (const p of packs) {
            const rels = p.groups[key];
            if (!Array.isArray(rels) || !rels.length) { continue; }
            const existing = rels.filter(r => fs.existsSync(path.join(p.dir, r)));
            if (!existing.length) { delete p.groups[key]; p.dirty = true; continue; }
            return { res: p.name, pack: p, dir: p.dir, files: existing };
        }
        return null;
    }

    /* First pack with room for `bytes`; a new one when none has. */
    function choose(bytes) {
        for (const p of packs) {
            if (p.bytes + bytes <= budget) { return p; }
        }
        return newPack();
    }

    /**
     * Put a model group's files into a pack.
     * @param {string} key    group id (one car / one garment)
     * @param {Array<{src:string, rel:string}>} files  rel = path under models/ (posix), e.g. 'vehicles/adder.glb'
     * @returns {{res:string, rel:function(string):string, pack:object}}
     */
    function commit(key, files) {
        files = (files || []).filter(f => f && f.src && fs.existsSync(f.src));
        const sizes = files.map(f => { try { return fs.statSync(f.src).size; } catch (e) { return 0; } });
        const total = sizes.reduce((a, b) => a + b, 0);

        const loc = locate(key);
        let pack;
        if (loc) {
            pack = loc.pack;
            // Drop the group's previous files that are not part of this set (e.g. a
            // surface that no longer exists), so a re-convert leaves no orphans.
            const keep = new Set(files.map(f => 'models/' + toPosix(f.rel)));
            for (const r of loc.files) {
                if (keep.has(r)) { continue; }
                try { fs.unlinkSync(path.join(pack.dir, r)); } catch (e) { /* ignore */ }
            }
        } else {
            pack = choose(total);
        }

        const rels = [];
        for (const f of files) {
            const dst = path.join(pack.dir, 'models', f.rel);
            moveFile(f.src, dst);
            rels.push('models/' + toPosix(f.rel));
        }
        // Re-measure from disk: files were replaced in place, deleted and added,
        // and an exact figure is what keeps the next choose() honest.
        pack.bytes = sizeOf(pack.dir);
        if (rels.length) { pack.groups[key] = rels; } else { delete pack.groups[key]; }
        pack.dirty = true;
        dirty = true;
        return {
            res: pack.name,
            pack: pack,
            rel: function (relUnderModels) { return 'models/' + toPosix(relUnderModels).replace(/^\/+/, ''); },
        };
    }

    /* Where a group's files should be WRITTEN before commit: its current pack
       folder when it already lives in one (so re-converting updates in place),
       otherwise the caller's work dir. */
    function targetDir(key, subdir, workDir) {
        const loc = locate(key);
        if (loc) { return path.join(loc.dir, 'models', subdir); }
        return workDir;
    }

    /**
     * Move an older converter's output (stream/models/...) into packs.
     * @param {string} legacyDir   absolute path (e.g. <resource>/stream/models)
     * @param {function} classify  (relPosix) => { key, rel } | null   rel = path under models/
     * @returns {{moved:number, groups:number, map:Object<string,{res:string,rel:string}>}}
     *          map: old path relative to the resource root ('stream/models/...') -> new location
     */
    function migrateLegacy(legacyDir, classify) {
        const result = { moved: 0, groups: 0, map: {} };
        if (!fs.existsSync(legacyDir)) { return result; }
        const files = walk(legacyDir, []);
        const groups = new Map();
        for (const f of files) {
            const c = classify(f.rel);
            if (!c || !c.key) { continue; }
            if (!groups.has(c.key)) { groups.set(c.key, []); }
            groups.get(c.key).push({ src: f.abs, rel: c.rel, oldRel: toPosix(path.relative(resourceRoot, f.abs)) });
        }
        if (!groups.size) { return result; }
        log('Moving ' + files.length + ' file(s) from ' + toPosix(path.relative(resourceRoot, legacyDir))
            + '/ into model packs (' + groups.size + ' model(s))...');
        for (const [key, list] of groups) {
            const c = commit(key, list);
            for (const f of list) {
                result.map[f.oldRel] = { res: c.res, rel: c.rel(f.rel) };
                result.moved++;
            }
            result.groups++;
            removeEmptyDirs(path.dirname(list[0].src), legacyDir);
        }
        return result;
    }

    /* Point templates.json entries at the new locations. Entries that already
       carry `res` are left alone. Returns how many entries changed. */
    function rewriteTemplates(templates, map) {
        let changed = 0;
        const fix = (p) => (p && map[p]) ? map[p] : null;
        for (const t of templates || []) {
            if (!t || typeof t !== 'object' || t.res) { continue; }
            let res = null, touched = false;
            const take = (val) => { const m = fix(val); if (m) { res = res || m.res; touched = true; return m.rel; } return val; };
            if (t.glb) { t.glb = take(t.glb); }
            if (t.thumb) { t.thumb = take(t.thumb); }
            if (t.baseTexture) { t.baseTexture = take(t.baseTexture); }
            if (Array.isArray(t.textures)) {
                for (const tex of t.textures) { if (tex && tex.png) { tex.png = take(tex.png); } }
            }
            if (touched && res) { t.res = res; changed++; }
        }
        return changed;
    }

    function manifestText(name) {
        return [
            '-- Generated by ' + resource + '/tools/convert.js - do not add scripts here.',
            '--',
            '-- This resource only carries the 3D viewer models (.glb) and texture',
            '-- previews (.png) of the ' + resource + ' studio. It is separate so that',
            '-- no single resource ever holds more than ~' + budgetMb + ' MB of files:',
            '-- FXServer packs a resource\'s files into one resource.rpf whose entry',
            '-- offsets are 31-bit, so anything past 2 GiB corrupts the archive and',
            '-- crashes the FiveM client (vfs-core.dll) when the studio opens.',
            '--',
            '-- Add to server.cfg next to the studio:   ensure ' + name,
            '-- Re-running tools/convert.js updates this folder; never edit by hand.',
            '',
            "fx_version 'cerulean'",
            "game 'gta5'",
            '',
            "author      'Apex Scriptz'",
            "description '" + resource + " 3D model pack (generated by tools/convert.js)'",
            "version     '1.0.0'",
            '',
            'files {',
            "    'models/**/*',",
            '}',
            '',
        ].join('\n');
    }

    /* Write fxmanifest.lua + pack-index.json for every pack that changed. */
    function writeManifests() {
        for (const p of packs) {
            const mf = path.join(p.dir, 'fxmanifest.lua');
            const want = manifestText(p.name);
            let have = null;
            try { have = fs.readFileSync(mf, 'utf8'); } catch (e) { have = null; }
            if (have !== want) { fs.writeFileSync(mf, want, 'utf8'); }
            if (p.dirty || !fs.existsSync(path.join(p.dir, 'pack-index.json'))) {
                const idx = {
                    _comment: 'Written by ' + resource + '/tools/convert.js - which model lives in this pack. Do not edit.',
                    resource: resource,
                    groups: p.groups,
                };
                fs.writeFileSync(path.join(p.dir, 'pack-index.json'), JSON.stringify(idx, null, 2) + '\n', 'utf8');
                p.dirty = false;
            }
            // Keep the models/ folder present even when empty, so the manifest glob
            // has something to point at.
            fs.mkdirSync(path.join(p.dir, 'models'), { recursive: true });
        }
        dirty = false;
    }

    /* Packs over the real limit (should be impossible by construction unless a
       single model is gigantic) - returns their names. */
    function oversized() {
        return packs.filter(p => p.bytes > HARD_LIMIT_MB * MIB).map(p => p.name);
    }

    function report() {
        if (!packs.length) { return; }
        log('');
        log('Model packs (next to ' + resource + '/, in ' + parent + '):');
        for (const p of packs) {
            const n = Object.keys(p.groups).length;
            let files = 0;
            for (const k of Object.keys(p.groups)) { files += p.groups[k].length; }
            log('   ' + p.name + '/   ' + n + ' model(s), ' + files + ' file(s), ' + fmtMb(p.bytes)
                + (p.bytes > budget ? '   (over the ' + budgetMb + ' MB budget - a single model is bigger than it)' : '')
                + (p.created ? '   NEW' : ''));
        }
        const over = oversized();
        if (over.length) {
            log('');
            log('   !! ' + over.join(', ') + ' exceed(s) 2 GiB. FiveM cannot serve a resource that');
            log('      large - split the models with --pack-mb or remove some.');
        }
        log('');
        log('server.cfg must start every pack (they hold the files the studio loads):');
        for (const p of packs) { log('   ensure ' + p.name); }
        log('A pack that is not started shows as "Could not load <model>" in the studio;');
        log(resource + ' also warns about it in the server console at start-up.');
    }

    return {
        budgetMb: budgetMb,
        packs: packs,
        locate: locate,
        commit: commit,
        targetDir: targetDir,
        migrateLegacy: migrateLegacy,
        rewriteTemplates: rewriteTemplates,
        writeManifests: writeManifests,
        oversized: oversized,
        report: report,
        isDirty: function () { return dirty; },
    };
}

module.exports = { createPacks, MIB, DEFAULT_BUDGET_MB, HARD_LIMIT_MB, walk, toPosix };
