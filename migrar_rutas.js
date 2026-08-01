// migrar_rutas.js
const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const serviceAccount = require('./serviceAccountKey.json');

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

async function migrarRutas() {
  console.log('🔍 Leyendo colección rutas...');
  const snapshot = await db.collection('rutas').get();
  console.log(`📦 ${snapshot.size} documentos encontrados\n`);

  let migrados = 0;
  let omitidos = 0;
  let errores = 0;

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const idActual = doc.id;
    const nuevoId = data.nombre?.toString().trim();

    if (!nuevoId) {
      console.log(`⚠️  Sin campo 'nombre' — omitido: ${idActual}`);
      omitidos++;
      continue;
    }

    if (idActual === nuevoId) {
      console.log(`⏭️  Ya correcto: ${nuevoId}`);
      omitidos++;
      continue;
    }

    try {
      await db.collection('rutas').doc(nuevoId).set(data);
      await db.collection('rutas').doc(idActual).delete();
      console.log(`✅ ${idActual.substring(0,15)}... → "${nuevoId}"`);
      migrados++;
    } catch (e) {
      console.log(`❌ Error en ${idActual}: ${e.message}`);
      errores++;
    }
  }

  console.log('\n════════════════════════════');
  console.log(`✅ Migrados:  ${migrados}`);
  console.log(`⏭️  Omitidos:  ${omitidos}`);
  console.log(`❌ Errores:   ${errores}`);
  console.log('════════════════════════════');
  console.log('🎉 Migración completada');
  process.exit(0);
}

migrarRutas().catch(err => {
  console.error('❌ Error fatal:', err.message);
  process.exit(1);
});
