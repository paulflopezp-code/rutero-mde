// ════════════════════════════════════════════════════════════════════════════
//  RUTERO MDE — Design System v3.0
//  Fase 1: Foundation (v1.0) + Fase B: Premium 3.0
//
//  NUEVO EN v3.0 (Sección 8)
//  ─────────────────────────
//  8.1  RDSColor3       — tokens color adicionales (borders, scrims, badges)
//  8.2  RDSType3        — tipografía hero, points, distance, tag
//  8.3  RDSGradient     — gradientes cinematográficos
//  8.4  HeroOverlay     — overlay foto reutilizable
//  8.5  SitioCard       — card de sitio con 4 estados
//  8.6  CategoryChip    — chip de filtro para Explorar y Mapa
//  8.7  StatusBadge     — badge insignia con 4 niveles
//  8.8  SponsorBadge    — logo patrocinador B2B
//  8.9  GpsRangeIndicator — indicador distancia GPS
//
//  Este archivo es la fuente de verdad de todos los tokens visuales.
//  Importarlo en main.dart y en cualquier pantalla nueva:
//
//    import 'design_system_rutero.dart';
//
//  CONVENCIÓN DE NOMBRES
//  ─────────────────────
//  RDS = Rutero Design System (prefijo de todas las clases)
//  Los tokens se agrupan en clases estáticas (RDSColor, RDSType, etc.)
//  para evitar colisiones con el espacio de nombres de main.dart
//  durante la migración iterativa.
//
//  MIGRACIÓN ITERATIVA
//  ───────────────────
//  Mientras main.dart siga usando los viejos kXxx, este archivo los
//  reexpone como aliases en RDSLegacy para que ambos coexistan.
//  A medida que cada componente migra, usa directamente RDSColor.xxx.
//  Cuando main.dart ya no use ningún kXxx, elimina RDSLegacy.
//
//  © 2025-2026 Paul Fernando López Prieto
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 1 — COLOR TOKENS
//  Paleta fija. No modificar valores inline en los widgets.
//  Si necesitas un matiz, definirlo aquí con nombre semántico.
// ─────────────────────────────────────────────────────────────────────────────
abstract final class RDSColor {

  // ── Fondos ────────────────────────────────────────────────────────────────
  // Usa SIEMPRE kBase como fondo de Scaffold. Elimina toda ocurrencia de
  // Color(0xFF0A080F) (onboarding) y Color(0xFF0D0D0D) (kDark) que
  // difieren del sistema.
  static const Color base     = Color(0xFF111410); // kDark2 — verde oscuro paisa ✅ ÚNICO fondo de Scaffold
  static const Color surface  = Color(0xFF1A1E14); // kDark3 — contenedor sobre base
  static const Color card     = Color(0xFF1C2018); // kCard  — tarjetas y sheets
  static const Color overlay  = Color(0xFF0D0D0D); // kDark  — overlays modales oscuros

  // ── Texto ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F0E8); // kText
  static const Color textMuted   = Color(0xFF8A9278); // kTextMuted
  // textDisabled: usa textMuted.withOpacity(0.5) — no definir color fijo
  // para estados disabled porque varía según el fondo.

  // ── Acentos principales ───────────────────────────────────────────────────
  // Verde: logros, rutas activas, CTAs primarios ("Explorar")
  static const Color green      = Color(0xFF5BAD6F); // Verde montaña
  static const Color greenLight = Color(0xFF7ACC85); // Para gradientes de botón

  // Oro: gamificación, puntos, badges, nivel
  static const Color gold       = Color(0xFFC9A84C); // Dorado clásico
  static const Color goldLight  = Color(0xFFE8C96A); // Hover/highlight dorado

  // Naranja barro: llamadas a acción secundarias, alertas suaves
  static const Color accent     = Color(0xFFE85D26); // Naranja barro
  static const Color orchid     = Color(0xFFC1694F); // Terracota — calidez antioqueña

  // ── Feria de las Flores (tokens de temporada) ─────────────────────────────
  // Solo usar en FeriaScreen y componentes específicos de Feria.
  // No contaminar el sistema base con estos colores.
  static const Color feriaRed    = Color(0xFFD05538); // Rojo silletera
  static const Color feriaRose   = Color(0xFFE8598A); // Rosa floral
  static const Color feriaForest = Color(0xFF2D6A2F); // Verde follaje

  // ── Semánticos de estado ──────────────────────────────────────────────────
  // Para feedback de UI (success, error, warning, info).
  // Mapean a los acentos del sistema para no introducir colores nuevos.
  static const Color stateSuccess = green;   // Confirmación, ruta completada
  static const Color stateError   = accent;  // Error, validación fallida
  static const Color stateWarning = gold;    // Advertencia, puntos por vencer
  static const Color stateInfo    = orchid;  // Información contextual

  // ── Bordes y divisores ────────────────────────────────────────────────────
  // Usar withOpacity() sobre estos valores base; no crear constantes para
  // cada opacidad posible (eso infla el sistema sin beneficio).
  static const Color borderSubtle  = Color(0xFF2A2E22); // Borde sutil entre cards
  static const Color borderActive  = gold;               // Borde de elemento seleccionado

