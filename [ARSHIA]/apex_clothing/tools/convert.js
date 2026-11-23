#!/usr/bin/env node
/* ─────────────────────────────────────────────────────────────
   Apex Clothing Studio - .ydd → .glb batch converter (worker)

   The browser can't read the game's .ydd, so the 3D viewer needs a
   .glb. This tool reads the .ydd and .ytd files DIRECTLY (tools/rage.js - a small RAGE resource reader) and writes the web .glb + the
   texture .png, then updates templates.json so the studio shows the
   real 3D shape with its real textures.

   WHERE THE FILES GO (since 2.1.5): into generated MODEL PACK
   resources next to apex_clothing - apex_clothing_models/,
   apex_clothing_models2/, ... each kept under a size budget (1 GiB,
   --pack-mb to change). FiveM bundles a resource's files into one
   archive whose offsets are 31-bit: a resource with more than 2 GiB
   of files corrupts that archive and CRASHES every player's game the
   moment the studio opens. Packs make that impossible, and they stop
   the models from being downloaded twice (the old stream/models/
   location was also treated as GTA streaming assets). See
   tools/packs.js for the full story. An existing stream/models/ from
   an older version is moved into packs automatically on the next run.

   Everything happens on this machine: no internet, no account, no
   quota, no Blender / Sollumz / CodeWalker. A file the reader cannot
   decode (a format it has never seen) is sent - once, mesh only - to
   the hosted gtax.dev converter as a FALLBACK; that service allows
   3 conversions per IP per 24 h (10 with a free key), so it is never
   used for textures and never for a file the reader can handle.

   Requirements: Node.js. That's it.

   Run it from this folder:
       node convert.js
   or double-click convert.bat

   Options:
     --force              reconvert even if a .glb / .png already exists
     --gender female      gender for .ydd not inside a female/ or male/ folder
     --src <folder>       ALSO scan this folder for .ydd/.ytd (repeatable).
                          Lets you keep your working clothes anywhere on the
                          PC - e.g. --src "C:\Users\me\Desktop\Roupa" - without
                          copying them into the resource first.
     --pack-mb <n>        size budget of each model pack (default 1024)
     --no-api             never contact the hosted fallback (fully offline)
     --api <base-url>     use a different / self-hosted fallback converter
   Env:
     V_DRAWABLE_TO_GLB_API_KEY   optional key for the hosted fallback
                                 (free at gtax.dev/api-keys → 10/day)

   Extra source folders can also be listed, one per line, in
   tools/sources.txt - that file is read on every run, so a
   double-click of convert.bat picks them up with no arguments.
   Lines starting with # are comments.
   ───────────────────────────────────────────────────────────── */

'use strict';

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');
const Rage = require('./rage.js');
const Packs = require('./packs.js');

const RESOURCE_NAME = 'apex_clothing';
const TOOLS_DIR = __dirname;
const RESOURCE_ROOT = path.resolve(TOOLS_DIR, '..');
// Where OLDER versions wrote the .glb/.png. Anything still here is moved
// into the model packs on every run (see packs.js for why).
const LEGACY_MODELS_DIR = path.join(RESOURCE_ROOT, 'stream', 'models');
// Scratch space for a garment being converted; its files are moved into
// a pack when it is done. Outside stream/ and outside files{}.
const WORK_DIR = path.join(TOOLS_DIR, '.work');
// The source .ydd/.ytd live OUTSIDE stream/ so FiveM does NOT replicate the
// original game files to every client. convert.js reads them from here.
const SOURCE_DIR = path.join(RESOURCE_ROOT, 'templates');
const TEMPLATES_JSON = path.join(RESOURCE_ROOT, 'templates.json');

const COMPONENTS = ['head', 'berd', 'hair', 'uppr', 'lowr', 'hand', 'feet', 'teef', 'accs', 'task', 'decl', 'jbib'];
const COMP_ID = { head: 0, berd: 1, hair: 2, uppr: 3, lowr: 4, hand: 5, feet: 6, teef: 7, accs: 8, task: 9, decl: 10, jbib: 11 };

