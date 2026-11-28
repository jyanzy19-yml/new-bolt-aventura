#!/usr/bin/env node
/** Renders a top-level layout SVG of a level package (design aid, not a runtime asset). */
import { readFileSync, writeFileSync } from 'node:fs';

const [levelPath, contentPath, outPath] = process.argv.slice(2);
if (!levelPath || !contentPath || !outPath) {
  process.stderr.write('uso: render-level-svg.js <level.json> <content.json> <out.svg>\n');
  process.exit(2);
}
const level = JSON.parse(readFileSync(levelPath, 'utf8'));
const content = JSON.parse(readFileSync(contentPath, 'utf8'));
const b = level.bounds;
const S = 0.22;
const pad = 20;
const W = Math.round(b.width * S) + pad * 2;
const H = Math.round((b.height - 240) * S) + pad * 2 + 40;
const X = (x) => (pad + x * S).toFixed(1);
const Y = (y) => (pad + 30 + (y - 240) * S).toFixed(1);
const L = (v) => (v * S).toFixed(1);
const esc = (t) => String(t).replace(/&/g, '&amp;').replace(/</g, '&lt;');
const out = [];
out.push(`<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}" font-family="sans-serif" font-size="9">`);
out.push(`<title>${esc(level.id)} — layout de design (não é asset)</title><rect width="100%" height="100%" fill="#10151c"/>`);
const tints = ['#1c2733', '#202b26', '#2b2620', '#27202b', '#2b2023', '#1f2a2b'];
content.sections.forEach((s, i) => {
  out.push(`<rect x="${X(s.x0)}" y="${pad + 14}" width="${L(s.x1 - s.x0)}" height="${H - pad * 2 - 14}" fill="${tints[i % 6]}" opacity="0.7"/>`);
  out.push(`<text x="${Number(X(s.x0)) + 3}" y="${pad + 10}" fill="#9fb4c8">${esc(s.id)}</text>`);
});
for (const h of content.hazards) {
  const r = h.rect;
  const kill = h.kind === 'killzone';
  out.push(`<rect x="${X(r.x)}" y="${Y(r.y)}" width="${L(r.width)}" height="${L(r.height)}" fill="${kill ? '#c0392b' : '#7a5c1e'}" opacity="0.55"><title>${esc(h.id)}</title></rect>`);
}
for (const s of level.geometry.solids) out.push(`<rect x="${X(s.x)}" y="${Y(s.y)}" width="${L(s.width)}" height="${L(s.height)}" fill="#5d6b7a"><title>${esc(s.id)}</title></rect>`);
for (const s of level.geometry.oneWayPlatforms) out.push(`<rect x="${X(s.x)}" y="${Y(s.y)}" width="${L(s.width)}" height="3" fill="#e6c55a"><title>${esc(s.id)}</title></rect>`);
for (const g of content.gates) out.push(`<rect x="${X(g.rect.x)}" y="${Y(g.rect.y)}" width="${L(g.rect.width)}" height="${L(g.rect.height)}" fill="#3498db"><title>${esc(g.id)}</title></rect>`);
const route = content.route.main.map((n) => `${X(n.x)},${Y(level.geometry.solids.concat(level.geometry.oneWayPlatforms).find((s) => s.id === n.solid).y - 20)}`);
out.push(`<polyline points="${route.join(' ')}" fill="none" stroke="#2ecc71" stroke-width="1.4"/>`);
for (const c of level.checkpoints) out.push(`<circle cx="${X(c.x)}" cy="${Y(c.y - 14)}" r="4" fill="#1abc9c"><title>${esc(c.id)}</title></circle>`);
for (const e of content.enemies) out.push(`<rect x="${X(e.patrol.minX)}" y="${Y(level.geometry.solids.find((s) => s.id === e.solid).y - e.size.height)}" width="${L(e.patrol.maxX - e.patrol.minX)}" height="${L(e.size.height)}" fill="#e67e22" opacity="0.8"><title>${esc(e.id)}</title></rect>`);
for (const x of level.exits) out.push(`<rect x="${X(x.x)}" y="${Y(x.y)}" width="${L(x.width)}" height="${L(x.height)}" fill="#9b59b6"><title>${esc(x.id)}</title></rect>`);
out.push(`<circle cx="${X(level.spawn.x)}" cy="${Y(level.spawn.y)}" r="4" fill="#fff"/>`);
const lg = [['#5d6b7a', 'sólido'], ['#e6c55a', 'unidirecional'], ['#2ecc71', 'rota principal'], ['#1abc9c', 'checkpoint'], ['#e67e22', 'patrulha'], ['#c0392b', 'zona letal'], ['#7a5c1e', 'vala de recuperação'], ['#3498db', 'portão'], ['#9b59b6', 'saída']];
lg.forEach(([c, t], i) => out.push(`<rect x="${pad + i * 100}" y="${H - 14}" width="8" height="8" fill="${c}"/><text x="${pad + i * 100 + 11}" y="${H - 6}" fill="#cbd5df">${t}</text>`));
out.push('</svg>');
writeFileSync(outPath, out.join('\n') + '\n');