  // ── Gradientes predefinidos ───────────────────────────────────────────────
  // Usar LinearGradient con estos stops; no definir colores inline.
  static const List<Color> gradientPrimary = [green, greenLight];     // Botón primario
  static const List<Color> gradientGold    = [gold, goldLight];        // Badge premium
  static const List<Color> gradientCard    = [surface, card];          // Fondo de card sin imagen
  static const List<Color> gradientScrim   = [Colors.transparent, Color(0xEE000000)]; // Scrim inferior en RouteCard
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 2 — TIPOGRAFÍA
//  Escala de 8 pasos. Fuentes: PlayfairDisplay (display), Inter (body),
//  SpaceGrotesk (datos/labels). Mismas que en ThemeData actual.
//
//  REGLA DE USO
//  ────────────
//  Display  → títulos de pantalla, hero onboarding, nombre de ruta en card
//  Headline → subtítulos de sección, títulos de sheet
//  Body     → párrafos, descripciones, texto largo
//  Label    → puntos, métricas, chips de datos, badges
//  Caption  → metadatos, timestamps, texto de soporte
// ─────────────────────────────────────────────────────────────────────────────
abstract final class RDSType {

  // ── Familias ──────────────────────────────────────────────────────────────
  static const String familyDisplay = 'PlayfairDisplay';
  static const String familyBody    = 'Inter';
  static const String familyData    = 'SpaceGrotesk';

  // ── Escala tipográfica ────────────────────────────────────────────────────
  // Basada en la escala existente, pero normalizada a 7 steps:
  // 11 · 12 · 13 · 15 · 18 · 22 · 28
  // Eliminamos los valores intermedios fragmentados (9, 10, 16, 20, 24, 26)
  // que generaban inconsistencia. Durante migración puedes mantenerlos;
  // al migrar cada componente, mapea al step más cercano.

  // Display — PlayfairDisplay
  static const TextStyle displayLg = TextStyle(
    fontFamily: familyDisplay, fontSize: 28, fontWeight: FontWeight.w900,
    color: RDSColor.textPrimary, letterSpacing: -0.5, height: 1.15);

  static const TextStyle displayMd = TextStyle(
    fontFamily: familyDisplay, fontSize: 22, fontWeight: FontWeight.w900,
    color: RDSColor.textPrimary, letterSpacing: -0.3, height: 1.2);

  static const TextStyle displaySm = TextStyle(
    fontFamily: familyDisplay, fontSize: 18, fontWeight: FontWeight.w700,
    color: RDSColor.textPrimary, letterSpacing: 0.2, height: 1.25);

  // Headline — Inter
  static const TextStyle headlineLg = TextStyle(
    fontFamily: familyBody, fontSize: 18, fontWeight: FontWeight.w700,
    color: RDSColor.textPrimary, height: 1.3);

  static const TextStyle headlineMd = TextStyle(
    fontFamily: familyBody, fontSize: 15, fontWeight: FontWeight.w700,
    color: RDSColor.textPrimary, height: 1.35);

  // Body — Inter
  static const TextStyle bodyLg = TextStyle(
    fontFamily: familyBody, fontSize: 15, fontWeight: FontWeight.w400,
    color: RDSColor.textPrimary, height: 1.6);

  static const TextStyle bodyMd = TextStyle(
    fontFamily: familyBody, fontSize: 13, fontWeight: FontWeight.w400,
    color: RDSColor.textMuted, height: 1.5);

  static const TextStyle bodySm = TextStyle(
    fontFamily: familyBody, fontSize: 12, fontWeight: FontWeight.w400,
    color: RDSColor.textMuted, height: 1.45);

  // Label / Data — SpaceGrotesk (métricas, puntos, badges)
  static const TextStyle labelLg = TextStyle(
    fontFamily: familyData, fontSize: 15, fontWeight: FontWeight.w700,
    color: RDSColor.gold, letterSpacing: 0.3);

  static const TextStyle labelMd = TextStyle(
    fontFamily: familyData, fontSize: 13, fontWeight: FontWeight.w600,
    color: RDSColor.gold, letterSpacing: 0.3);

  static const TextStyle labelSm = TextStyle(
    fontFamily: familyData, fontSize: 11, fontWeight: FontWeight.w600,
    color: RDSColor.textMuted, letterSpacing: 0.5);

  // Caption — Inter (metadatos, timestamps)
  static const TextStyle caption = TextStyle(
    fontFamily: familyBody, fontSize: 11, fontWeight: FontWeight.w400,
    color: RDSColor.textMuted, height: 1.4);
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 3 — ESPACIADO (Grid de 8 px)
//  Todas las medidas de padding/margin/gap deben ser múltiplos de 4 u 8.
//  Excepción permitida: 2 px para separadores visuales muy finos.
//
//  LECTURA RÁPIDA
//  xs  = 4   → separación interna de chips y badges
//  sm  = 8   → padding interno de componentes pequeños
//  md  = 16  → padding interno estándar de cards y secciones
//  lg  = 24  → padding de pantalla (horizontal)
//  xl  = 32  → separación entre secciones
//  xxl = 48  → espacios generosos (hero sections)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class RDSSpace {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;

  // Padding horizontal de pantalla (usa esto en lugar de EdgeInsets.all(24)
  // inconsistente; algunas pantallas usan 16, otras 20, otras 24)
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets screenPad = EdgeInsets.fromLTRB(lg, md, lg, md);