const args = process.argv.slice(2);
const FORCE = args.includes('--force');
const NO_API = args.includes('--no-api');
function argVal(flag) { const i = args.indexOf(flag); return (i !== -1 && args[i + 1]) ? args[i + 1] : null; }
/* every --src occurrence, not just the first */
function argVals(flag) {
    const out = [];
    for (let i = 0; i < args.length; i++) {
        if (args[i] === flag && args[i + 1]) { out.push(args[i + 1]); }
    }
    return out;
}

/* Extra source folders: --src flags plus tools/sources.txt. Missing
   folders are reported, not fatal - a listed drive may be unplugged. */
function extraSources() {
    const out = argVals('--src');
    const listFile = path.join(TOOLS_DIR, 'sources.txt');
    if (fs.existsSync(listFile)) {
        for (let line of fs.readFileSync(listFile, 'utf8').split(/\r?\n/)) {
            line = line.trim();
            if (line && !line.startsWith('#')) { out.push(line); }
        }
    }
    const seen = new Set();
    return out.filter(p => {
        const key = path.resolve(p).toLowerCase();
        if (seen.has(key)) { return false; }
        seen.add(key);
        if (!fs.existsSync(p)) {
            console.log('SKIP (source folder not found):', p);
            return false;
        }
        return true;
    });
}
const DEFAULT_GENDER = (argVal('--gender') || 'male').toLowerCase();
const API_BASE = (argVal('--api') || process.env.V_DRAWABLE_API || 'https://public-drawable-to-glb.gtax.dev').replace(/\/+$/, '');
const API_KEY = process.env.V_DRAWABLE_TO_GLB_API_KEY || '';

/* ── curl (only for the hosted fallback) ────────────────────── */
function findCurl() {
    const win = path.join(process.env.SystemRoot || 'C:\\Windows', 'System32', 'curl.exe');
    if (process.platform === 'win32' && fs.existsSync(win)) { return win; }
    return 'curl';
}

/* ── discovery / naming ─────────────────────────────────────── */
function walk(dir, out) {
    if (!fs.existsSync(dir)) { return; }
    for (const name of fs.readdirSync(dir)) {
        const full = path.join(dir, name);
        let st; try { st = fs.statSync(full); } catch (e) { continue; }
        if (st.isDirectory()) { walk(full, out); }
        else if (name.toLowerCase().endsWith('.ydd')) { out.push(full); }
    }
}
function genderFromPath(p) {
    const parts = p.toLowerCase().split(path.sep);
    if (parts.includes('female')) { return 'female'; }
    if (parts.includes('male')) { return 'male'; }
    return null;
}
// GTA gender lives in the collection prefix: mp_f_* = female, mp_m_* = male.
// This wins over the folder so mixed dumps get sorted correctly.
function genderFromName(base) {
    const b = base.toLowerCase();
    if (/(^|_|\^)mp_f_freemode/.test(b)) { return 'female'; }
    if (/(^|_|\^)mp_m_freemode/.test(b)) { return 'male'; }
    return null;
}
// GTA names are "<collection_dict>^<drawable>" where ^ = "/". The component
// (jbib/lowr/uppr/…) is in the DRAWABLE part, after the last ^.
function drawableOf(base) { return base.includes('^') ? base.split('^').pop() : base; }
function collectionOf(base) { return base.includes('^') ? base.split('^')[0] : null; }
function componentFromBase(base) {
    const drawable = drawableOf(base);
    let best = null;
    for (const c of COMPONENTS) {
        if (drawable === c || drawable.startsWith(c + '_')) { if (!best || c.length > best.length) { best = c; } }
    }
    return best;
}
function deriveTexture(gender, comp, base) {
    const ped = gender === 'female' ? 'mp_f_freemode_01' : 'mp_m_freemode_01';
    const drawable = drawableOf(base);
    // Addon DLC clothing streams under its own collection dictionary; the
    // base game streams under mp_x_freemode_01.
    const dict = collectionOf(base) || ped;
    if (drawable.includes('_diff_')) { return { txd: dict + '/' + drawable, txn: drawable }; }
    const m = drawable.match(/(\d+)/);
    const num = m ? String(parseInt(m[1], 10)).padStart(3, '0') : '000';
    const race = /_r$/.test(drawable) ? 'whi' : 'uni';
    const txn = `${comp}_diff_${num}_a_${race}`;
    return { txd: dict + '/' + txn, txn: txn };
}
function pretty(base) {
    return base.replace(/[_-]+/g, ' ').replace(/\b\w/g, c => c.toUpperCase()).trim();
}

