// ════════════════════════════════════════════════════════════════════════════
//  RUTERO MDE — Design System v1.0
//  Fase 1: Foundation
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
//  SECCIÓN 8 — LEGACY ALIASES
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