  // Gaps predefinidos para Column/Row
  static const SizedBox gapXs  = SizedBox(width: xs,  height: xs);
  static const SizedBox gapSm  = SizedBox(width: sm,  height: sm);
  static const SizedBox gapMd  = SizedBox(width: md,  height: md);
  static const SizedBox gapLg  = SizedBox(width: lg,  height: lg);
  static const SizedBox gapXl  = SizedBox(width: xl,  height: xl);

  // Uso: Column(children: [Widget1, RDSSpace.gapSm, Widget2])
  // En Row: Row(children: [Widget1, RDSSpace.gapSm, Widget2])
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 4 — RADIOS DE BORDE
//  Diagnóstico del código actual: se encontraron 15 valores distintos
//  (2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 70, 90, 140, 150).
//  Se consolidan en 6 tokens semánticos.
//
//  MAPA DE MIGRACIÓN
//  ─────────────────
//  circular(4)   → RDSRadius.xs    (micro-badge interno)
//  circular(8)   → RDSRadius.sm    (badge, tag pequeño)
//  circular(12)  → RDSRadius.md    (chip, input, botón pequeño)
//  circular(14)  → RDSRadius.md    (mismo bucket — redondear a 12 en migración)
//  circular(16)  → RDSRadius.lg    (card pequeña, bottom sheet header)
//  circular(20)  → RDSRadius.xl    (card principal, RouteCard)
//  circular(24)  → RDSRadius.xl    (mismo bucket — redondear a 20 en migración)
//  circular(90+) → RDSRadius.full  (avatar, FAB circular)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class RDSRadius {
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double full = 999; // Para shapes circulares (avatar, pill)

  // BorderRadius convenientes
  static final BorderRadius bXs   = BorderRadius.circular(xs);
  static final BorderRadius bSm   = BorderRadius.circular(sm);
  static final BorderRadius bMd   = BorderRadius.circular(md);
  static final BorderRadius bLg   = BorderRadius.circular(lg);
  static final BorderRadius bXl   = BorderRadius.circular(xl);
  static final BorderRadius bFull = BorderRadius.circular(full);
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 5 — ELEVACIONES (Sombras)
//  Diagnóstico actual: blurRadius oscila entre 6 y 80.
//  Se estandarizan 4 niveles de elevación con color base de la sombra
//  derivado del acento del componente. Los shadows se definen como
//  funciones para aceptar color dinámico.
//
//  NIVELES
//  ───────
//  none   → sin sombra (elementos sobre fondo base, como chips de header)
//  low    → blur 8  · offset (0,2)  · cards dentro de listas
//  mid    → blur 16 · offset (0,4)  · cards flotantes, RouteCard
//  high   → blur 24 · offset (0,8)  · sheets, modales, FAB
//  glow   → blur 20 · offset (0,0)  · efecto glow de acentos (avatar nivel, botón activo)
// ─────────────────────────────────────────────────────────────────────────────
abstract final class RDSElevation {

  /// Sombra baja — tarjetas en lista
  static List<BoxShadow> low({Color color = Colors.black, double opacity = 0.25}) =>
    [BoxShadow(color: color.withOpacity(opacity), blurRadius: 8, offset: const Offset(0, 2))];

  /// Sombra media — RouteCard, cards flotantes
  static List<BoxShadow> mid({Color color = Colors.black, double opacity = 0.30}) =>
    [BoxShadow(color: color.withOpacity(opacity), blurRadius: 16, offset: const Offset(0, 4))];

  /// Sombra alta — modales, sheets, BottomNav
  static List<BoxShadow> high({Color color = Colors.black, double opacity = 0.50}) =>
    [BoxShadow(color: color.withOpacity(opacity), blurRadius: 24, offset: const Offset(0, 8))];

  /// Glow de acento — avatar con nivel, botón primario activo
  /// Ejemplo: RDSElevation.glow(color: RDSColor.green)
  static List<BoxShadow> glow({required Color color, double opacity = 0.40}) =>
    [BoxShadow(color: color.withOpacity(opacity), blurRadius: 20, spreadRadius: 0)];
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 6 — DURACIONES DE ANIMACIÓN
//  Diagnóstico actual: 10 valores distintos entre 180ms y 900ms.
//  Se consolidan en 4 tokens semánticos.
//
//  REGLA
//  ─────
//  instant  → feedback inmediato (ripple, toggle switch)
//  fast     → micro-interacciones (hover chip, botón tap)
//  normal   → transiciones de estado (card expand, modal in)
//  slow     → animaciones de entrada de pantalla, onboarding, splash
// ─────────────────────────────────────────────────────────────────────────────
abstract final class RDSDuration {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast    = Duration(milliseconds: 200);
  static const Duration normal  = Duration(milliseconds: 350);
  static const Duration slow    = Duration(milliseconds: 600);