/* ── templates.json ─────────────────────────────────────────── */
function loadTemplates() {
    try { const d = JSON.parse(fs.readFileSync(TEMPLATES_JSON, 'utf8')); return Array.isArray(d.templates) ? d.templates : []; }
    catch (e) { return []; }
}
function saveTemplates(list) {
    fs.writeFileSync(TEMPLATES_JSON, JSON.stringify({
        _comment: 'Auto-updated by tools/convert.js. The NUI fetches this directly. Safe to edit by hand. '
            + '"res" = the model pack resource that holds an entry\'s files (absent = this resource).',
        templates: list
    }, null, 2) + '\n', 'utf8');
}
function upsert(list, entry) {
    const i = list.findIndex(t => t && t.id === entry.id);
    if (i === -1) { list.push(entry); } else { list[i] = Object.assign({}, list[i], entry); }
}

/* ── helpers ────────────────────────────────────────────────── */
function isGlb(p) {
    try { const fd = fs.openSync(p, 'r'); const b = Buffer.alloc(4); fs.readSync(fd, b, 0, 4, 0); fs.closeSync(fd); return b.toString('ascii') === 'glTF'; }
    catch (e) { return false; }
}
// Find ALL texture variants (.ytd) for a drawable, e.g.
// jbib_diff_012_a_uni.ytd, _b_uni.ytd, … → the switchable textures.
function findAllYtd(dir, comp, num, base) {
    const n = String(parseInt(num, 10)).padStart(3, '0');
    const drawPrefix = (comp + '_diff_' + n + '_').toLowerCase();     // jbib_diff_006_
    // Match ONLY the same collection, so different DLCs that reuse a
    // number don't cross-contaminate. The .ytd shares the .ydd's
    // "<collection>^" prefix (or none for base game).
    const collection = base && base.includes('^') ? base.split('^')[0] : null;
    const fullPrefix = ((collection ? collection + '^' : '') + drawPrefix).toLowerCase();
    const out = [];
    try {
        for (const f of fs.readdirSync(dir)) {
            const lf = f.toLowerCase();
            if (!lf.endsWith('.ytd') || !lf.startsWith(fullPrefix)) { continue; }
            const draw = f.includes('^') ? f.split('^').pop() : f;    // jbib_diff_006_a_uni.ytd
            const txn = draw.replace(/\.ytd$/i, '');                  // jbib_diff_006_a_uni
            out.push({
                letter: txn.toLowerCase().slice(drawPrefix.length).charAt(0) || '?',
                path: path.join(dir, f),
                txn: txn,
            });
        }
    } catch (e) { /* none */ }
    out.sort((a, b) => a.letter.localeCompare(b.letter));
    return out;
}

function sleep(ms) { return new Promise(r => setTimeout(r, ms)); }

// Read a PNG's pixel dimensions from its IHDR header.
function pngSize(buf) {
    if (buf && buf.length > 24 && buf[0] === 0x89 && buf.toString('ascii', 1, 4) === 'PNG') {
        return { w: buf.readUInt32BE(16), h: buf.readUInt32BE(20) };
    }
    return null;
}

function relPath(p) { return path.relative(RESOURCE_ROOT, p).split(path.sep).join('/'); }

/* ── LOCAL conversion (the normal path) ─────────────────────── */

