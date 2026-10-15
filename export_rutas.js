const { initializeApp, cert } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const fs = require("fs");

const serviceAccount = require("./serviceAccountKey.json");

initializeApp({ credential: cert(serviceAccount) });

const db = getFirestore();

async function exportar() {
  console.log("⏳ Conectando a Firestore...");
  const snapshot = await db.collection("rutas").get();
  console.log(`✅ ${snapshot.size} rutas encontradas`);

  const rows = [];
  const csvLines = ["ruta,orden,sitio,lat,lng,gmaps"];

  snapshot.forEach((doc) => {
    const data = doc.data();
    const nombreRuta = data.nombre || doc.id;

    const sitios =
      data.sitiosDetalle || data.gpsSitios || data.sitios || data.puntos || [];

    if (sitios.length > 0) {
      sitios.forEach((sitio, i) => {
        const lat = sitio.lat ?? sitio.latitude ?? sitio.latLng?.lat ?? "";
        const lng = sitio.lng ?? sitio.longitude ?? sitio.longitud ?? sitio.latLng?.lng ?? "";
        const nombre = sitio.nombre || sitio.name || sitio.titulo || `Sitio ${i + 1}`;
        const gmaps = lat && lng ? `https://maps.google.com/?q=${lat},${lng}` : "";

        rows.push({ ruta: nombreRuta, orden: i + 1, sitio: nombre, lat, lng, gmaps });
        csvLines.push(`"${nombreRuta}",${i + 1},"${nombre}",${lat},${lng},"${gmaps}"`);
      });
    } else {
      rows.push({ ruta: nombreRuta, orden: 0, sitio: "(sin sitios detalle)", lat: "", lng: "", gmaps: "" });
      csvLines.push(`"${nombreRuta}",0,"(sin sitios detalle)","","",""`);
    }
  });

  fs.writeFileSync("rutas_gps.csv", csvLines.join("\n"), "utf8");

  const rutasUnicas = [...new Set(rows.map((r) => r.ruta))].sort();
  console.log(`\n📄 Archivo generado: rutas_gps.csv`);
  console.log(`📍 Total sitios: ${rows.length}\n`);
  rutasUnicas.forEach((r) => {
    const count = rows.filter((x) => x.ruta === r).length;
    console.log(`  ${r}: ${count} sitios`);
  });

  process.exit(0);
}

exportar().catch((e) => {
  console.error("❌ Error:", e.message);
  process.exit(1);
});