  // Curvas recomendadas por tipo
  // instant/fast → Curves.easeOut
  // normal       → Curves.easeInOut
  // slow         → Curves.easeIn (para entradas) / Curves.elasticOut (para pins/badges)
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 7 — ICONOGRAFÍA
//
//  FILOSOFÍA DE SELECCIÓN
//  ──────────────────────
//  • Material Symbols Rounded: navegación, acciones, estados de UI.
//    Razón: consistencia con Material 3, filled/outlined/rounded en runtime,
//    peso variable. Ideal para BottomNav, AppBar, inputs.
//
//  • Lucide Icons: ilustraciones de feature, pantallas vacías (empty states),
//    íconos de categoría en cards. Trazo fino y carácter más neutral.
//    Ideal cuando el ícono compite con el contenido visual (fotos de ruta).
//
//  • Emojis: se mantienen ÚNICAMENTE en:
//    - Logros e insignias (su carácter expresivo es parte de la gamificación)
//    - Tips y microcopy conversacional
//    - Elementos donde el emoji es el contenido (no el UI)
//    Se eliminan de: BottomNav, AppBar, botones, chips de métricas, inputs.
//
//  DEPENDENCIAS A AGREGAR EN pubspec.yaml
//  ───────────────────────────────────────
//  dependencies:
//    material_symbols_icons: ^4.2799.0  # Material Symbols (Rounded)
//    lucide_icons: ^0.257.0             # Lucide Icons
//
//  IMPORTS
//  ───────
//  import 'package:material_symbols_icons/symbols.dart';
//  import 'package:lucide_icons/lucide_icons.dart';
//
// ─────────────────────────────────────────────────────────────────────────────

abstract final class RDSIcons {

  // ── BottomNav — Material Symbols Rounded ──────────────────────────────────
  // ANTES (emoji) → DESPUÉS (IconData)
  // '🗺️' Explorar  → Symbols.explore_rounded   (o Symbols.map_rounded)
  // '📍' Mapa      → Symbols.location_on_rounded
  // '🏆' Logros    → Symbols.military_tech_rounded
  // '👤' Perfil    → Symbols.person_rounded
  // '🌹' Feria     → Symbols.local_florist_rounded  (temporada)
  static const IconData navExplore  = Symbols.explore;
  static const IconData navMap      = Symbols.location_on;
  static const IconData navAchiev   = Symbols.military_tech;
  static const IconData navProfile  = Symbols.person;
  static const IconData navFeria    = Symbols.local_florist;    // Solo durante Feria

  // ── Chips de métricas en Header — Material Symbols ────────────────────────
  // ANTES: emoji '🗺️' '⭐' '📍' → íconos del sistema
  static const IconData metricRoutes = Symbols.explore;
  static const IconData metricPoints = Symbols.star;
  static const IconData metricSpots  = Symbols.location_on;

  // ── Acciones de RouteCard — Material Symbols ──────────────────────────────
  static const IconData actionExplore = Symbols.arrow_forward;
  static const IconData actionShare   = Symbols.share;
  static const IconData actionLock    = Symbols.lock;

  // ── Empty States — Material Icons (outlined) ─────────────────────────────
  // Usamos Icons.*_outlined para trazo fino — mismo efecto visual que Lucide
  // sin dependencia externa problemática.
  static const IconData emptyRoutes  = Icons.map_outlined;           // Sin rutas
  static const IconData emptyBadges  = Icons.emoji_events_outlined;  // Sin insignias
  static const IconData emptyPhotos  = Icons.image_outlined;         // Sin fotos
  static const IconData emptyRewards = Icons.card_giftcard_outlined; // Sin premios
  static const IconData emptySearch  = Icons.search_off_outlined;    // Sin resultados

  // ── Servicios / Categorías de ruta — Material Icons (outlined) ───────────
  static const IconData catCultura   = Icons.account_balance_outlined;
  static const IconData catNaturaleza= Icons.park_outlined;
  static const IconData catGastrono  = Icons.restaurant_outlined;
  static const IconData catArte      = Icons.palette_outlined;
  static const IconData catDeporte   = Icons.directions_bike_outlined;

  // ── Utilidades generales — Material Symbols ───────────────────────────────
  static const IconData close        = Symbols.close;
  static const IconData back         = Symbols.arrow_back;
  static const IconData check        = Symbols.check;
  static const IconData info         = Symbols.info;
  static const IconData warning      = Symbols.warning;
  static const IconData timer        = Symbols.timer;
  static const IconData camera       = Symbols.camera_alt;
  static const IconData qr           = Symbols.qr_code;
  static const IconData transport    = Symbols.directions_bus;
  static const IconData walk         = Symbols.directions_walk;
  static const IconData scooter      = Symbols.electric_scooter; // Whoosh
  static const IconData settings     = Symbols.settings;
  static const IconData language     = Symbols.language;
  static const IconData audio        = Symbols.volume_up;
  static const IconData audioOff     = Symbols.volume_off;
  static const IconData sos          = Symbols.sos;
  static const IconData planner      = Symbols.auto_awesome;     // Planner IA
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 8 — RDS 3.0 — NUEVOS TOKENS Y COMPONENTES
//  Fase B del rediseño premium. Agrega tokens faltantes y componentes
//  reutilizables para las 7 pantallas prioritarias.
//  NO modifica tokens existentes — solo extiende.
// ─────────────────────────────────────────────────────────────────────────────

// ── 8.1 TOKENS DE COLOR ADICIONALES ──────────────────────────────────────────
extension RDSColor3 on RDSColor {
  // Surface elevado — nivel intermedio entre surface y card
  // Úsalo en sheets y modales sobre RDSColor.surface
  static const Color surfaceElevated = Color(0xFF20251C);