// .ydd → .glb on this machine. Returns { ok, stats } or { ok:false, err }.
function localMesh(ydd, outGlb, name) {
    try {
        const r = Rage.yddToGlb(fs.readFileSync(ydd), { name });
        fs.writeFileSync(outGlb, r.glb);
        if (!isGlb(outGlb)) { throw new Error('written file is not a valid glb'); }
        return { ok: true, stats: r.stats };
    } catch (e) {
        try { if (fs.existsSync(outGlb) && !isGlb(outGlb)) { fs.unlinkSync(outGlb); } } catch (e2) { /* ignore */ }
        return { ok: false, err: e.message };
    }
}

// .ytd → .png on this machine. Returns { ok, w, h, format } or { ok:false, err }.
function localTexture(ytd, outPng, txn) {
    try {
        const r = Rage.ytdToPng(fs.readFileSync(ytd), txn);
        fs.writeFileSync(outPng, r.png);
        return { ok: true, w: r.w, h: r.h, format: r.format, name: r.name };
    } catch (e) {
        return { ok: false, err: e.message };
    }
}

/* ── HOSTED fallback (gtax.dev, mesh only, rare) ────────────── */

// Pull the human-readable reason out of an error response the API
// wrote to the output path. Almost always JSON ({"error": "..."}),
// sometimes plain text; either way it is the ONLY thing that says why.
function readErrorBody(p) {
    try {
        if (!fs.existsSync(p)) { return ''; }
        const raw = fs.readFileSync(p, 'utf8').slice(0, 4000).trim();
        if (!raw) { return ''; }
        try {
            const j = JSON.parse(raw);
            const pick = j.detail || j.message || j.error || j.reason;
            if (typeof pick === 'string') { return pick; }
            // FastAPI validation errors: detail is an array of objects.
            if (Array.isArray(pick)) {
                return pick.map(e => (e && (e.msg || e.type)) || JSON.stringify(e)).join('; ');
            }
            return JSON.stringify(j).slice(0, 400);
        } catch (e) { return raw.replace(/\s+/g, ' ').slice(0, 400); }
    } catch (e) { return ''; }
}

let curlPath = null;
function apiConvert(ydd, outGlb, name, ytd) {
    if (!curlPath) {
        curlPath = findCurl();
        const ver = spawnSync(curlPath, ['--version'], { encoding: 'utf8' });
        if (ver.error) { return { ok: false, code: 'curl-missing', body: 'curl is not installed (it ships with Windows 10+/11 and Linux)' }; }
    }
    const a = ['-sS', '-o', outGlb, '-w', '%{http_code}',
        '-F', 'ydd=@' + ydd, '-F', 'name=' + name, '-F', 'lod=high'];
    if (ytd) { a.push('-F', 'ytd=@' + ytd); }
    if (API_KEY) { a.push('-H', 'Authorization: Bearer ' + API_KEY); }
    a.push(API_BASE + '/convert/ydd-to-glb');
    const r = spawnSync(curlPath, a, { encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 });
    if (r.error) { return { ok: false, code: 'curl-missing', body: r.error.message }; }
    const code = (r.stdout || '').trim();
    if (code === '200' && isGlb(outGlb)) { return { ok: true, code }; }
    // ⚠ READ the error body BEFORE deleting it: curl wrote the API's
    // response to the output path, and that file IS the explanation.
    const body = readErrorBody(outGlb) || (r.stderr || '').trim();
    try { if (fs.existsSync(outGlb) && !isGlb(outGlb)) { fs.unlinkSync(outGlb); } } catch (e) { /* ignore */ }
    return { ok: false, code, body };
}

// The hosted service meters conversions PER DAY (3 per IP without a
// key). A 429 therefore means "no more today" - retrying in six
// seconds cannot help, and every later request would fail the same
// way, so one 429 switches the fallback off for the rest of the run.
let quotaExhausted = false;
let apiCalls = 0;
function isTransient(code) {
    if (!code) { return true; }
    if (code === '000') { return true; }
    return /^5\d\d$/.test(String(code));
}
function why(r) {
    const head = 'http ' + (r.code || '?');
    return r.body ? (head + ' - ' + r.body) : head;
}

