// pausar_rutas_incompletas.js
// Pausa automáticamente rutas que no tienen contenido suficiente para mostrarse
// Criterios de pausa:
//   - Sin sitiosList (o vacío)
//   - Sin sitiosDetalle (o vacío)
//   - nombre contiene palabras clave de ciudades no activas (Bogotá, Popayán)
//   - zona inválida
// Uso: node pausar_rutas_incompletas.js

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const serviceAccount = require('./serviceAccountKey.json');

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

async function pausarRutasIncompletas() {
  console.log('🔍 Leyendo colección rutas...');
  const snapshot = await db.collection('rutas').get();
  console.log(`📦 ${snapshot.size} documentos encontrados\n`);

  const zonasValidas = ['Ciudad', 'Alrededores', 'Temporada', 'Comida Urbana'];
  const ciudadesActivas = ['Medellín'];

  let pausadas = 0;
  let omitidas = 0;
  let errores = 0;
  const reporte = [];

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const nombre = data.nombre || doc.id;
    const razones = [];

    // Ya pausada — omitir
    if (data.pausada === true) {
      console.log(`⏭️  Ya pausada: ${nombre}`);
      omitidas++;
      continue;
    }

    // Ciudad no activa (Bogotá, Popayán)
    const ciudad = data.ciudad || '';
    if (!ciudadesActivas.includes(ciudad) && ciudad !== '') {
      razones.push(`ciudad no activa: ${ciudad}`);
    }

    // Sin sitios
    const sitiosList = data.sitiosList || [];
    const sitiosDetalle = data.sitiosDetalle || [];
    const sitios = data.sitios || 0;

    const tieneSitios = sitiosList.length > 0 || sitiosDetalle.length > 0 || sitios > 0;
    if (!tieneSitios) {
      razones.push('sin sitios');
    }

    // Zona inválida
    if (data.zona && !zonasValidas.includes(data.zona)) {
      razones.push(`zona inválida: "${data.zona}"`);
    }

    // Sin descripcion ni hook
    if (!data.descripcion && !data.hook) {
      razones.push('sin descripción ni hook');
    }

    if (razones.length > 0) {
      try {
        await db.collection('rutas').doc(doc.id).update({ pausada: true });
        console.log(`⏸️  Pausada: ${nombre}`);
        razones.forEach(r => console.log(`   → ${r}`));
        pausadas++;
        reporte.push({ nombre, razones });
      } catch (e) {
        console.log(`❌ Error en "${nombre}": ${e.message}`);
        errores++;
      }
    } else {
      console.log(`✅ OK: ${nombre}`);
      omitidas++;
    }
  }

  console.log('\n════════════════════════════════════════');
  console.log(`⏸️  Pausadas:    ${pausadas}`);
  console.log(`✅ Sin cambios: ${omitidas}`);
  console.log(`❌ Errores:     ${errores}`);
  console.log('════════════════════════════════════════');

  if (reporte.length > 0) {
    console.log('\n📋 RUTAS PAUSADAS:');
    reporte.forEach(r => {
      console.log(`\n  → ${r.nombre}`);
      r.razones.forEach(rz => console.log(`     • ${rz}`));
    });
  }

  console.log('\n🎉 Completado — recargá la app para ver los cambios');
  process.exit(0);
}

pausarRutasIncompletas().catch(err => {
  console.error('❌ Error fatal:', err.message);
  process.exit(1);
});