  // Bordes con opacidad fija (evita .withOpacity() inline)
  static const Color borderGold10  = Color(0x1AC9A84C); // 10% gold
  static const Color borderGold20  = Color(0x33C9A84C); // 20% gold
  static const Color borderGold35  = Color(0x59C9A84C); // 35% gold
  static const Color borderWhite8  = Color(0x14FFFFFF); // 8% white
  static const Color borderWhite12 = Color(0x1FFFFFFF); // 12% white

  // Scrim cinematográfico — overlay de foto en hero
  static const Color scrimHero = Color(0xCC000000);     // 80% negro
  static const Color scrimCard = Color(0x99000000);     // 60% negro

  // Estado insignia
  static const Color badgeLocked    = Color(0xFF2A2E22); // Gris oscuro
  static const Color badgeAvailable = Color(0xFF1C2E1C); // Verde muy oscuro
  static const Color badgeCompleted = Color(0xFFC9A84C); // Gold
  static const Color badgeMastered  = Color(0xFFE8C96A); // Gold claro brillante

  // Sponsor — neutro para logos de patrocinadores
  static const Color sponsorBg     = Color(0xFF1C2018); // = card
  static const Color sponsorBorder = Color(0x33C9A84C); // = borderGold20
}

// ── 8.2 TIPOGRAFÍA ADICIONAL ─────────────────────────────────────────────────
extension RDSType3 on RDSType {
  // Display heroico — para SplashScreen y pantallas de celebración
  static const TextStyle displayHero = TextStyle(
    fontFamily: RDSType.familyDisplay, fontSize: 48, fontWeight: FontWeight.w900,
    color: RDSColor.textPrimary, letterSpacing: -1.0, height: 1.0);

  // Display extra grande — nombre de ruta en hero de RouteDetail
  static const TextStyle displayXl = TextStyle(
    fontFamily: RDSType.familyDisplay, fontSize: 36, fontWeight: FontWeight.w900,
    color: RDSColor.textPrimary, letterSpacing: -0.8, height: 1.05);

  // Tag / etiqueta de categoría — SpaceGrotesk uppercase
  static const TextStyle tag = TextStyle(
    fontFamily: RDSType.familyData, fontSize: 10, fontWeight: FontWeight.w700,
    color: RDSColor.textMuted, letterSpacing: 2.0, height: 1.2);

  // Puntos grandes — RewardScreen
  static const TextStyle points = TextStyle(
    fontFamily: RDSType.familyData, fontSize: 42, fontWeight: FontWeight.w700,
    color: RDSColor.gold, letterSpacing: -0.5, height: 1.0);

  // Distancia GPS — SitioInfoScreen
  static const TextStyle distance = TextStyle(
    fontFamily: RDSType.familyData, fontSize: 28, fontWeight: FontWeight.w700,
    color: RDSColor.textPrimary, letterSpacing: -0.3, height: 1.1);
}

// ── 8.3 GRADIENTES ADICIONALES ───────────────────────────────────────────────
// Usar en _HeroOverlay y RouteDetailScreen
class RDSGradient {
  // Scrim cinematográfico inferior — foto de ruta con texto encima
  static const LinearGradient heroScrim = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    stops: [0.0, 0.35, 1.0],
    colors: [Colors.transparent, Color(0x44000000), Color(0xEE000000)]);

  // Scrim lateral izquierdo — para texto sobre foto en landscape
  static const LinearGradient heroScrimLeft = LinearGradient(
    begin: Alignment.centerRight, end: Alignment.centerLeft,
    colors: [Colors.transparent, Color(0xCC000000)]);

  // Gradiente de celebración — RewardScreen
  static const LinearGradient reward = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A0A), Color(0xFF0A1A0A), Color(0xFF1A0A0A)]);

  // Gradiente GPS cerca — SitioInfoScreen estado "dentro del radio"
  static const LinearGradient gpsActive = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF0A1A0A), Color(0xFF1A2A1A)]);
}

// ── 8.4 COMPONENTE: _HeroOverlay ─────────────────────────────────────────────
// Overlay cinematográfico reutilizable para fotos de rutas.
// Uso: Stack([Image.asset(...), _HeroOverlay()])
//
// Ejemplo en RouteDetailScreen:
//   Stack(children: [
//     Image.asset(ruta['imagen'], fit: BoxFit.cover),
//     _HeroOverlay(),
//     Positioned(bottom: 0, child: _HeroContent(...)),
//   ])
class HeroOverlay extends StatelessWidget {
  final double intensity; // 0.0 a 1.0 — qué tan oscuro el scrim
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const HeroOverlay({
    super.key,
    this.intensity = 1.0,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: begin, end: end,
        stops: const [0.0, 0.3, 1.0],
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.3 * intensity),
          Colors.black.withOpacity(0.88 * intensity),
        ])));
}

// ── 8.5 COMPONENTE: _SitioCard ────────────────────────────────────────────────
// Card de sitio en RouteDetailScreen. 4 estados visuales.
// Úsalo para reemplazar los Container inline de la lista de sitios.
//
// Uso:
//   SitioCard(
//     numero: 1, nombre: 'Parque Prado', emoji: '🌳',
//     estado: SitioEstado.proximo, onTap: _irASitio)
enum SitioEstado { bloqueado, proximo, enProgreso, completado }