async function apiMesh(ydd, outGlb, name, ytd) {
    if (NO_API) { return { ok: false, skipped: 'hosted fallback disabled (--no-api)' }; }
    if (quotaExhausted) { return { ok: false, skipped: 'hosted fallback quota already exhausted today' }; }
    apiCalls++;
    let r = apiConvert(ydd, outGlb, name, ytd);
    for (let attempt = 0; attempt < 2 && !r.ok && isTransient(r.code); attempt++) {
        await sleep(1500);
        apiCalls++;
        r = apiConvert(ydd, outGlb, name, ytd);
    }
    if (!r.ok && r.code === '429') { quotaExhausted = true; }
    return r;
}

/* ── model packs ────────────────────────────────────────────── */

// The files of one garment, as written by this tool: <base>.glb and
// <base>_<letter>.png. Everything else in a folder is not ours.
function groupFilesIn(dir, safeBase) {
    let names;
    try { names = fs.readdirSync(dir); } catch (e) { return []; }
    const glb = (safeBase + '.glb').toLowerCase();
    const re = new RegExp('^' + safeBase.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '_[^_]+\\.png$', 'i');
    return names.filter(n => n.toLowerCase() === glb || re.test(n));
}

// Which garment an old stream/models/<gender>/<comp>/<file> belongs to.
// Pngs are matched to the .glb bases found in the same folder, so
// "x_u_a.png" goes with "x_u.glb" and never with a garment called "x_u_a".
function legacyClassifier() {
    const bases = new Map();   // 'male/jbib' -> Set of glb base names (lower)
    for (const f of Packs.walk(LEGACY_MODELS_DIR, [])) {
        const m = /^([^/]+)\/([^/]+)\/([^/]+)\.glb$/i.exec(f.rel);
        if (!m) { continue; }
        const dir = (m[1] + '/' + m[2]).toLowerCase();
        if (!bases.has(dir)) { bases.set(dir, new Set()); }
        bases.get(dir).add(m[3].toLowerCase());
    }
    return function classify(relPosix) {
        const m = /^([^/]+)\/([^/]+)\/([^/]+)$/i.exec(relPosix);
        if (!m) { return null; }
        const gender = m[1].toLowerCase(), comp = m[2].toLowerCase(), name = m[3];
        if (!/^(male|female)$/.test(gender) || !COMPONENTS.includes(comp)) { return null; }
        let base = null;
        if (/\.glb$/i.test(name)) { base = name.slice(0, -4); }
        else if (/\.png$/i.test(name)) {
            const known = bases.get(gender + '/' + comp) || new Set();
            const cut = name.replace(/_[^_]+\.png$/i, '');
            if (known.has(cut.toLowerCase())) { base = cut; }
            else if (/_[^_]+\.png$/i.test(name)) { base = cut; }   // orphan texture: keep it with its stem
        }
        if (!base) { return null; }
        return { key: (gender + '/' + comp + '/' + base).toLowerCase(), rel: gender + '/' + comp + '/' + name };
    };
}

function rmWork(dir) {
    try { fs.rmSync(dir, { recursive: true, force: true }); } catch (e) { /* ignore */ }
}

