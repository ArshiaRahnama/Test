/* ─────────────────────────────────────────────────────────────
   Apex Studios - local RAGE resource reader (Node, no deps)

   Reads the GTA V files a garment or a vehicle ships as, WITHOUT any
   external service or software:

     .ydd  (drawable dictionary)  → mesh per geometry → .glb bytes
     .yft  (fragment: vehicles)   → the fragment's drawable → .glb
     .ytd  (texture dictionary)   → every texture → RGBA → .png

   All three are RSC7 containers: a 16-byte header, then a raw-deflate
   stream holding the "system" segment (structs, pointers) followed
   by the "graphics" segment (vertex / index / pixel data). Pointers
   are 0x50000000|offset into system and 0x60000000|offset into
   graphics. Struct offsets below are the ones the game uses
   (rmcDrawable / grmShaderGroup / grmModel / grmGeometry /
   grcVertexBuffer / grcIndexBuffer / grcTexture / fragType) - the
   same layout tools/FORMAT.md of apex_props documents from dissecting
   632 real drawables, and the same layout CodeWalker reads.

   Exports:
     readYdd(buf)             → { drawables:[…] }
     readYft(buf)             → { drawables:[…] }   (main fragment drawable)
     yddToGlb(buf, opts)      → { glb, stats }       (garments)
     drawableToMeshes(d, lookup) → meshes with resolved material names
     buildGlb(meshes, opts)   → Buffer (binary glTF 2.0, textures optional)
     readYtd(buf)             → { rsc, textures:[{name,w,h,format,…}] }
     decodeTexture(rsc, tex)  → { rgba, w, h, format, name }
     ytdToPng(buf, prefer)    → { png, w, h, name, format }
     ytdTextures(buf)         → [{ name, w, h, format, png }] (all decodable)
     encodePng(rgba, w, h)    → Buffer
   ───────────────────────────────────────────────────────────── */
'use strict';

const zlib = require('zlib');

/* ── RSC7 container ─────────────────────────────────────────── */

// Segment size from the header flag word (CodeWalker GetSizeFromFlags).
function pageSize(flags) {
    const ss = flags & 0xF;
    const base = 0x200 << ss;
    const n = (((flags >>> 27) & 0x1) << 0) + (((flags >>> 26) & 0x1) << 1) +
        (((flags >>> 25) & 0x1) << 2) + (((flags >>> 24) & 0x1) << 3) +
        (((flags >>> 17) & 0x7F) << 4) + (((flags >>> 11) & 0x3F) << 5) +
        (((flags >>> 7) & 0xF) << 6) + (((flags >>> 5) & 0x3) << 7) +
        (((flags >>> 4) & 0x1) << 8);
    return base * n;
}

class Rsc {
    constructor(buf) {
        if (!buf || buf.length < 16) { throw new Error('not an RSC7 resource (too small)'); }
        const magic = buf.toString('ascii', 0, 4);
        if (magic === 'FXAP') { throw new Error('escrow-encrypted (FXAP) - this file cannot be read outside the game; use the original from the pack'); }
        if (magic !== 'RSC7') { throw new Error('not an RSC7 resource (bad magic)'); }
        this.version = buf.readUInt32LE(4);
        this.sysFlags = buf.readUInt32LE(8);
        this.gfxFlags = buf.readUInt32LE(12);
        this.sysSize = pageSize(this.sysFlags);
        this.gfxSize = pageSize(this.gfxFlags);
        this.p = zlib.inflateRawSync(buf.slice(16));
        if (this.p.length < this.sysSize) {
            throw new Error('truncated resource: ' + this.p.length + ' bytes inflated, system segment says ' + this.sysSize);
        }
    }
    // 64-bit pointer at `off` → absolute payload offset, or -1 for null.
    ptr(off) {
        if (off < 0 || off + 8 > this.p.length) { throw new Error('pointer read outside payload @' + off); }
        const lo = this.p.readUInt32LE(off), hi = this.p.readUInt32LE(off + 4);
        if (!lo && !hi) { return -1; }
        const seg = lo >>> 28, rel = lo & 0x0FFFFFFF;
        let abs;
        if (seg === 5) { abs = rel; }
        else if (seg === 6) { abs = this.sysSize + rel; }
        else { throw new Error('bad pointer 0x' + lo.toString(16) + ' @' + off); }
        if (abs >= this.p.length) { throw new Error('pointer past end 0x' + lo.toString(16) + ' @' + off); }
        return abs;
    }
    // Same, but never throws: -1 for anything that is not a clean pointer.
    tryPtr(off) { try { return this.ptr(off); } catch (e) { return -1; } }
    u8(o) { return this.p.readUInt8(o); }
    u16(o) { return this.p.readUInt16LE(o); }
    u32(o) { return this.p.readUInt32LE(o); }
    f32(o) { return this.p.readFloatLE(o); }
    str(off, max) {
        if (off < 0) { return ''; }
        let end = off;
        const lim = Math.min(this.p.length, off + (max || 256));
        while (end < lim && this.p[end] !== 0) { end++; }
        return this.p.toString('latin1', off, end);
    }
}