class SitioCard extends StatelessWidget {
  final int numero;
  final String nombre;
  final String emoji;
  final SitioEstado estado;
  final VoidCallback? onTap;
  final String? distancia;
  final String? descripcionBreve;

  const SitioCard({
    super.key,
    required this.numero,
    required this.nombre,
    required this.emoji,
    this.estado = SitioEstado.bloqueado,
    this.onTap,
    this.distancia,
    this.descripcionBreve,
  });

  @override
  Widget build(BuildContext context) {
    final bool activo = estado == SitioEstado.proximo || estado == SitioEstado.enProgreso;
    final bool hecho  = estado == SitioEstado.completado;
    final bool lock   = estado == SitioEstado.bloqueado;

    final Color acento = hecho
        ? RDSColor.gold
        : activo
            ? RDSColor.green
            : RDSColor.borderSubtle;

    return GestureDetector(
      onTap: lock ? null : onTap,
      child: AnimatedContainer(
        duration: RDSDuration.fast,
        margin: const EdgeInsets.only(bottom: RDSSpace.sm),
        padding: const EdgeInsets.all(RDSSpace.md),
        decoration: BoxDecoration(
          color: activo
              ? RDSColor.green.withOpacity(0.07)
              : hecho
                  ? RDSColor.gold.withOpacity(0.05)
                  : RDSColor.surface,
          borderRadius: RDSRadius.bLg,
          border: Border.all(
            color: acento.withOpacity(activo ? 0.35 : hecho ? 0.25 : 0.08),
            width: activo ? 1.5 : 1.0),
          boxShadow: activo
              ? RDSElevation.glow(color: RDSColor.green, opacity: 0.15)
              : null),
        child: Row(children: [
          // Número / estado
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hecho
                  ? RDSColor.gold.withOpacity(0.15)
                  : activo
                      ? RDSColor.green.withOpacity(0.15)
                      : RDSColor.borderSubtle.withOpacity(0.5),
              border: Border.all(color: acento.withOpacity(0.4))),
            child: Center(child: hecho
                ? Icon(RDSIcons.check, size: 16, color: RDSColor.gold)
                : lock
                    ? Icon(RDSIcons.actionLock, size: 14, color: RDSColor.textMuted)
                    : Text('$numero',
                        style: RDSType.labelMd.copyWith(
                          color: activo ? RDSColor.green : RDSColor.textMuted))),
          ),
          const SizedBox(width: RDSSpace.md),
          // Contenido
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: RDSSpace.xs),
                Expanded(child: Text(nombre,
                  style: RDSType.headlineMd.copyWith(
                    color: lock ? RDSColor.textMuted : RDSColor.textPrimary),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              if (descripcionBreve != null && !lock) ...[
                const SizedBox(height: 2),
                Text(descripcionBreve!,
                  style: RDSType.bodySm,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              if (activo && distancia != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RDSSpace.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: RDSColor.green.withOpacity(0.12),
                    borderRadius: RDSRadius.bFull),
                  child: Text(distancia!,
                    style: RDSType.labelSm.copyWith(color: RDSColor.green))),
              ],
            ])),
          // Flecha o check
          if (!lock)
            Icon(
              hecho ? RDSIcons.check : RDSIcons.actionExplore,
              size: 16,
              color: hecho ? RDSColor.gold : RDSColor.textMuted),
        ])));
  }
}

// ── 8.6 COMPONENTE: CategoryChip ─────────────────────────────────────────────
// Chip de filtro para Explorar y Mapa.
// Reemplaza los _FiltroChip inline en HomeBody y MapScreen.
//
// Uso:
//   CategoryChip(label: 'Ciudad', activo: true, onTap: () => ...)
class CategoryChip extends StatelessWidget {
  final String label;
  final bool activo;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;

  const CategoryChip({
    super.key,
    required this.label,
    required this.activo,
    required this.onTap,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color c = color ?? RDSColor.green;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: RDSDuration.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: RDSSpace.md, vertical: RDSSpace.sm - 2),
        decoration: BoxDecoration(
          color: activo ? c.withOpacity(0.15) : RDSColor.surface,
          borderRadius: RDSRadius.bFull,
          border: Border.all(
            color: activo ? c.withOpacity(0.5) : RDSColor.borderSubtle,
            width: activo ? 1.5 : 1.0),
          boxShadow: activo
              ? RDSElevation.glow(color: c, opacity: 0.12) : null),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 14,
              color: activo ? c : RDSColor.textMuted),
            const SizedBox(width: RDSSpace.xs),
          ],
          Text(label,
            style: RDSType.labelSm.copyWith(
              color: activo ? c : RDSColor.textMuted,
              fontWeight: activo ? FontWeight.w700 : FontWeight.w500)),
        ])));
  }
}

// ── 8.7 COMPONENTE: StatusBadge ───────────────────────────────────────────────
// Badge de estado de insignia — 4 niveles.
// Uso en AchievementsScreen y InsigniaCell.
//
// Uso:
//   StatusBadge(estado: InsigniaEstado.completado)
enum InsigniaEstado { locked, available, completed, mastered }

class StatusBadge extends StatelessWidget {
  final InsigniaEstado estado;
  final String? label;

  const StatusBadge({super.key, required this.estado, this.label});