/* ── main ───────────────────────────────────────────────────── */
async function main() {
    console.log('Apex Clothing Studio - .ydd -> .glb converter (local, no internet needed)\n');

    const packs = Packs.createPacks({
        resourceRoot: RESOURCE_ROOT,
        resource: RESOURCE_NAME,
        budgetMb: argVal('--pack-mb'),
    });
    const templates = loadTemplates();

    // Models an older version left inside this resource (stream/models/)
    // move into packs first. This alone repairs a server whose resource
    // had grown past 2 GiB - the crash needs nothing else.
    const migrated = packs.migrateLegacy(LEGACY_MODELS_DIR, legacyClassifier());
    if (migrated.moved) {
        const fixed = packs.rewriteTemplates(templates, migrated.map);
        saveTemplates(templates);
        console.log('Moved ' + migrated.moved + ' file(s) of ' + migrated.groups + ' garment(s) out of stream/models/ into model packs;');
        console.log('templates.json updated for ' + fixed + ' entr' + (fixed === 1 ? 'y' : 'ies') + '.\n');
    }

    const ydds = [];
    walk(SOURCE_DIR, ydds);
    const extras = extraSources();
    for (const dir of extras) {
        console.log('Source:', dir);
        walk(dir, ydds);
    }
    console.log('Found :', ydds.length, '.ydd file(s)\n');
    if (!ydds.length) {
        console.log('Nothing to convert. Put your .ydd + .ytd files under templates/female/ or templates/male/,');
        console.log('or point at any folder:  node convert.js --src "C:\\path\\to\\your\\clothes"');
        console.log('(or list that folder in tools/sources.txt so a plain double-click finds it)');
        if (packs.isDirty() || packs.packs.length) {
            packs.writeManifests();
            packs.report();
            printUpload(packs);
        }
        return;
    }

    rmWork(WORK_DIR);
    let ok = 0, skip = 0, fail = 0, texCount = 0, texFail = 0;
    const seen = new Set();
    const failures = [];      // { item, reason } - printed at the end

    for (const ydd of ydds) {
        const base = path.basename(ydd, path.extname(ydd));
        // gender from the collection name first (mixed dumps), then folder.
        const gender = genderFromName(base) || genderFromPath(ydd) || DEFAULT_GENDER;
        const comp = componentFromBase(base);
        if (!comp) { console.log('SKIP (unknown component):', relPath(ydd)); skip++; continue; }

        // Output filenames drop the "^" (collection^drawable) → clean names.
        const safeBase = base.replace(/\^/g, '_');

        const key = (gender + '/' + comp + '/' + safeBase).toLowerCase();
        if (seen.has(key)) { continue; }   // same item copied in two folders
        seen.add(key);

        // Write into the garment's current pack folder when it already lives
        // in one (so a re-convert updates in place); otherwise into a scratch
        // folder that commit() moves into whichever pack has room.
        const sub = gender + '/' + comp;
        const workDir = path.join(WORK_DIR, gender, comp, safeBase);
        const outDir = packs.targetDir(key, sub, workDir);
        fs.mkdirSync(outDir, { recursive: true });
        const outGlb = path.join(outDir, safeBase + '.glb');
        const { txd, txn } = deriveTexture(gender, comp, base);
        const id = gender + '_' + comp + '_' + safeBase;
        const numMatch = drawableOf(base).match(/(\d+)/);
        const variants = numMatch ? findAllYtd(path.dirname(ydd), comp, numMatch[1], base) : [];
        const meta = { id, name: pretty(drawableOf(base)), gender, component: COMP_ID[comp], componentKey: comp, txd, txn };
        const pngPathOf = v => path.join(outDir, safeBase + '_' + v.letter + '.png');

        /* Move the garment's files into a pack and write its catalog entry.
           `textures` carry FILE NAMES here; they become pack-relative paths
           once the files have a home. */
        function finalize(textures, hasGlb) {
            const files = groupFilesIn(outDir, safeBase)
                .filter(n => hasGlb || n.toLowerCase() !== (safeBase + '.glb').toLowerCase())
                .map(n => ({ src: path.join(outDir, n), rel: sub + '/' + n }));
            const c = files.length ? packs.commit(key, files) : null;
            const texs = textures.map(t => ({
                id: t.id, txn: t.txn, png: c ? c.rel(sub + '/' + t.file) : '', w: t.w, h: t.h,
            }));
            const entry = Object.assign({
                glb: (hasGlb && c) ? c.rel(sub + '/' + safeBase + '.glb') : '',
                textures: texs,
                txn: (texs[0] && texs[0].txn) || txn,
            }, meta);
            if (c) { entry.res = c.res; }
            upsert(templates, entry);
            rmWork(workDir);
            return entry;
        }

        // Fully done? (glb present AND every variant's PNG already
        // extracted) → just re-list and skip. If the glb exists but the
        // textures are MISSING, fall through and extract them - so a
        // plain re-run (double-click, no --force) fixes texture-less items.
        const texturesReady = variants.length === 0 || variants.every(v => fs.existsSync(pngPathOf(v)));
        if (!FORCE && fs.existsSync(outGlb) && isGlb(outGlb) && texturesReady) {
            const textures = variants.map(v => {
                const png = pngPathOf(v);
                if (!fs.existsSync(png)) { return null; }
                const dim = pngSize(fs.readFileSync(png)) || { w: 1024, h: 1024 };
                return { id: v.letter, txn: v.txn, file: path.basename(png), w: dim.w, h: dim.h };
            }).filter(Boolean);
            const e = finalize(textures, true);
            console.log('SKIP (exists):', e.res + '/' + e.glb, textures.length ? '(' + textures.length + ' textures)' : '');
            skip++;
            continue;
        }

        console.log('CONVERT: ' + safeBase + '  (' + variants.length + ' texture' + (variants.length === 1 ? '' : 's') + ')');

        /* 1. textures - every .ytd decoded right here, never uploaded. */
        const textures = [];
        for (const v of variants) {
            const pngPath = pngPathOf(v);
            process.stdout.write('  · ' + v.txn + '  ... ');
            if (!FORCE && fs.existsSync(pngPath)) {
                const dim = pngSize(fs.readFileSync(pngPath)) || { w: 1024, h: 1024 };
                textures.push({ id: v.letter, txn: v.txn, file: path.basename(pngPath), w: dim.w, h: dim.h });
                console.log('exists (' + dim.w + 'x' + dim.h + ')');
                continue;
            }
            const t = localTexture(v.path, pngPath, v.txn);
            if (t.ok) {
                textures.push({ id: v.letter, txn: v.txn, file: path.basename(pngPath), w: t.w, h: t.h });
                texCount++;
                console.log('OK (' + t.w + 'x' + t.h + ' ' + t.format + ')');
            } else {
                texFail++;
                console.log('SKIPPED (' + t.err + ')');
                failures.push({ item: v.txn, reason: 'texture: ' + t.err });
            }
        }

        /* 2. mesh - local reader first; the hosted service only if the
              reader cannot make sense of this particular file. */
        let modelSaved = false;
        if (!FORCE && fs.existsSync(outGlb) && isGlb(outGlb)) {
            console.log('  · mesh  ... exists');
            modelSaved = true;
        } else {
            process.stdout.write('  · mesh  ... ');
            const m = localMesh(ydd, outGlb, safeBase);
            if (m.ok) {
                modelSaved = true;
                console.log('OK (' + m.stats.triangles + ' triangles, ' + m.stats.meshes + ' mesh' + (m.stats.meshes === 1 ? '' : 'es') + ')');
            } else {
                console.log('local reader failed (' + m.err + ')');
                process.stdout.write('  · mesh via hosted fallback  ... ');
                // With no local texture at all, let the service embed the
                // first .ytd so the studio still opens on the real texture.
                const embedYtd = (!textures.length && variants.length) ? variants[0].path : null;
                // An escrow-encrypted file is unreadable for the hosted service
                // too - don't spend one of the day's three requests on it.
                const r = /FXAP/.test(m.err)
                    ? { ok: false, skipped: 'encrypted files cannot be converted anywhere' }
                    : await apiMesh(ydd, outGlb, safeBase, embedYtd);
                if (r.ok) {
                    modelSaved = true;
                    console.log('OK');
                } else if (r.skipped) {
                    console.log('SKIPPED (' + r.skipped + ')');
                    failures.push({ item: safeBase, reason: 'mesh: ' + m.err + '; ' + r.skipped });
                } else {
                    console.log('FAILED (' + why(r) + ')');
                    failures.push({ item: safeBase, reason: 'mesh: ' + m.err + '; hosted fallback: ' + why(r) });
                }
            }
        }

        const e = finalize(textures, modelSaved);
        if (modelSaved) { console.log('  -> ' + e.res + '/' + e.glb); ok++; } else { fail++; }
    }

    saveTemplates(templates);
    rmWork(WORK_DIR);
    packs.writeManifests();
    console.log(`\nDone. items: ${ok} ok, ${skip} skipped, ${fail} failed  ·  textures: ${texCount} written` + (texFail ? `, ${texFail} skipped` : ''));
    packs.report();
    printUpload(packs);

    if (failures.length) {
        console.log('\nNot everything converted:');
        for (const f of failures) { console.log('  · ' + f.item + ' - ' + f.reason); }
        console.log('\nWhat the reasons mean:');
        console.log('  · "unsupported texture format …" → that .ytd uses a format this reader does not');
        console.log('                       decode yet (e.g. BC7). The garment still works: it opens on a');
        console.log('                       blank sheet and exports to the correct texture name.');
        console.log('  · "escrow-encrypted (FXAP)" → that file is the protected copy from an escrowed');
        console.log('                       pack; use the readable one (usually the same name under stream/).');
        console.log('  · "not an RSC7 …" / "bad pointer" / "runs past" → the file is damaged or not a');
        console.log('                       GTA V (legacy) resource. Re-export it from OpenIV/CodeWalker.');
        if (quotaExhausted) {
            console.log('  · "http 429"       → the hosted fallback allows 3 conversions per IP per 24 h');
            console.log('                       (10 with a free key from https://gtax.dev/api-keys, set as');
            console.log('                       V_DRAWABLE_TO_GLB_API_KEY). It is only used for files the local');
            console.log('                       reader could not decode. Re-run tomorrow: only the items still');
            console.log('                       missing a .glb are sent.');
        }
        if (failures.some(f => /http 422|http 400/.test(f.reason))) {
            console.log('  · "http 422/400"   → the hosted service could not process that file either.');
        }
        if (failures.some(f => /http 000/.test(f.reason))) {
            console.log('  · "http 000"       → the connection dropped mid-upload. Re-run.');
        }
    }
    if (apiCalls) {
        console.log('\nHosted fallback used: ' + apiCalls + ' request' + (apiCalls === 1 ? '' : 's') + ' (' + API_BASE + ').');
    }
}

