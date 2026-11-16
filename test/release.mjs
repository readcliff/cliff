// Writes version.json next to cliff.mjs: the version, size and SHA-256 that install.sh and `cliff update` check.
// Run after every change to cliff.mjs: node test/release.mjs
import { readFileSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
const dir = new URL('../', import.meta.url);
const body = readFileSync(new URL('cliff.mjs', dir));
const version = body.toString('utf8').match(/export const VERSION = '([^']+)'/)[1];
const out = {
  version,
  file: 'cliff.mjs',
  bytes: body.length,
  sha256: createHash('sha256').update(body).digest('hex'),
  node: '>=18',
  license: 'MIT',
  released: '2026-11-16',
};
writeFileSync(new URL('version.json', dir), JSON.stringify(out, null, 2) + '\n');
console.log(`version.json: cliff ${version}, ${out.bytes} bytes, sha256 ${out.sha256}`);