  @override
  Widget build(BuildContext context) {
    final Map<InsigniaEstado, _BadgeStyle> styles = {
      InsigniaEstado.locked:    _BadgeStyle('BLOQUEADA', RDSColor.textMuted, RDSColor.surface),
      InsigniaEstado.available: _BadgeStyle('DISPONIBLE', RDSColor.green, RDSColor3.badgeAvailable),
      InsigniaEstado.completed: _BadgeStyle('COMPLETADA', RDSColor.gold, RDSColor3.badgeLocked),
      InsigniaEstado.mastered:  _BadgeStyle('MAESTRA', RDSColor.goldLight, RDSColor3.badgeLocked),
    };
    final style = styles[estado]!;
    final text = label ?? style.label;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RDSSpace.sm, vertical: 2),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: RDSRadius.bFull,
        border: Border.all(color: style.color.withOpacity(0.3))),
      child: Text(text,
        style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2.0, color: RDSColor.textMuted).copyWith(
          color: style.color, letterSpacing: 1.5)));
  }
}

class _BadgeStyle {
  final String label;
  final Color color;
  final Color bg;
  const _BadgeStyle(this.label, this.color, this.bg);
}

// ── 8.8 COMPONENTE: SponsorBadge ─────────────────────────────────────────────
// Logo de patrocinador para Splash, RewardScreen, RouteDetail.
// Respeta la jerarquía: nunca compite con el contenido principal.
//
// Uso en Splash (logo pequeño, esquina inferior):
//   SponsorBadge(logoAsset: 'assets/images/servicios/hotel_x.png',
//                label: 'Con el apoyo de')
//
// Uso en Reward (card de beneficio):
//   SponsorBadge.card(logoAsset: '...', label: 'Beneficio Rutero',
//                     beneficio: '10% de descuento')
class SponsorBadge extends StatelessWidget {
  final String? logoAsset;
  final String label;
  final String? beneficio;
  final bool asCard;

  const SponsorBadge({
    super.key,
    this.logoAsset,
    required this.label,
    this.beneficio,
    this.asCard = false,
  });

  const SponsorBadge.card({
    super.key,
    this.logoAsset,
    required this.label,
    this.beneficio,
  }) : asCard = true;

  @override
  Widget build(BuildContext context) {
    if (asCard) {
      return Container(
        padding: const EdgeInsets.all(RDSSpace.md),
        decoration: BoxDecoration(
          color: RDSColor.card,
          borderRadius: RDSRadius.bLg,
          border: Border.all(color: RDSColor.gold.withOpacity(0.2))),
        child: Row(children: [
          if (logoAsset != null)
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: RDSColor.surface,
                borderRadius: RDSRadius.bSm),
              child: ClipRRect(
                borderRadius: RDSRadius.bSm,
                child: Image.asset(logoAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                    Icon(RDSIcons.info, color: RDSColor.textMuted)))),
          const SizedBox(width: RDSSpace.md),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2.0, color: RDSColor.textMuted).copyWith(color: RDSColor.gold)),
              if (beneficio != null)
                Text(beneficio!, style: RDSType.headlineMd),
            ])),
          Icon(RDSIcons.actionExplore,
            size: 16, color: RDSColor.gold),
        ]));
    }

    // Versión compacta (splash, esquina de pantalla)
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RDSSpace.sm + 4, vertical: RDSSpace.xs + 2),
      decoration: BoxDecoration(
        color: RDSColor.card.withOpacity(0.85),
        borderRadius: RDSRadius.bMd,
        border: Border.all(color: RDSColor.gold.withOpacity(0.15))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: RDSType.caption.copyWith(
          color: RDSColor.textMuted)),
        if (logoAsset != null) ...[
          const SizedBox(width: RDSSpace.xs),
          Image.asset(logoAsset!, height: 16,
            errorBuilder: (_, __, ___) => const SizedBox.shrink()),
        ],
      ]));
  }
}

// ── 8.9 COMPONENTE: GpsRangeIndicator ────────────────────────────────────────
// Indicador de distancia GPS para SitioInfoScreen.
// 3 estados visuales con transición animada.
//
// Uso:
//   GpsRangeIndicator(distanciaMetros: _distancia, radioMetros: 30)
class GpsRangeIndicator extends StatelessWidget {
  final double? distanciaMetros;
  final double radioMetros;
  final bool errorGps;

  const GpsRangeIndicator({
    super.key,
    required this.distanciaMetros,
    this.radioMetros = 30,
    this.errorGps = false,
  });

  @override
  Widget build(BuildContext context) {
    if (errorGps) return _estado(
      color: RDSColor.stateError,
      icon: RDSIcons.warning,
      label: 'GPS no disponible',
      sublabel: 'Verifica tu conexión');

    if (distanciaMetros == null) return _estado(
      color: RDSColor.textMuted,
      icon: RDSIcons.info,
      label: 'Localizando...',
      sublabel: 'Buscando señal GPS');

    final bool dentro = distanciaMetros! <= radioMetros;
    final bool cerca  = distanciaMetros! <= radioMetros * 5;

    if (dentro) return _estadoDentro();
    if (cerca)  return _estado(
      color: RDSColor.gold,
      icon: RDSIcons.metricSpots,
      label: '${distanciaMetros!.toStringAsFixed(0)} m',
      sublabel: '¡Casi llegás!');

    return _estado(
      color: RDSColor.textMuted,
      icon: RDSIcons.walk,
      label: distanciaMetros! >= 1000
          ? '${(distanciaMetros! / 1000).toStringAsFixed(1)} km'
          : '${distanciaMetros!.toStringAsFixed(0)} m',
      sublabel: 'Dirigite al sitio');
  }

