// revisar_antes_salir.js
// Detecta rutas con antesDeSalir mezclado ES+EN en Firestore

const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: "rutero-mde",
});

const db = admin.firestore();

async function revisarAntesDeSalir() {
  console.log("🔍 Revisando campo antesDeSalir en todas las rutas...\n");

  const snapshot = await db.collection("rutas").get();
  
  const mezcladas = [];
  const sinEN = [];
  const ok = [];

  snapshot.forEach((doc) => {
    const data = doc.data();
    const nombre = data.nombre || data.nombreVisible || doc.id;
    const texto = data.antesDeSalir || "";
    const textoEN = data.antesDeSalirEN || "";

    if (!texto) return; // sin campo, saltar

    // Detectar si tiene palabras en inglés mezcladas (Before, Check, Load, Make sure, etc.)
    const tieneMezclado =
      /\b(Before|Check|Load|Make sure|Remember|Don't|Visit|Book|Wear|Bring|Note|If you|You can|Take|Get|Buy)\b/i.test(texto) &&
      /\b(Antes|Verificá|Cargá|Asegurate|Recordá|No olvides|Visitá|Reservá|Usá|Traé|Llevá|Si hay|Podés|Tomá|Conseguí|Comprá)\b/i.test(texto);

    if (tieneMezclado) {
      mezcladas.push({ nombre, antesDeSalir: texto, antesDeSalirEN: textoEN });
    } else if (!textoEN) {
      sinEN.push({ nombre, antesDeSalir: texto });
    } else {
      ok.push(nombre);
    }
  });

  console.log(`✅ OK (ES y EN separados): ${ok.length} rutas`);
  ok.forEach((n) => console.log(`   - ${n}`));

  console.log(`\n⚠️  SIN antesDeSalirEN: ${sinEN.length} rutas`);
  sinEN.forEach((r) => {
    console.log(`   - ${r.nombre}`);
    console.log(`     ES: ${r.antesDeSalir.substring(0, 80)}...`);
  });

  console.log(`\n❌ MEZCLADO ES+EN en mismo campo: ${mezcladas.length} rutas`);
  mezcladas.forEach((r) => {
    console.log(`\n   📍 ${r.nombre}`);
    console.log(`   antesDeSalir: ${r.antesDeSalir.substring(0, 120)}...`);
    console.log(`   antesDeSalirEN: ${r.antesDeSalirEN ? r.antesDeSalirEN.substring(0, 80) : "❌ VACÍO"}`);
  });

  console.log(`\n📊 RESUMEN: ${mezcladas.length} mezcladas, ${sinEN.length} sin EN, ${ok.length} OK`);
  process.exit(0);
}

revisarAntesDeSalir().catch((err) => {
  console.error("Error:", err);
  process.exit(1);
});
