// v7 — agrega FCM push notifications
const { onRequest } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const https = require("https");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();
const API_KEY = process.env.ANTHROPIC_API_KEY;

// ─── HELPER: enviar push a un usuario ───────────────────────────────────────
async function enviarPush(uid, titulo, cuerpo, data = {}) {
  try {
    const userDoc = await db.collection("usuarios").doc(uid).get();
    const token = userDoc.data()?.fcmToken;
    if (!token) return; // usuario no tiene token registrado aún

    await admin.messaging().send({
      token,
      notification: { title: titulo, body: cuerpo },
      data: { ...data },
      android: { priority: "normal" },
      apns: { payload: { aps: { sound: "default" } } },
    });
  } catch (e) {
    console.error(`Push a ${uid} falló:`, e.message);
  }
}

// ─── 1. RUTA COMPLETADA → push de logro + compartir ─────────────────────────
// Trigger: cuando se crea un doc en usuarios/{uid}/rutasCompletadas/{rutaId}
exports.onRutaCompletada = onDocumentCreated(
  "usuarios/{uid}/rutasCompletadas/{rutaId}",
  async (event) => {
    const uid = event.params.uid;
    const rutaId = event.params.rutaId; // es el nombre de la ruta
    const data = event.data?.data() || {};

    const insignia = data.insigniaNombre || "Explorador";
    const rutaNombre = rutaId.replace(/_/g, " ");

    await enviarPush(
      uid,
      `🏆 ¡Insignia ganada: ${insignia}!`,
      `Completaste "${rutaNombre}" — comparte tu logro con tus amigos.`,
      { tipo: "logro", rutaId }
    );
  }
);

// ─── 2. CIUDAD NUEVA → push a todos los usuarios ────────────────────────────
// Trigger: cuando se agrega una ciudad a config/ciudades (campo ciudades array)
// Se dispara cuando se crea un nuevo documento en la colección 'rutas'
// con ciudad diferente a Medellín
exports.onCiudadNueva = onDocumentCreated(
  "config/nuevaCiudad",
  async (event) => {
    const data = event.data?.data() || {};
    const ciudad = data.ciudad || "Nueva ciudad";
    const mensaje = data.mensaje || `¡${ciudad} ya está en Rutero! Explórala ahora.`;

    // Obtener todos los usuarios con fcmToken
    const snap = await db.collection("usuarios").get();
    const pushes = [];
    snap.forEach((doc) => {
      const token = doc.data().fcmToken;
      if (token) {
        pushes.push(
          admin.messaging().send({
            token,
            notification: {
              title: `🗺️ ¡${ciudad} ya disponible!`,
              body: mensaje,
            },
            data: { tipo: "ciudad_nueva", ciudad },
          })
        );
      }
    });

    await Promise.allSettled(pushes);
    console.log(`✅ Push ciudad nueva enviado a ${pushes.length} usuarios`);
  }
);

// ─── 3. USUARIO INACTIVO 7 días → push de reactivación ─────────────────────
// Corre cada día a las 10am hora Colombia (UTC-5 = 15:00 UTC)
exports.recordatorioInactivos = onSchedule(
  { schedule: "0 15 * * *", timeZone: "America/Bogota" },
  async () => {
    const hace7Dias = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const hace14Dias = new Date(Date.now() - 14 * 24 * 60 * 60 * 1000);

    // Usuarios inactivos entre 7 y 14 días (no spamear a los muy inactivos)
    const snap = await db
      .collection("usuarios")
      .where("lastActive", "<=", hace7Dias)
      .where("lastActive", ">=", hace14Dias)
      .get();

    const pushes = [];
    snap.forEach((doc) => {
      const token = doc.data().fcmToken;
      const nombre = doc.data().nombre?.split(" ")[0] || "";
      if (token) {
        pushes.push(
          admin.messaging().send({
            token,
            notification: {
              title: nombre ? `${nombre}, Medellín te espera 🗺️` : "Medellín te espera 🗺️",
              body: "Tienes rutas por descubrir — ¿cuándo sigues explorando?",
            },
            data: { tipo: "reactivacion" },
          })
        );
      }
    });

    await Promise.allSettled(pushes);
    console.log(`✅ Recordatorio inactivos: ${pushes.length} enviados`);
  }
);