  Widget _estado({
    required Color color,
    required IconData icon,
    required String label,
    required String sublabel,
  }) => Container(
    padding: const EdgeInsets.all(RDSSpace.md),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: RDSRadius.bLg,
      border: Border.all(color: color.withOpacity(0.2))),
    child: Row(children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(width: RDSSpace.md),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: RDSType3.distance.copyWith(
          color: color, fontSize: 22)),
        Text(sublabel, style: RDSType.bodySm),
      ]),
    ]));

  Widget _estadoDentro() => Container(
    padding: const EdgeInsets.all(RDSSpace.md),
    decoration: BoxDecoration(
      color: RDSColor.green.withOpacity(0.12),
      borderRadius: RDSRadius.bLg,
      border: Border.all(color: RDSColor.green.withOpacity(0.4), width: 1.5),
      boxShadow: RDSElevation.glow(color: RDSColor.green, opacity: 0.2)),
    child: Row(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: RDSColor.green.withOpacity(0.2),
          shape: BoxShape.circle),
        child: Icon(RDSIcons.check, color: RDSColor.green, size: 20)),
      const SizedBox(width: RDSSpace.md),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('ESTÁS EN EL LUGAR',
          style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2.0, color: RDSColor.textMuted).copyWith(
            color: RDSColor.green, letterSpacing: 2.0)),
        Text('Podés validar tu visita',
          style: RDSType.headlineMd.copyWith(color: RDSColor.textPrimary)),
      ]),
    ]));
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 10 — LEGACY ALIASES
//  Permite que main.dart siga compilando con los viejos kXxx durante
//  la migración. No usar en código nuevo.
//  Una vez que un componente migre, elimina el alias correspondiente.
// ─────────────────────────────────────────────────────────────────────────────

// ignore_for_file: constant_identifier_names
const Color kDark       = RDSColor.overlay;
const Color kDark2      = RDSColor.base;
const Color kDark3      = RDSColor.surface;
const Color kCard       = RDSColor.card;
const Color kText       = RDSColor.textPrimary;
const Color kTextMuted  = RDSColor.textMuted;
const Color kGreen      = RDSColor.green;
const Color kGold       = RDSColor.gold;
const Color kGoldLight  = RDSColor.goldLight;
const Color kAccent     = RDSColor.accent;
const Color kOrchid     = RDSColor.orchid;
const Color kFeriaRojo  = RDSColor.feriaRed;
const Color kFeriaRosa  = RDSColor.feriaRose;
const Color kFeriaVerde = RDSColor.feriaForest;
const Color kFeriaDorado= RDSColor.gold; // mismo valor

// ─────────────────────────────────────────────────────────────────────────────
//  SECCIÓN 9 — NOTAS DE MIGRACIÓN
//  Lista de inconsistencias encontradas en main.dart que deben corregirse
//  componente por componente. Tachar a medida que se resuelven.
//
//  FONDOS
//  ☐ OnboardingScreen  → Color(0xFF0A080F)  → reemplazar por RDSColor.base
//  ☐ CompraScreen      → kCard como fondo   → reemplazar por RDSColor.base
//  ☐ LoginScreen       → revisar fondo      → unificar a RDSColor.base
//
//  RADIOS
//  ☐ circular(14) en _GoldButton           → migrar a RDSRadius.md (12)
//  ☐ circular(14) en CompraScreen          → migrar a RDSRadius.md (12)
//  ☐ circular(24) en LogroPublicoScreen    → migrar a RDSRadius.xl (20)
//
//  TIPOGRAFÍA
//  ☐ fontSize: 9  (40 usos)  → migrar a caption (11) con letterSpacing
//  ☐ fontSize: 16 (68 usos)  → migrar a headlineMd (15) o displaySm (18)
//  ☐ fontSize: 20 (33 usos)  → migrar a displaySm (18) o headlineLg (18)
//  ☐ fontSize: 24 (19 usos)  → migrar a displayMd (22)
//
//  EMOJIS A REEMPLAZAR (Fase 2 — componentes)
//  ☐ BottomNav: 🗺️📍🏆👤🌹  → RDSIcons.navXxx
//  ☐ _HeaderChip: 🗺️⭐📍     → RDSIcons.metricXxx
//  ☐ _MenuOpcion: emojis de acción → RDSIcons utilidades
//  ☐ _SOSFloatingButton: 🆘  → RDSIcons.sos
//  ☐ MisPremiosScreen: 🔒    → RDSIcons.actionLock
//
//  EMOJIS QUE SE MANTIENEN (no migrar)
//  ✅ Insignias y logros (🌱🌿⛰️🦅🏆🏅) — parte de la gamificación
//  ✅ Tips conversacionales y microcopy
//  ✅ Niveles de avatar (emoji es el contenido, no el UI)
//  ✅ Badges de Feria (🌹) cuando aparece como contenido visual, no como ícono de nav
// ─────────────────────────────────────────────────────────────────────────────