// pgDictionary<T>: 0x20 hashes (ptr, u16 count), 0x30 entries (ptr[], u16 count)
function readDictionary(rsc, off) {
    const hashArr = rsc.ptr(off + 0x20), hashCount = rsc.u16(off + 0x28);
    const entArr = rsc.ptr(off + 0x30), entCount = rsc.u16(off + 0x38);
    if (entArr < 0 || entCount === 0 || entCount > 4096) {
        throw new Error('dictionary has no entries (count ' + entCount + ')');
    }
    const out = [];
    for (let i = 0; i < entCount; i++) {
        const hash = (hashArr >= 0 && i < hashCount) ? rsc.u32(hashArr + i * 4) : 0;
        const p = rsc.ptr(entArr + i * 8);
        if (p >= 0) { out.push({ hash, off: p }); }
    }
    return out;
}

/* ── vertex declaration ─────────────────────────────────────── */

const SLOT = { POSITION: 0, BLENDWEIGHTS: 1, BLENDINDICES: 2, NORMAL: 3, COLOUR0: 4, COLOUR1: 5, TEXCOORD0: 6, TEXCOORD1: 7, TANGENT: 14, BINORMAL: 15 };
// grcFvf component types → byte size
const TYPE_SIZE = { 0: 0, 1: 4, 2: 4, 3: 8, 4: 4, 5: 8, 6: 12, 7: 16, 8: 4, 9: 4, 10: 4, 11: 2, 12: 2, 13: 2, 14: 2, 15: 2 };
const TYPE_NAME = { 1: 'half2', 2: 'float', 3: 'half4', 5: 'float2', 6: 'float3', 7: 'float4', 8: 'ubyte4', 9: 'colour', 10: 'dec3n' };

function readDeclaration(rsc, off) {
    const flags = rsc.u32(off), stride = rsc.u16(off + 4);
    const tLo = rsc.u32(off + 8), tHi = rsc.u32(off + 12);
    const slots = [];
    let at = 0, exact = true;
    for (let i = 0; i < 16; i++) {
        if (!(flags & (1 << i))) { continue; }
        const nib = i < 8 ? ((tLo >>> (i * 4)) & 0xF) : ((tHi >>> ((i - 8) * 4)) & 0xF);
        const size = TYPE_SIZE[nib];
        if (size === undefined) { exact = false; break; }
        slots[i] = { type: nib, offset: at, size };
        at += size;
    }
    if (at !== stride) { exact = false; }
    return { flags, stride, slots, exact };
}

function half(u) {
    const s = (u >> 15) & 1, e = (u >> 10) & 0x1F, m = u & 0x3FF;
    let v;
    if (e === 0) { v = m * Math.pow(2, -24); }
    else if (e === 31) { v = m ? NaN : Infinity; }
    else { v = (1 + m / 1024) * Math.pow(2, e - 15); }
    return s ? -v : v;
}

function readVec(rsc, base, slot, want) {
    // Returns `want` floats (2 or 3) from a slot, or null if unreadable.
    const t = slot.type;
    if (t === 5 || t === 6 || t === 7 || t === 2) {
        const n = t === 2 ? 1 : (t === 5 ? 2 : (t === 6 ? 3 : 4));
        if (n < want) { return null; }
        const out = [];
        for (let k = 0; k < want; k++) { out.push(rsc.f32(base + k * 4)); }
        return out;
    }
    if (t === 1 || t === 3) {
        const n = t === 1 ? 2 : 4;
        if (n < want) { return null; }
        const out = [];
        for (let k = 0; k < want; k++) { out.push(half(rsc.u16(base + k * 2))); }
        return out;
    }
    if (t === 10 && want === 3) {          // Dec3N: 10-bit signed normalized xyz
        const u = rsc.u32(base);
        const s10 = (v) => { v &= 0x3FF; return (v & 0x200) ? (v - 0x400) : v; };
        return [s10(u) / 511, s10(u >>> 10) / 511, s10(u >>> 20) / 511];
    }
    return null;
}

/* ── geometry ───────────────────────────────────────────────── */