// ─── 4. EVENTO PRÓXIMO → push 48h antes ─────────────────────────────────────
// Corre cada día a las 9am Colombia
exports.recordatorioEventos = onSchedule(
  { schedule: "0 14 * * *", timeZone: "America/Bogota" },
  async () => {
    const ahora = new Date();
    const en48h = new Date(ahora.getTime() + 48 * 60 * 60 * 1000);
    const en24h = new Date(ahora.getTime() + 24 * 60 * 60 * 1000);

    // Eventos que ocurren en las próximas 24–48 horas
    const eventosSnap = await db
      .collection("eventos")
      .where("fecha", ">=", en24h)
      .where("fecha", "<=", en48h)
      .where("activo", "==", true)
      .get();

    if (eventosSnap.empty) return;

    // Obtener todos los usuarios con token (notificación general — no segmentada aún)
    const usuariosSnap = await db.collection("usuarios").get();
    const tokens = [];
    usuariosSnap.forEach((doc) => {
      if (doc.data().fcmToken) tokens.push(doc.data().fcmToken);
    });

    const pushes = [];
    eventosSnap.forEach((evDoc) => {
      const ev = evDoc.data();
      const nombre = ev.nombre || "Evento";
      tokens.forEach((token) => {
        pushes.push(
          admin.messaging().send({
            token,
            notification: {
              title: `⏰ "${nombre}" — ¡en 2 días!`,
              body: ev.descripcion
                ? ev.descripcion.substring(0, 80) + "…"
                : "No te lo pierdas — abre Rutero para más info.",
            },
            data: { tipo: "evento", eventoId: evDoc.id },
          })
        );
      });
    });

    await Promise.allSettled(pushes);
    console.log(`✅ Recordatorio eventos: ${pushes.length} enviados`);
  }
);

// ─── PLANNER IA (Gemini) ─────────────────────────────────────────────────────
exports.plannerIAv2 = onRequest(
  { region: "us-central1", secrets: ["GEMINI_API_KEY"] },
  async (req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type");

    if (req.method === "OPTIONS") { res.status(204).send(""); return; }
    if (req.method !== "POST") { res.status(405).json({ error: "Method not allowed" }); return; }

    const { prompt, systemPrompt } = req.body;
    if (!prompt) { res.status(400).json({ error: "Missing prompt" }); return; }

    const GEMINI_KEY = process.env.GEMINI_API_KEY;
    const GEMINI_MODEL = "gemini-3.6-flash";
    const systemText = systemPrompt || "Eres un asistente de turismo para Medellín, Colombia.";

    const payload = JSON.stringify({
      system_instruction: { parts: [{ text: systemText }] },
      contents: [{ role: "user", parts: [{ text: prompt }] }],
      generationConfig: { maxOutputTokens: 8192, temperature: 0.7 },
    });

    const path = `/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_KEY}`;

    const options = {
      hostname: "generativelanguage.googleapis.com",
      path,
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(payload),
      },
    };

    try {
      const result = await new Promise((resolve, reject) => {
        const request = https.request(options, (response) => {
          let data = "";
          response.on("data", (chunk) => { data += chunk; });
          response.on("end", () => {
            if (response.statusCode >= 200 && response.statusCode < 300) {
              resolve(data);
            } else {
              reject(new Error(`Gemini error ${response.statusCode}: ${data}`));
            }
          });
        });
        request.on("error", reject);
        request.write(payload);
        request.end();
      });

      const data = JSON.parse(result);
      const responseText = data.candidates?.[0]?.content?.parts
        ?.filter((p) => p.text)
        ?.map((p) => p.text)
        ?.join("") || "";

      res.status(200).json({ result: responseText });
    } catch (error) {
      console.error("plannerIAv2 error:", error);
      res.status(500).json({ error: error.message, name: error.name });
    }
  }
);
