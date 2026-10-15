"""
Rutero MDE — Exportar GPS de todas las rutas desde Firestore
Ejecutar en su PC:
  pip install firebase-admin openpyxl
  python export_rutas_local.py
"""

import firebase_admin
from firebase_admin import credentials, firestore
import csv

# ── Credenciales ──────────────────────────────────────────────────────────────
KEY_PATH = "rutero-mde-firebase-adminsdk-fbsvc-f37e456a84.json"  # mismo directorio
# ─────────────────────────────────────────────────────────────────────────────

cred = credentials.Certificate(KEY_PATH)
firebase_admin.initialize_app(cred)
db = firestore.client()

rows = []
rutas_ref = db.collection("rutas").stream()

for doc in rutas_ref:
    data = doc.to_dict()
    nombre_ruta = data.get("nombre", doc.id)

    sitios = (
        data.get("sitiosDetalle") or
        data.get("gpsSitios") or
        data.get("sitios") or
        data.get("puntos") or
        []
    )

    if sitios:
        for i, sitio in enumerate(sitios):
            if isinstance(sitio, dict):
                lat = (sitio.get("lat") or sitio.get("latitude") or
                       (sitio.get("latLng", {}).get("lat") if isinstance(sitio.get("latLng"), dict) else None))
                lng = (sitio.get("lng") or sitio.get("longitude") or sitio.get("longitud") or
                       (sitio.get("latLng", {}).get("lng") if isinstance(sitio.get("latLng"), dict) else None))
                nombre_sitio = (sitio.get("nombre") or sitio.get("name") or
                                sitio.get("titulo") or f"Sitio {i+1}")
                rows.append({
                    "ruta": nombre_ruta,
                    "orden": i + 1,
                    "sitio": nombre_sitio,
                    "lat": lat,
                    "lng": lng,
                    "gmaps": f"https://maps.google.com/?q={lat},{lng}" if lat and lng else ""
                })
    else:
        rows.append({
            "ruta": nombre_ruta,
            "orden": 0,
            "sitio": "(sin sitios detalle)",
            "lat": data.get("lat"),
            "lng": data.get("lng"),
            "gmaps": ""
        })

# ── CSV ───────────────────────────────────────────────────────────────────────
csv_path = "rutas_gps.csv"
with open(csv_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["ruta", "orden", "sitio", "lat", "lng", "gmaps"])
    writer.writeheader()
    writer.writerows(rows)

# ── Resumen ───────────────────────────────────────────────────────────────────
rutas_unicas = sorted(set(r["ruta"] for r in rows))
print(f"\n✅ {len(rutas_unicas)} rutas exportadas — {len(rows)} sitios totales")
print(f"📄 Archivo: {csv_path}\n")
for r in rutas_unicas:
    count = sum(1 for x in rows if x["ruta"] == r)
    print(f"  {r}: {count} sitios")