function readGeometry(rsc, off) {
    const vbOff = rsc.ptr(off + 0x18), ibOff = rsc.ptr(off + 0x38);
    if (vbOff < 0 || ibOff < 0) { throw new Error('geometry without vertex/index buffer'); }
    const stride = rsc.u16(vbOff + 0x08);
    const vcount = rsc.u32(vbOff + 0x18);
    let vdata = rsc.ptr(vbOff + 0x10);
    if (vdata < 0) { vdata = rsc.ptr(vbOff + 0x20); }
    if (vdata < 0) { vdata = rsc.ptr(off + 0x78); }
    const declOff = rsc.ptr(vbOff + 0x30);
    if (vdata < 0 || declOff < 0) { throw new Error('vertex buffer has no data / declaration'); }
    if (vcount === 0 || vcount > 1000000) { throw new Error('implausible vertex count ' + vcount); }
    const decl = readDeclaration(rsc, declOff);
    if (decl.stride !== stride) { throw new Error('vertex stride mismatch (' + decl.stride + ' vs ' + stride + ')'); }
    if (!decl.slots[SLOT.POSITION]) { throw new Error('vertex layout has no position'); }
    if (vdata + vcount * stride > rsc.p.length) { throw new Error('vertex data runs past the payload'); }

    let icount = rsc.u32(ibOff + 0x08) || rsc.u32(off + 0x58);
    const idata = rsc.ptr(ibOff + 0x10);
    if (idata < 0 || icount === 0) { throw new Error('geometry has no index data'); }
    icount -= icount % 3;
    if (idata + icount * 2 > rsc.p.length) { throw new Error('index data runs past the payload'); }

    const pos = new Float32Array(vcount * 3);
    const sP = decl.slots[SLOT.POSITION], sUv = decl.slots[SLOT.TEXCOORD0], sUv1 = decl.slots[SLOT.TEXCOORD1], sN = decl.slots[SLOT.NORMAL];
    const uv = sUv ? new Float32Array(vcount * 2) : null;
    const uv1 = sUv1 ? new Float32Array(vcount * 2) : null;
    const nrm = (sN && (sN.type === 6 || sN.type === 10 || sN.type === 7 || sN.type === 3)) ? new Float32Array(vcount * 3) : null;
    for (let i = 0; i < vcount; i++) {
        const b = vdata + i * stride;
        const p = readVec(rsc, b + sP.offset, sP, 3);
        if (!p) { throw new Error('unsupported position type ' + (TYPE_NAME[sP.type] || sP.type)); }
        pos[i * 3] = p[0]; pos[i * 3 + 1] = p[1]; pos[i * 3 + 2] = p[2];
        if (uv) {
            const t = readVec(rsc, b + sUv.offset, sUv, 2);
            if (!t) { throw new Error('unsupported texcoord type ' + (TYPE_NAME[sUv.type] || sUv.type)); }
            uv[i * 2] = t[0]; uv[i * 2 + 1] = t[1];
        }
        if (uv1) {
            const t = readVec(rsc, b + sUv1.offset, sUv1, 2);
            if (t) { uv1[i * 2] = t[0]; uv1[i * 2 + 1] = t[1]; }
        }
        if (nrm) {
            const n = readVec(rsc, b + sN.offset, sN, 3);
            if (n) {
                const len = Math.hypot(n[0], n[1], n[2]) || 1;
                nrm[i * 3] = n[0] / len; nrm[i * 3 + 1] = n[1] / len; nrm[i * 3 + 2] = n[2] / len;
            }
        }
    }
    const idx = new Uint16Array(icount);
    for (let i = 0; i < icount; i++) { idx[i] = rsc.u16(idata + i * 2); }
    // Every index must address a real vertex - a mislaid pointer would
    // otherwise produce a "mesh" of garbage that still loads.
    for (let i = 0; i < icount; i++) { if (idx[i] >= vcount) { throw new Error('index ' + idx[i] + ' out of range (' + vcount + ' vertices)'); } }

    return { vertices: vcount, positions: pos, normals: nrm, uvs: uv, uvs2: uv1, indices: idx, stride, layout: decl };
}

// grmModel: 0x08 geometry ptr[], 0x10 count, 0x20 shader mapping u16[]
function readModel(rsc, off) {
    const arr = rsc.ptr(off + 0x08), count = rsc.u16(off + 0x10);
    const shaderMap = rsc.ptr(off + 0x20);
    const geoms = [];
    for (let i = 0; i < count && arr >= 0; i++) {
        const g = rsc.ptr(arr + i * 8);
        if (g < 0) { continue; }
        const geo = readGeometry(rsc, g);
        geo.shader = shaderMap >= 0 ? rsc.u16(shaderMap + i * 2) : 0;
        geoms.push(geo);
    }
    return { geometries: geoms };
}

// ResourcePointerList64<grmModel>: 0x00 ptr[], 0x08 count
function readModelList(rsc, listOff) {
    if (listOff < 0) { return []; }
    const arr = rsc.ptr(listOff), count = rsc.u16(listOff + 8);
    const out = [];
    for (let i = 0; i < count && arr >= 0; i++) {
        const m = rsc.ptr(arr + i * 8);
        if (m >= 0) { out.push(readModel(rsc, m)); }
    }
    return out;
}

/* ── shader group (which texture each geometry samples) ─────── */

// Shader parameter names are stored as joaat hashes of the lower-case name.
function joaat(s) {
    let h = 0; s = String(s).toLowerCase();
    for (let i = 0; i < s.length; i++) { h = (h + s.charCodeAt(i)) >>> 0; h = (h + (h << 10)) >>> 0; h ^= h >>> 6; }
    h = (h + (h << 3)) >>> 0; h ^= h >>> 11; h = (h + (h << 15)) >>> 0;
    return h >>> 0;
}
const HASH_DIFFUSE = joaat('DiffuseSampler');    // 0xF1FE2B71
const HASH_DIFFUSE2 = joaat('DiffuseSampler2');  // 0x0AD3A268 - vehicle LIVERY sampler
const HASH_PLATEBG = joaat('PlateBgSampler');    // licence plate background

