// pausar_temporada.js
// Pausa rutas de temporada que no están en su época del año
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

// Rutas a pausar — fuera de temporada en septiembre 2026
// MEDEJAZZ se deja activa (octubre es próximo mes)
// FIESTA DEL LIBRO se deja activa (septiembre — este mes)
const PAUSAR = [
  'ALUMBRADO NAVIDEÑO — RÍO MEDELLÍN',
  'FERIA DE LAS FLORES',
  'FERIA CLÁSICA',
  'DESFILE DE SILLETEROS',
  'CABALGATA',
  'DESFILE DE AUTOS CLÁSICOS Y DE COLECCIÓN',
  'DESFILE DE CHIVAS Y FLORES',
  'CONCIERTO INAUGURAL FERIA',
  'FERIA A RITMO DE BICICLETA',
  'DESFILE DE MITOS Y LEYENDAS',
  'GUARDIANES DE LA SILLETA',
  'FERIA DE LA ANTIOQUEÑIDAD',
  'SEMANA SANTA PATRIMONIAL',
  'FESTIVAL INTERNACIONAL DE TANGO',
  'FESTIVAL DE POESÍA INTERNACIONAL',
  'COLOMBIAMODA',
];

async function pausar() {
  console.log("⏸️  Pausando rutas de temporada fuera de fecha...\n");
  const snapshot = await db.collection("rutas").get();
  let pausadas = 0;
  let noEncontradas = 0;

  for (const doc of snapshot.docs) {
    const d = doc.data();
    const nombre = d.nombre || d.nombreVisible || doc.id;
    if (!PAUSAR.includes(nombre)) continue;

    try {
      await doc.ref.update({ pausada: true, activa: false });
      pausadas++;
      console.log(`⏸️  ${nombre}`);
    } catch (e) {
      console.error(`❌ Error en ${nombre}: ${e.message}`);
    }
  }

  // Verificar cuáles no se encontraron
  const encontradas = new Set();
  snapshot.forEach(doc => {
    const nombre = doc.data().nombre || doc.data().nombreVisible || doc.id;
    if (PAUSAR.includes(nombre)) encontradas.add(nombre);
  });
  PAUSAR.forEach(nombre => {
    if (!encontradas.has(nombre)) {
      noEncontradas++;
      console.log(`⚠️  No encontrada: "${nombre}"`);
    }
  });

  console.log(`\n📊 RESUMEN: ⏸️  ${pausadas} pausadas · ⚠️  ${noEncontradas} no encontradas`);
  console.log(`\n✅ Activas este mes (no pausadas):`);
  console.log(`   • FIESTA DEL LIBRO Y LA CULTURA (septiembre)`);
  console.log(`   • MEDEJAZZ — FESTIVAL DE JAZZ (octubre — próximo mes)`);
  process.exit(0);
}

pausar().catch(err => { console.error(err); process.exit(1); });
