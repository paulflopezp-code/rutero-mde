// auditoria_rutas.js
// Detecta rutas con campos vacíos y muestra qué necesita completarse
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function auditar() {
  console.log("🔍 Auditando rutas en Firestore...\n");

  const snapshot = await db.collection("rutas").get();
  
  const vacias = [];
  const ok = [];

  snapshot.forEach((doc) => {
    const d = doc.data();
    const nombre = d.nombre || d.nombreVisible || doc.id;
    
    const camposVacios = [];
    if (!d.descripcion || d.descripcion.trim() === '') camposVacios.push('descripcion');
    if (!d.descripcionEN || d.descripcionEN.trim() === '') camposVacios.push('descripcionEN');
    if (!d.hook || d.hook.trim() === '') camposVacios.push('hook');
    if (!d.hookEN || d.hookEN.trim() === '') camposVacios.push('hookEN');
    if (!d.insigniaImg || d.insigniaImg.trim() === '') camposVacios.push('insigniaImg');
    if (!d.subtitulo || d.subtitulo.trim() === '') camposVacios.push('subtitulo');
    if (!d.subtituloEN || d.subtituloEN.trim() === '') camposVacios.push('subtituloEN');

    if (camposVacios.length > 0) {
      vacias.push({ 
        id: doc.id, 
        nombre, 
        camposVacios,
        zona: d.zona || '',
        activa: d.activa,
        pausada: d.pausada,
        emoji: d.emoji || '',
        insignia: d.insignia || '',
        insigniaImg: d.insigniaImg || '',
        descripcion: d.descripcion || '',
        hook: d.hook || '',
        subtitulo: d.subtitulo || '',
      });
    } else {
      ok.push(nombre);
    }
  });

  console.log(`✅ Rutas completas: ${ok.length}`);
  ok.forEach(n => console.log(`   ✓ ${n}`));

  console.log(`\n❌ Rutas con campos vacíos: ${vacias.length}`);
  vacias.forEach(r => {
    const estado = r.pausada ? '⏸️' : r.activa ? '🟢' : '⚫';
    console.log(`\n${estado} ${r.nombre} [${r.zona}]`);
    console.log(`   ID: ${r.id}`);
    console.log(`   Faltan: ${r.camposVacios.join(', ')}`);
    if (r.emoji) console.log(`   Emoji: ${r.emoji}`);
    if (r.insignia) console.log(`   Insignia: ${r.insignia}`);
    if (r.insigniaImg) console.log(`   InsigniaImg: ${r.insigniaImg}`);
    if (r.descripcion) console.log(`   Descripcion: ${r.descripcion.substring(0,60)}...`);
    if (r.hook) console.log(`   Hook: ${r.hook.substring(0,60)}...`);
  });

  console.log(`\n📊 RESUMEN: ${vacias.length} rutas necesitan completarse de ${snapshot.size} total`);
  process.exit(0);
}

auditar().catch(err => {
  console.error("Error:", err);
  process.exit(1);
});