// grmShaderGroup: 0x08 embedded texture dictionary, 0x10 shader ptr[], 0x18 count.
// grmShader (0x30): 0x00 parameter block, 0x08 name hash, 0x10 parameter count.
// Parameter block: 16-byte entries {u8 type (0 = texture, n = n×vec4);
// u64 data ptr @+8}, then the vec4 data, then the u32 name-hash array.
function readShaderGroup(rsc, off) {
    const out = { textures: [], shaders: [], errors: [] };
    const dictOff = rsc.tryPtr(off + 0x08);
    if (dictOff >= 0) {
        try { out.textures = readDictionary(rsc, dictOff).map(e => readTextureAt(rsc, e.off)); }
        catch (e) { out.errors.push('embedded textures: ' + e.message); }
    }
    const arr = rsc.tryPtr(off + 0x10), count = rsc.u16(off + 0x18);
    for (let i = 0; i < count && arr >= 0; i++) {
        const sh = { diffuse: null, livery: null, plate: null, hash: 0, sps: 0, samplers: [] };
        try {
            const sOff = rsc.ptr(arr + i * 8);
            if (sOff < 0) { out.shaders.push(sh); continue; }
            sh.hash = rsc.u32(sOff + 0x08);
            sh.sps = rsc.u32(sOff + 0x18);
            const params = rsc.ptr(sOff), n = rsc.u8(sOff + 0x10);
            if (params >= 0 && n) {
                let vec = 0;
                const types = [];
                for (let j = 0; j < n; j++) { const t = rsc.u8(params + j * 16); types.push(t); vec += 16 * t; }
                const hashes = params + n * 16 + vec;
                for (let j = 0; j < n; j++) {
                    if (types[j] !== 0) { continue; }
                    const h = rsc.u32(hashes + j * 4);
                    const texOff = rsc.tryPtr(params + j * 16 + 8);
                    if (texOff < 0) { continue; }
                    const name = rsc.str(rsc.tryPtr(texOff + 0x28));
                    if (!name) { continue; }
                    sh.samplers.push({ hash: h, name });
                    if (h === HASH_DIFFUSE) { sh.diffuse = name; }
                    else if (h === HASH_DIFFUSE2) { sh.livery = name; }
                    else if (h === HASH_PLATEBG) { sh.plate = name; }
                }
            }
        } catch (e) { out.errors.push('shader ' + i + ': ' + e.message); }
        out.shaders.push(sh);
    }
    return out;
}

/* ── drawable ───────────────────────────────────────────────── */

