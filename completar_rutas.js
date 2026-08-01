// completar_rutas.js
// Agrega campos faltantes a todos los documentos de la colección 'rutas'
// Uso: node completar_rutas.js

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const serviceAccount = require('./serviceAccountKey.json');

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

async function completarRutas() {
  console.log('🔍 Leyendo colección rutas...');
  const snapshot = await db.collection('rutas').get();
  console.log(`📦 ${snapshot.size} documentos encontrados\n`);

  let actualizados = 0;
  let sinCambios = 0;
  let errores = 0;
  const zonasBad = [];

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const nombre = data.nombre || doc.id;
    const updates = {};
    const cambios = [];

    // ── ciudad ───────────────────────────────────────────────
    if (!data.ciudad) {
      const n = nombre.toLowerCase();
      if (n.includes('bogot') || n.includes('candelaria bogot')) {
        updates.ciudad = 'Bogotá';
        cambios.push('ciudad: Bogotá');
      } else if (n.includes('popay') || n.includes('cauca') || n.includes('ciudad blanca')) {
        updates.ciudad = 'Popayán';
        cambios.push('ciudad: Popayán');
      } else {
        updates.ciudad = 'Medellín';
        cambios.push('ciudad: Medellín');
      }
    }

    // ── pais ─────────────────────────────────────────────────
    if (!data.pais) {
      updates.pais = 'Colombia';
      cambios.push('pais: Colombia');
    }

    // ── pausada ──────────────────────────────────────────────
    if (data.pausada === undefined || data.pausada === null) {
      updates.pausada = false;
      cambios.push('pausada: false');
    }

    // ── activa ───────────────────────────────────────────────
    if (data.activa === undefined || data.activa === null) {
      updates.activa = true;
      cambios.push('activa: true');
    }

    // ── zona inválida — solo reportar, no cambiar ─────────────
    const zonasValidas = ['Ciudad', 'Alrededores', 'Temporada', 'Comida Urbana', 'Eventos'];
    if (data.zona && !zonasValidas.includes(data.zona)) {
      zonasBad.push(`  "${nombre}" → zona actual: "${data.zona}"`);
    }

    // ── aplicar ──────────────────────────────────────────────
    if (Object.keys(updates).length > 0) {
      try {
        await db.collection('rutas').doc(doc.id).update(updates);
        console.log(`✅ ${nombre}`);
        cambios.forEach(c => console.log(`   + ${c}`));
        actualizados++;
      } catch (e) {
        console.log(`❌ Error en "${nombre}": ${e.message}`);
        errores++;
      }
    } else {
      console.log(`⏭️  OK: ${nombre}`);
      sinCambios++;
    }
  }

  console.log('\n════════════════════════════════════════');
  console.log(`✅ Actualizados: ${actualizados}`);
  console.log(`⏭️  Sin cambios:  ${sinCambios}`);
  console.log(`❌ Errores:      ${errores}`);
  console.log('════════════════════════════════════════');

  if (zonasBad.length > 0) {
    console.log('\n⚠️  ZONAS INVÁLIDAS — revisar manualmente en Firestore:');
    zonasBad.forEach(z => console.log(z));
  }

  console.log('\n🎉 Completado');
  process.exit(0);
}

completarRutas().catch(err => {
  console.error('❌ Error fatal:', err.message);
  process.exit(1);
});