// ⚠ This tool writes to the copy of apex_clothing it is sitting in.
// Running it on a Windows PC while the game server is a Linux VPS - the
// normal setup - means NOTHING has reached the server yet, and that step
// was documented nowhere. Spell it out with real paths.
function printUpload(packs) {
    console.log('\nWritten on THIS machine:');
    console.log('   ' + TEMPLATES_JSON);
    for (const p of packs.packs) { console.log('   ' + p.dir + path.sep + '   (whole folder: fxmanifest.lua + models/)'); }
    console.log('\nIf the game server is a DIFFERENT machine (e.g. a Linux VPS and this is');
    console.log('your Windows PC), upload templates.json into the server copy of ' + RESOURCE_NAME + ',');
    console.log('and each model pack folder NEXT TO it (same resources/ folder, e.g.');
    console.log('   resources/[RECORDKIT]/' + RESOURCE_NAME + '/templates.json');
    console.log('   resources/[RECORDKIT]/' + RESOURCE_NAME + '_models/');
    console.log('). Then add the ensure line(s) above to server.cfg, once, and in the');
    console.log('server console:  refresh ; ensure ' + RESOURCE_NAME + '_models ; restart ' + RESOURCE_NAME);
    console.log('(or /clothingtemplates in game), and open the studio.');
}

main().catch(e => { console.error('\nFAILED: ' + (e && e.stack || e)); process.exit(1); });
