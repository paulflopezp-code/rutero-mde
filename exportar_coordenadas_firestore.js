/**
 * exportar_coordenadas_firestore.js
 * Rutero MDE — Exporta coordenadas de todos los sitios en Firestore
 *
 * SETUP (solo una vez):
 *   mkdir G:\rutero_export
 *   copy este archivo a G:\rutero_export\
 *   copy serviceAccountKey.json a G:\rutero_export\
 *   cd G:\rutero_export
 *   npm init -y
 *   npm install firebase-admin
 *   node exportar_coordenadas_firestore.js
 */

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore }        = require('firebase-admin/firestore');
const fs   = require('fs');
const path = require('path');

// ── Verificar serviceAccountKey.json ───────────────────────────────────────
const keyPath = path.join(__dirname, 'serviceAccountKey.json');
if (!fs.existsSync(keyPath)) {
  console.error('❌ No se encontró serviceAccountKey.json en esta carpeta');
  console.error('   Copialo desde Firebase Console → Configuración → Cuentas de servicio');
  process.exit(1);
}

const serviceAccount = require(keyPath);

initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

// ── Extraer lat/lng (soporta varios formatos) ──────────────────────────────
function extraerCoords(sitio) {
  if (sitio.lat  !== undefined && sitio.lng  !== undefined)
    return { lat: sitio.lat, lng: sitio.lng };
  if (sitio.latLng?.lat !== undefined)
    return { lat: sitio.latLng.lat, lng: sitio.latLng.lng };
  if (sitio.coords?.lat !== undefined)
    return { lat: sitio.coords.lat, lng: sitio.coords.lng };
  return null;
}

// ── Validar coords ─────────────────────────────────────────────────────────
function validarCoords(lat, lng) {
  if (lat < 5.8 || lat > 6.7 || lng < -76.5 || lng > -75.0)
    return '❌ FUERA DE RANGO';
  const genericas = [
    [6.2197, -75.5897],
    [6.2686, -75.5657],
    [6.2445, -75.5762],
    [6.2393, -75.5727],
    [6.2572, -75.5918],
  ];
  for (const [slat, slng] of genericas)
    if (Math.abs(lat - slat) < 0.0003 && Math.abs(lng - slng) < 0.0003)
      return '⚠️ COORD GENÉRICA';
  return '✅';
}

// ── Main ───────────────────────────────────────────────────────────────────
async function exportar() {
  const filas = [['RUTA', 'DOC_ID', 'SITIO', 'LAT', 'LNG', 'ESTADO']];

  console.log('🔍 Conectando a Firestore...');
  const rutasSnap = await db.collection('rutas').get();
  console.log(`✅ ${rutasSnap.size} rutas encontradas\n`);

  let totalSitios = 0, sinCoords = 0, conProblemas = 0;

  for (const rutaDoc of rutasSnap.docs) {
    const data       = rutaDoc.data();
    const nombreRuta = data.nombre || rutaDoc.id;
    const pausada    = data.pausada === true ? ' [PAUSADA]' : '';
    const sitios     = data.sitiosDetalle || data.sitios || [];

    if (!Array.isArray(sitios) || sitios.length === 0) {
      filas.push([nombreRuta + pausada, rutaDoc.id, '(sin sitiosDetalle)', '', '', '⚠️ SIN SITIOS']);
      continue;
    }

    for (const sitio of sitios) {
      totalSitios++;
      const nombreSitio = sitio.nombre || sitio.titulo || '(sin nombre)';
      const coords      = extraerCoords(sitio);

      if (!coords) {
        sinCoords++;
        filas.push([nombreRuta + pausada, rutaDoc.id, nombreSitio, '', '', '❌ SIN COORDS']);
        continue;
      }

      const estado = validarCoords(coords.lat, coords.lng);
      if (estado !== '✅') conProblemas++;

      filas.push([nombreRuta + pausada, rutaDoc.id, nombreSitio,
        coords.lat.toFixed(6), coords.lng.toFixed(6), estado]);
    }
  }

  const csv = filas
    .map(f => f.map(v => `"${String(v).replace(/"/g, '""')}"`).join(','))
    .join('\n');

  const outPath = path.join(__dirname, 'coordenadas_firestore.csv');
  fs.writeFileSync(outPath, '\uFEFF' + csv, 'utf8');

  console.log('═══════════════════════════════════════════════');
  console.log('  COORDENADAS FIRESTORE — RUTERO MDE');
  console.log('═══════════════════════════════════════════════');
  console.log(`  Rutas procesadas : ${rutasSnap.size}`);
  console.log(`  Sitios totales   : ${totalSitios}`);
  console.log(`  Sin coordenadas  : ${sinCoords}  ← agregar lat/lng`);
  console.log(`  Coord genérica   : ${conProblemas}  ← verificar posición`);
  console.log(`  OK               : ${totalSitios - sinCoords - conProblemas}`);
  console.log('───────────────────────────────────────────────');
  console.log(`  ✅ coordenadas_firestore.csv generado`);
  console.log(`  📂 Abrí en Excel · filtrá columna ESTADO`);
  console.log('═══════════════════════════════════════════════\n');

  process.exit(0);
}

exportar().catch(err => {
  console.error('❌ Error:', err.message);
  process.exit(1);
});
