/**
 * limpiar_rutas_firestore.js
 * Rutero MDE — Limpieza y corrección de rutas en Firestore
 * Fecha: 28 jul 2026
 */

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const serviceAccount = require('./serviceAccountKey.json');

const DRY_RUN = process.argv.includes('--dry-run');

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

const RUTAS_ELIMINAR = [
  'RUTA SILLETERA',
  'RUTA PATRIMONIAL DEL CENTRO',
  'ALUMBRADO NAVIDEÑO',
  'FESTIVAL DE POESÍA',
];

const RUTAS_MODIFICAR = [
  {
    nombre: 'Estaciones EnCicla',
    cambios: { zona: 'Ciudad' },
    razon: 'zona undefined → Ciudad',
  },
  {
    nombre: 'FINCAS SILLETERAS',
    cambios: { zona: 'Alrededores', pausada: true, activa: false },
    razon: 'reemplazada por 4 rutas temáticas',
  },
  {
    nombre: 'RUTA DE LOS MIRADORES',
    cambios: { zona: 'Alrededores' },
    razon: 'zona Ciudad → Alrededores',
  },
  {
    nombre: 'RUTA DEL METROCABLE & ARVÍ',
    cambios: { zona: 'Alrededores' },
    razon: 'zona Ciudad → Alrededores',
  },
];

async function getDocByNombre(nombre) {
  const snap = await db.collection('rutas')
    .where('nombre', '==', nombre)
    .limit(1)
    .get();
  if (snap.empty) return null;
  return snap.docs[0];
}

const log = (emoji, msg) => console.log(`${emoji}  ${msg}`);

async function main() {
  console.log('\n═══════════════════════════════════════════════');
  console.log('  RUTERO MDE — Limpieza de rutas Firestore');
  console.log(`  Modo: ${DRY_RUN ? '🧪 DRY-RUN (sin cambios)' : '🚀 PRODUCCIÓN'}`);
  console.log('═══════════════════════════════════════════════\n');

  let eliminadas = 0, modificadas = 0, noEncontradas = 0, errores = 0;

  console.log('━━━ PASO 1: ELIMINANDO rutas obsoletas ━━━\n');
  for (const nombre of RUTAS_ELIMINAR) {
    try {
      const doc = await getDocByNombre(nombre);
      if (!doc) {
        log('⚠️ ', `No encontrada: "${nombre}"`);
        noEncontradas++;
        continue;
      }
      const sitios = doc.data().sitiosDetalle ? doc.data().sitiosDetalle.length : '?';
      log('🗑️ ', `"${nombre}" (ID: ${doc.id}, ${sitios} sitios)`);
      if (!DRY_RUN) {
        await doc.ref.delete();
        log('✅', `Eliminada\n`);
      } else {
        console.log(`   [DRY-RUN] eliminaría ID: ${doc.id}\n`);
      }
      eliminadas++;
    } catch (e) {
      log('❌', `Error en "${nombre}": ${e.message}`);
      errores++;
    }
  }

  console.log('━━━ PASO 2: MODIFICANDO zonas y estados ━━━\n');
  for (const { nombre, cambios, razon } of RUTAS_MODIFICAR) {
    try {
      const doc = await getDocByNombre(nombre);
      if (!doc) {
        log('⚠️ ', `No encontrada: "${nombre}"`);
        noEncontradas++;
        continue;
      }
      const data = doc.data();
      log('✏️ ', `"${nombre}" — ${razon}`);
      for (const [campo, val] of Object.entries(cambios)) {
        console.log(`   ${campo}: "${data[campo]}" → "${val}"`);
      }
      if (!DRY_RUN) {
        await doc.ref.update({
          ...cambios,
          modificadoPor: 'limpiar_rutas_firestore.js 28jul2026',
        });
        log('✅', `Modificada\n`);
      } else {
        console.log(`   [DRY-RUN] actualizaría: ${JSON.stringify(cambios)}\n`);
      }
      modificadas++;
    } catch (e) {
      log('❌', `Error en "${nombre}": ${e.message}`);
      errores++;
    }
  }

  console.log('\n═══════════════════════════════════════════════');
  console.log('  RESUMEN');
  console.log(`  🗑️  Eliminadas:     ${eliminadas}`);
  console.log(`  ✏️  Modificadas:    ${modificadas}`);
  console.log(`  ⚠️  No encontradas: ${noEncontradas}`);
  console.log(`  ❌  Errores:        ${errores}`);
  if (DRY_RUN) console.log('\n  ⚠️  DRY-RUN: ningún cambio aplicado.');
  else console.log('\n  ✅  Cambios aplicados.');
  console.log('═══════════════════════════════════════════════\n');
  process.exit(errores > 0 ? 1 : 0);
}

main().catch(e => { console.error('Error fatal:', e); process.exit(1); });