// rmcDrawable: 0x10 shader group, 0x50/0x58/0x60/0x68 LOD model lists, 0xA8 name
function readDrawable(rsc, off) {
    // Some exporters store the name with a pseudo extension ("jbib_000_u.#dd").
    const name = rsc.str(rsc.tryPtr(off + 0xA8)).replace(/\.(#dd|ydd|#dr|ydr|#ft|yft)$/i, '');
    const sgOff = rsc.tryPtr(off + 0x10);
    const sg = sgOff >= 0 ? readShaderGroup(rsc, sgOff) : { textures: [], shaders: [], errors: [] };
    return {
        name,
        shaders: sg.shaders,
        embedded: sg.textures,
        shaderErrors: sg.errors,
        lods: {
            high: readModelList(rsc, rsc.ptr(off + 0x50)),
            med: readModelList(rsc, rsc.ptr(off + 0x58)),
            low: readModelList(rsc, rsc.ptr(off + 0x60)),
            vlow: readModelList(rsc, rsc.ptr(off + 0x68)),
        },
    };
}

function hasGeometry(d) {
    return ['high', 'med', 'low', 'vlow'].some(l => d.lods[l].some(m => m.geometries.length));
}

function readYdd(buf) {
    const rsc = new Rsc(buf);
    if (rsc.version !== 165) { throw new Error('not a drawable resource (version ' + rsc.version + ', expected 165)'); }
    const entries = readDictionary(rsc, 0);
    const drawables = entries.map(e => Object.assign({ hash: e.hash }, readDrawable(rsc, e.off)));
    return { rsc, drawables };
}

/* .yft (fragType): the vehicle's drawable hangs at root+0x30
   (FragType.DrawablePointer) and starts with the very same rmcDrawable
   struct. A signature scan of the system segment is the fallback for
   exotic exports that shift the header. */
function readYft(buf) {
    const rsc = new Rsc(buf);
    if (rsc.version !== 162) { throw new Error('not a fragment resource (version ' + rsc.version + ', expected 162)'); }
    const drawables = [];
    const mainOff = rsc.tryPtr(0x30);
    let mainErr = null;
    if (mainOff >= 0) {
        try { const d = readDrawable(rsc, mainOff); if (hasGeometry(d)) { drawables.push(d); } }
        catch (e) { mainErr = e.message; }
    }
    if (!drawables.length) {
        for (let cand = 0x40; cand + 0xB0 <= rsc.sysSize; cand += 16) {
            if (cand === mainOff) { continue; }
            if (rsc.tryPtr(cand + 0x10) < 0) { continue; }
            if (rsc.tryPtr(cand + 0x50) < 0 && rsc.tryPtr(cand + 0x58) < 0 && rsc.tryPtr(cand + 0x60) < 0 && rsc.tryPtr(cand + 0x68) < 0) { continue; }
            try { const d = readDrawable(rsc, cand); if (hasGeometry(d)) { drawables.push(d); break; } } catch (e) { /* not a drawable */ }
        }
    }
    if (!drawables.length) { throw new Error('no drawable geometry in the fragment' + (mainErr ? ' (' + mainErr + ')' : '')); }
    return { rsc, drawables };
}

/* ── glTF 2.0 binary writer ─────────────────────────────────── */

function align4(n) { return (n + 3) & ~3; }

/* meshes: [{ name, positions, normals?, uvs?, uvs2?, indices,
             material: 'name' | { name, image?: { name, png } } }]
   opts: { name, rotateZupToYup, doubleSided }
   Same texture name → one shared material / image. */
function buildGlb(meshes, opts) {
    opts = opts || {};
    const views = [], accessors = [], chunks = [];
    let binLen = 0;
    function addView(bytes, target) {
        const off = align4(binLen);
        if (off > binLen) { chunks.push(Buffer.alloc(off - binLen)); binLen = off; }
        chunks.push(bytes); binLen += bytes.length;
        const v = { buffer: 0, byteOffset: off, byteLength: bytes.length };
        if (target) { v.target = target; }
        views.push(v);
        return views.length - 1;
    }
    function addAccessor(view, componentType, count, type, extra) {
        accessors.push(Object.assign({ bufferView: view, componentType, count, type }, extra || {}));
        return accessors.length - 1;
    }
    const gmeshes = [], nodes = [], mats = [], images = [], textures = [];
    const matIndex = new Map(), imgIndex = new Map();
    function imageFor(img) {
        const key = img.name;
        if (imgIndex.has(key)) { return imgIndex.get(key); }
        const view = addView(img.png);
        images.push({ name: img.name, mimeType: 'image/png', bufferView: view });
        textures.push({ name: img.name, sampler: 0, source: images.length - 1 });
        imgIndex.set(key, textures.length - 1);
        return textures.length - 1;
    }
    function matFor(m) {
        const spec = (typeof m === 'string') ? { name: m } : (m || { name: '__default' });
        const name = spec.name || '__default';
        if (matIndex.has(name)) { return matIndex.get(name); }
        const pbr = { metallicFactor: 0, roughnessFactor: 0.8 };
        if (spec.image && spec.image.png) { pbr.baseColorTexture = { index: imageFor(spec.image) }; }
        else { pbr.baseColorFactor = [1, 1, 1, 1]; }
        mats.push({ name, pbrMetallicRoughness: pbr, doubleSided: opts.doubleSided !== false });
        matIndex.set(name, mats.length - 1);
        return mats.length - 1;
    }
    meshes.forEach((m, mi) => {
        const nv = m.positions.length / 3;
        const min = [Infinity, Infinity, Infinity], max = [-Infinity, -Infinity, -Infinity];
        for (let i = 0; i < nv; i++) {
            for (let k = 0; k < 3; k++) {
                const v = m.positions[i * 3 + k];
                if (v < min[k]) { min[k] = v; }
                if (v > max[k]) { max[k] = v; }
            }
        }
        const attributes = {};
        attributes.POSITION = addAccessor(addView(Buffer.from(m.positions.buffer, m.positions.byteOffset, m.positions.byteLength), 34962), 5126, nv, 'VEC3', { min, max });
        if (m.normals) {
            attributes.NORMAL = addAccessor(addView(Buffer.from(m.normals.buffer, m.normals.byteOffset, m.normals.byteLength), 34962), 5126, nv, 'VEC3');
        }
        if (m.uvs) {
            attributes.TEXCOORD_0 = addAccessor(addView(Buffer.from(m.uvs.buffer, m.uvs.byteOffset, m.uvs.byteLength), 34962), 5126, nv, 'VEC2');
        }
        if (m.uvs2) {
            attributes.TEXCOORD_1 = addAccessor(addView(Buffer.from(m.uvs2.buffer, m.uvs2.byteOffset, m.uvs2.byteLength), 34962), 5126, nv, 'VEC2');
        }
        let idxBytes, ctype;
        if (nv > 65535) {
            const a = new Uint32Array(m.indices.length);
            for (let i = 0; i < a.length; i++) { a[i] = m.indices[i]; }
            idxBytes = Buffer.from(a.buffer); ctype = 5125;
        } else {
            const a = m.indices instanceof Uint16Array ? m.indices : Uint16Array.from(m.indices);
            idxBytes = Buffer.from(a.buffer, a.byteOffset, a.byteLength); ctype = 5123;
        }
        const indices = addAccessor(addView(idxBytes, 34963), ctype, m.indices.length, 'SCALAR');
        gmeshes.push({ name: m.name, primitives: [{ attributes, indices, material: matFor(m.material) }] });
        nodes.push({ name: m.name, mesh: mi });
    });
    const children = nodes.map((_, i) => i);
    const root = { name: opts.name || 'drawable', children };
    // GTA is Z-up, glTF is Y-up: a −90° turn about X on the root uprights
    // the model while every vertex stays in raw game coordinates.
    if (opts.rotateZupToYup) { root.rotation = [-0.70710677, 0, 0, 0.70710677]; }
    nodes.push(root);
    const bin = Buffer.concat(chunks);
    const json = {
        asset: { generator: 'apex tools/rage.js', version: '2.0' },
        scene: 0,
        scenes: [{ name: 'Root Scene', nodes: [nodes.length - 1] }],
        nodes, meshes: gmeshes, materials: mats,
        accessors, bufferViews: views,
        buffers: [{ byteLength: bin.length }],
    };
    if (images.length) { json.images = images; json.textures = textures; json.samplers = [{}]; }
    let jsonBuf = Buffer.from(JSON.stringify(json), 'utf8');
    const jpad = align4(jsonBuf.length) - jsonBuf.length;
    if (jpad) { jsonBuf = Buffer.concat([jsonBuf, Buffer.alloc(jpad, 0x20)]); }
    const bpad = align4(bin.length) - bin.length;
    const binOut = bpad ? Buffer.concat([bin, Buffer.alloc(bpad)]) : bin;
    const total = 12 + 8 + jsonBuf.length + 8 + binOut.length;
    const head = Buffer.alloc(12);
    head.write('glTF', 0, 'ascii'); head.writeUInt32LE(2, 4); head.writeUInt32LE(total, 8);
    const jh = Buffer.alloc(8); jh.writeUInt32LE(jsonBuf.length, 0); jh.writeUInt32LE(0x4E4F534A, 4);
    const bh = Buffer.alloc(8); bh.writeUInt32LE(binOut.length, 0); bh.writeUInt32LE(0x004E4942, 4);
    return Buffer.concat([head, jh, jsonBuf, bh, binOut]);
}

/* Highest LOD that has geometry → flat list of meshes. `lookup(name)`
   (optional) returns { name, png } for a GTA texture name, or null; the
   material of each mesh is then named after the texture its shader
   samples - the LIVERY sampler (DiffuseSampler2, the "_sign_N" sheet)
   when that texture exists, else the diffuse - and "__default" when
   neither can be found. That is the naming the studio viewer keys on. */
function drawableToMeshes(d, lookup, opts) {
    opts = opts || {};
    const prefix = opts.prefix || d.name || 'drawable';
    const order = ['high', 'med', 'low', 'vlow'];
    let lodName = null, models = [];
    for (const l of order) {
        if (d.lods[l].some(m => m.geometries.length)) { lodName = l; models = d.lods[l]; break; }
    }
    const meshes = [];
    if (!lodName) { return { meshes, lod: null }; }
    const lodLabel = { high: 'High', med: 'Med', low: 'Low', vlow: 'Vlow' }[lodName];
    models.forEach((m, mi) => {
        m.geometries.forEach((g, gi) => {
            const sh = d.shaders[g.shader] || { diffuse: null, livery: null, plate: null };
            let material = '__default';
            if (lookup) {
                // livery sheet → diffuse → licence-plate background; names are
                // matched case-insensitively and the DICTIONARY's spelling wins
                // (the game hashes names, so case never mattered in-game).
                const hit = (sh.livery && lookup(sh.livery)) || (sh.diffuse && lookup(sh.diffuse)) || (sh.plate && lookup(sh.plate)) || null;
                if (hit) { material = { name: hit.name, image: hit }; }
            } else if (sh.livery || sh.diffuse || sh.plate) {
                material = sh.livery || sh.diffuse || sh.plate;
            }
            meshes.push({
                name: prefix + '_' + lodLabel + '_' + mi + '_' + gi,
                positions: g.positions, normals: g.normals, uvs: g.uvs, uvs2: g.uvs2, indices: g.indices,
                material, shader: sh,
            });
        });
    });
    return { meshes, lod: lodName };
}

/* Whole .ydd → .glb (garments). Raw GTA coordinates (Z-up) and raw UVs,
   no root rotation - exactly what the hosted converter produced for
   clothing, so the viewer's fixed uprighting keeps working unchanged. */
function yddToGlb(buf, opts) {
    opts = opts || {};
    const { drawables } = readYdd(buf);
    const meshes = [];
    let vertices = 0, triangles = 0;
    const used = [];
    drawables.forEach((d, di) => {
        const r = drawableToMeshes(d, null, { prefix: d.name || ('drawable' + di) });
        if (!r.lod) { return; }
        used.push((d.name || ('drawable' + di)) + ':' + r.lod);
        r.meshes.forEach(m => { m.material = 'shader_' + (m.shader ? d.shaders.indexOf(m.shader) : 0); m.uvs2 = null; meshes.push(m); vertices += m.positions.length / 3; triangles += m.indices.length / 3; });
    });
    if (!meshes.length) { throw new Error('the drawable has no geometry'); }
    const name = opts.name || drawables[0].name || 'drawable';
    return { glb: buildGlb(meshes, { name }), stats: { drawables: drawables.length, meshes: meshes.length, vertices, triangles, lods: used, name: drawables[0].name } };
}

/* ── texture dictionary ─────────────────────────────────────── */

const FOURCC = (s) => s.charCodeAt(0) | (s.charCodeAt(1) << 8) | (s.charCodeAt(2) << 16) | (s.charCodeAt(3) << 24);
const FMT_NAME = {};
FMT_NAME[FOURCC('DXT1')] = 'DXT1'; FMT_NAME[FOURCC('DXT3')] = 'DXT3'; FMT_NAME[FOURCC('DXT5')] = 'DXT5';
FMT_NAME[FOURCC('ATI1')] = 'ATI1'; FMT_NAME[FOURCC('ATI2')] = 'ATI2'; FMT_NAME[FOURCC('BC7 ')] = 'BC7';
FMT_NAME[21] = 'A8R8G8B8'; FMT_NAME[32] = 'A8B8G8R8'; FMT_NAME[50] = 'L8'; FMT_NAME[28] = 'A8'; FMT_NAME[25] = 'A1R5G5B5';

function fmtName(f) { return FMT_NAME[f] || ('0x' + (f >>> 0).toString(16)); }

// grcTexture: 0x28 name, 0x50 w, 0x52 h, 0x56 stride, 0x58 format, 0x5D mips, 0x70 pixels (graphics)
function readTextureAt(rsc, t) {
    const name = rsc.str(rsc.ptr(t + 0x28));
    const w = rsc.u16(t + 0x50), h = rsc.u16(t + 0x52), stride = rsc.u16(t + 0x56);
    const format = rsc.u32(t + 0x58), levels = rsc.u8(t + 0x5D);
    const data = rsc.ptr(t + 0x70);
    if (w < 1 || h < 1 || w > 16384 || h > 16384 || data < 0) { throw new Error('texture header out of range'); }
    return { name, w, h, stride, format, levels, data };
}

function readYtd(buf) {
    const rsc = new Rsc(buf);
    let textures = [];
    try {
        if (rsc.version !== 13) { throw new Error('version ' + rsc.version); }
        textures = readDictionary(rsc, 0).map(e => readTextureAt(rsc, e.off));
    } catch (e) {
        // Fallback: scan for a grcTexture header (pow2 size + known
        // format + graphics pointer), the way make_ytd.js locates it.
        textures = [];
        const p = rsc.p;
        for (let i = 64; i + 0x78 <= rsc.sysSize; i++) {
            const w = p.readUInt16LE(i), h = p.readUInt16LE(i + 2);
            if (w < 4 || h < 4 || w > 8192 || h > 8192 || (w & (w - 1)) || (h & (h - 1))) { continue; }
            const f = p.readUInt32LE(i + 8);
            if (!FMT_NAME[f]) { continue; }
            const lv = p.readUInt8(i + 0xD);
            if (lv < 1 || lv > 14) { continue; }
            const lo = p.readUInt32LE(i + 0x20), hi = p.readUInt32LE(i + 0x24);
            if (hi || (lo >>> 28) !== 6) { continue; }
            try { textures.push(readTextureAt(rsc, i - 0x50)); } catch (e2) { /* keep scanning */ }
            i += 0x20;
        }
        if (!textures.length) { throw new Error('no texture found (' + e.message + ')'); }
    }
    return { rsc, textures };
}

/* ── block decompression → RGBA8 ────────────────────────────── */

function c565(v, out, o) {
    const r = (v >> 11) & 0x1F, g = (v >> 5) & 0x3F, b = v & 0x1F;
    out[o] = (r << 3) | (r >> 2); out[o + 1] = (g << 2) | (g >> 4); out[o + 2] = (b << 3) | (b >> 2);
}

function decodeColorBlock(src, o, pal, dxt1) {
    const c0 = src.readUInt16LE(o), c1 = src.readUInt16LE(o + 2);
    c565(c0, pal, 0); c565(c1, pal, 4);
    pal[3] = 255; pal[7] = 255;
    if (c0 > c1 || !dxt1) {
        for (let k = 0; k < 3; k++) {
            pal[8 + k] = (2 * pal[k] + pal[4 + k] + 1) / 3 | 0;
            pal[12 + k] = (pal[k] + 2 * pal[4 + k] + 1) / 3 | 0;
        }
        pal[11] = 255; pal[15] = 255;
    } else {
        for (let k = 0; k < 3; k++) { pal[8 + k] = (pal[k] + pal[4 + k]) >> 1; pal[12 + k] = 0; }
        pal[11] = 255; pal[15] = 0;
    }
    return src.readUInt32LE(o + 4);
}

function decodeBlocks(src, off, w, h, format) {
    const bw = Math.ceil(w / 4), bh = Math.ceil(h / 4);
    const out = Buffer.alloc(w * h * 4);
    const pal = new Uint8Array(16);
    const alpha = new Uint8Array(16);
    const dxt1 = format === 'DXT1';
    const blockBytes = dxt1 ? 8 : 16;
    if (off + bw * bh * blockBytes > src.length) { throw new Error('pixel data runs past the payload'); }
    let o = off;
    for (let by = 0; by < bh; by++) {
        for (let bx = 0; bx < bw; bx++) {
            let hasAlpha = false;
            if (format === 'DXT5') {
                const a0 = src[o], a1 = src[o + 1];
                const av = [a0, a1];
                if (a0 > a1) { for (let j = 1; j <= 6; j++) { av.push(((7 - j) * a0 + j * a1 + 3) / 7 | 0); } }
                else { for (let j = 1; j <= 4; j++) { av.push(((5 - j) * a0 + j * a1 + 2) / 5 | 0); } av.push(0, 255); }
                // 48-bit index stream, 3 bits per texel, little-endian
                let bits = 0, nb = 0, bi = o + 2, k = 0;
                for (let i = 0; i < 16; i++) {
                    while (nb < 3) { bits |= src[bi++] << nb; nb += 8; }
                    alpha[k++] = av[bits & 7]; bits >>>= 3; nb -= 3;
                }
                hasAlpha = true;
                o += 8;
            } else if (format === 'DXT3') {
                for (let i = 0; i < 8; i++) {
                    const v = src[o + i];
                    alpha[i * 2] = (v & 0xF) * 17; alpha[i * 2 + 1] = (v >> 4) * 17;
                }
                hasAlpha = true;
                o += 8;
            }
            const idx = decodeColorBlock(src, o, pal, dxt1);
            o += 8;
            for (let py = 0; py < 4; py++) {
                const y = by * 4 + py;
                if (y >= h) { continue; }
                for (let px = 0; px < 4; px++) {
                    const x = bx * 4 + px;
                    if (x >= w) { continue; }
                    const t = py * 4 + px;
                    const ci = (idx >>> (t * 2)) & 3;
                    const d = (y * w + x) * 4;
                    out[d] = pal[ci * 4]; out[d + 1] = pal[ci * 4 + 1]; out[d + 2] = pal[ci * 4 + 2];
                    out[d + 3] = hasAlpha ? alpha[t] : pal[ci * 4 + 3];
                }
            }
        }
    }
    return out;
}

function decodeRaw(src, off, w, h, format) {
    const out = Buffer.alloc(w * h * 4);
    const n = w * h;
    if (format === 'A8R8G8B8') {
        if (off + n * 4 > src.length) { throw new Error('pixel data runs past the payload'); }
        for (let i = 0; i < n; i++) { const s = off + i * 4, d = i * 4; out[d] = src[s + 2]; out[d + 1] = src[s + 1]; out[d + 2] = src[s]; out[d + 3] = src[s + 3]; }
    } else if (format === 'A8B8G8R8') {
        if (off + n * 4 > src.length) { throw new Error('pixel data runs past the payload'); }
        src.copy(out, 0, off, off + n * 4);
    } else if (format === 'L8') {
        if (off + n > src.length) { throw new Error('pixel data runs past the payload'); }
        for (let i = 0; i < n; i++) { const v = src[off + i], d = i * 4; out[d] = out[d + 1] = out[d + 2] = v; out[d + 3] = 255; }
    } else if (format === 'A8') {
        if (off + n > src.length) { throw new Error('pixel data runs past the payload'); }
        for (let i = 0; i < n; i++) { const d = i * 4; out[d] = out[d + 1] = out[d + 2] = 255; out[d + 3] = src[off + i]; }
    } else {
        throw new Error('unsupported texture format ' + format);
    }
    return out;
}

const SUPPORTED = { DXT1: 1, DXT3: 1, DXT5: 1, A8R8G8B8: 1, A8B8G8R8: 1, L8: 1, A8: 1 };

function decodeTexture(rsc, tex) {
    const f = fmtName(tex.format);
    if (!SUPPORTED[f]) { throw new Error('unsupported texture format ' + f + ' (' + tex.w + 'x' + tex.h + ')'); }
    const rgba = (f === 'DXT1' || f === 'DXT3' || f === 'DXT5')
        ? decodeBlocks(rsc.p, tex.data, tex.w, tex.h, f)
        : decodeRaw(rsc.p, tex.data, tex.w, tex.h, f);
    return { rgba, w: tex.w, h: tex.h, format: f, name: tex.name };
}

/* ── PNG encoder (RGBA8, no filtering, zlib) ───────────────── */

let CRC_TABLE = null;
function crc32(buf) {
    if (!CRC_TABLE) {
        CRC_TABLE = new Int32Array(256);
        for (let n = 0; n < 256; n++) {
            let c = n;
            for (let k = 0; k < 8; k++) { c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1); }
            CRC_TABLE[n] = c;
        }
    }
    let c = -1;
    for (let i = 0; i < buf.length; i++) { c = CRC_TABLE[(c ^ buf[i]) & 0xFF] ^ (c >>> 8); }
    return (c ^ -1) >>> 0;
}
function chunk(type, data) {
    const out = Buffer.alloc(12 + data.length);
    out.writeUInt32BE(data.length, 0);
    out.write(type, 4, 'ascii');
    data.copy(out, 8);
    out.writeUInt32BE(crc32(out.slice(4, 8 + data.length)), 8 + data.length);
    return out;
}
function encodePng(rgba, w, h) {
    const stride = w * 4;
    const raw = Buffer.alloc((stride + 1) * h);
    for (let y = 0; y < h; y++) {
        raw[y * (stride + 1)] = 0;
        rgba.copy(raw, y * (stride + 1) + 1, y * stride, (y + 1) * stride);
    }
    const ihdr = Buffer.alloc(13);
    ihdr.writeUInt32BE(w, 0); ihdr.writeUInt32BE(h, 4);
    ihdr[8] = 8; ihdr[9] = 6; ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
    return Buffer.concat([
        Buffer.from([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]),
        chunk('IHDR', ihdr),
        chunk('IDAT', zlib.deflateSync(raw, { level: 6 })),
        chunk('IEND', Buffer.alloc(0)),
    ]);
}

/* Whole .ytd → PNG of its diffuse texture. `prefer` (the drawable's
   texture name, e.g. jbib_diff_000_a_uni) picks that entry when the
   dictionary holds several; otherwise the largest one wins. */
function ytdToPng(buf, prefer) {
    const { rsc, textures } = readYtd(buf);
    let tex = null;
    if (prefer) {
        const want = String(prefer).toLowerCase();
        tex = textures.find(t => t.name && t.name.toLowerCase() === want) || null;
    }
    if (!tex) {
        // Prefer a decodable texture that is not an obvious normal/spec map.
        const cands = textures.filter(t => SUPPORTED[fmtName(t.format)] && !/_n(rm)?$|_s(pec)?$|_normal$/i.test(t.name || ''));
        const pool = cands.length ? cands : textures;
        tex = pool.slice().sort((a, b) => (b.w * b.h) - (a.w * a.h))[0];
    }
    const d = decodeTexture(rsc, tex);
    return { png: encodePng(d.rgba, d.w, d.h), rgba: d.rgba, w: d.w, h: d.h, name: d.name, format: d.format, count: textures.length };
}

/* Every decodable texture of a dictionary (a .ytd buffer, or an already
   parsed { rsc, textures } such as a drawable's embedded set) as PNGs.
   Undecodable entries are reported in `errors`, never thrown. */
function decodeAll(rsc, textures) {
    const out = [], errors = [];
    for (const t of textures) {
        try {
            const d = decodeTexture(rsc, t);
            out.push({ name: d.name, w: d.w, h: d.h, format: d.format, png: encodePng(d.rgba, d.w, d.h) });
        } catch (e) { errors.push((t.name || '?') + ': ' + e.message); }
    }
    return { textures: out, errors };
}
function ytdTextures(buf) {
    const { rsc, textures } = readYtd(buf);
    return decodeAll(rsc, textures);
}

module.exports = { Rsc, pageSize, joaat, readYdd, readYft, readDrawable, drawableToMeshes, yddToGlb, buildGlb, readYtd, decodeTexture, decodeAll, ytdToPng, ytdTextures, encodePng, fmtName };
