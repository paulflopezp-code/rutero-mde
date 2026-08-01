// v5
const { onRequest } = require("firebase-functions/v2/https");
const https = require("https");

const API_KEY = "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";

exports.plannerIAv2 = onRequest(
  { region: "us-central1" },
  async (req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type");

    if (req.method === "OPTIONS") { res.status(204).send(""); return; }
    if (req.method !== "POST") { res.status(405).json({ error: "Method not allowed" }); return; }

    const { prompt, systemPrompt } = req.body;
    if (!prompt) { res.status(400).json({ error: "Missing prompt" }); return; }

    const payload = JSON.stringify({
      model: "claude-sonnet-4-6",
      max_tokens: 4096,
      system: systemPrompt || "Eres un asistente de turismo para Medellín, Colombia.",
      messages: [{ role: "user", content: prompt }],
    });

    const options = {
      hostname: "api.anthropic.com",
      path: "/v1/messages",
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": API_KEY,
        "anthropic-version": "2023-06-01",
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
              reject(new Error(`Anthropic error ${response.statusCode}: ${data}`));
            }
          });
        });
        request.on("error", reject);
        request.write(payload);
        request.end();
      });

      const data = JSON.parse(result);
      const responseText = data.content
        .filter((b) => b.type === "text")
        .map((b) => b.text)
        .join("");

      res.status(200).json({ result: responseText });
    } catch (error) {
      console.error("plannerIAv2 error:", error);
      res.status(500).json({ error: error.message, name: error.name });
    }
  }
);
