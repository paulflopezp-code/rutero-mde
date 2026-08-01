/**
 * revertir_zonas.js
 * Rutero MDE — Revertir zona de Miradores y Metrocable a Ciudad
 */

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const serviceAccount = require('./serviceAccountKey.json');

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

const REVERTIR = [
  { nombre: 'RUTA DE LOS MIRADORES',      zona: 'Ciudad' },
  { nombre: 'RUTA DEL METROCABLE & ARVÍ', zona: 'Ciudad' },
];

async function main() {
  for (const { nombre, zona } of REVERTIR) {
    const snap = await db.collection('rutas').where('nombre', '==', nombre).limit(1).get();
    if (snap.empty) { console.log(`⚠️  No encontrada: "${nombre}"`); continue; }
    await snap.docs[0].ref.update({ zona, modificadoPor: 'revertir_zonas.js 28jul2026' });
    console.log(`✅  "${nombre}" → zona: "${zona}"`);
  }
  console.log('\nListo.');
  process.exit(0);
}

main().catch(e => { console.error(e); process.exit(1); });
