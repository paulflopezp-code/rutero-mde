import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_screen.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RuteroApp());
}

class RuteroApp extends StatelessWidget {
  const RuteroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      routes: {
        '/home': (_) => const HomeScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

// ── SPLASH ────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleAnim;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
    // Verificar sesión en paralelo mientras anima
    User? _userResult;
    AuthService.currentUser != null
        ? _userResult = AuthService.currentUser
        : null;

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        final user = AuthService.currentUser;
        if (user == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFC9A84C),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🗺️', style: TextStyle(fontSize: 48)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeTransition(
                  opacity: _fadeIn,
                  child: const Text(
                    'RUTERO MDE',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFF0EDE6),
                      letterSpacing: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeIn,
                  child: const Text(
                    'Descubre Medellín a tu ritmo',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8278),
                      letterSpacing: 2,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fadeIn,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: AnimatedBuilder(
                            animation: _progressAnim,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressAnim.value,
                                backgroundColor: const Color(0xFF1E1E1E),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFC9A84C),
                                ),
                                minHeight: 3,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'RUTERO MDE · 2026',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8A8278),
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── HOME ──────────────────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFeaturedBanner(),
            Expanded(child: _buildRouteList(context)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = AuthService.currentUser;
    final nombre = user?.displayName?.split(' ').first ?? 'Explorador';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, $nombre 👋',
                style: const TextStyle(
                  color: Color(0xFF8A8278),
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Explorar Medellín',
                style: TextStyle(
                  color: Color(0xFFF0EDE6),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _mostrarMenuPerfil(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: user?.photoURL != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(user!.photoURL!, fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Text('🗺️', style: TextStyle(fontSize: 20)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarMenuPerfil(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AuthService.currentUser?.displayName ?? 'Usuario',
              style: const TextStyle(
                color: Color(0xFFF0EDE6),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AuthService.currentUser?.email ?? '',
              style: const TextStyle(color: Color(0xFF8A8278), fontSize: 13),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                await AuthService.signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (r) => false,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF5A2A2A)),
                ),
                child: const Center(
                  child: Text(
                    '🚪 Cerrar sesión',
                    style: TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4D2E), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF1A4D2E),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '🌹 TEMPORADA',
                style: TextStyle(
                  color: Color(0xFFC9A84C),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Feria de las Flores',
                style: TextStyle(
                  color: Color(0xFFF0EDE6),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '1 – 10 de agosto · 8 sitios',
                style: TextStyle(
                  color: Color(0xFF8A8278),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFC9A84C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '\$7.900',
              style: TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get routes => [
        {
          'emoji': '🎨',
          'nombre': 'Transformación Urbana',
          'zona': 'Comuna 13',
          'tipo': 'Arte urbano',
          'duracion': '3h',
          'dificultad': 'Fácil',
          'precio': '\$6.900',
          'descripcion':
              'Recorrido por uno de los barrios más transformados del mundo. Grafitis, escaleras eléctricas y la historia viva de Medellín.',
          'sitios': [
            'Estación San Javier',
            'Escaleras Eléctricas',
            'Mural Hip-Hop',
            'El Corazón de la 13',
            'Biblioteca Fernando Botero',
            'Mirador La Escuela',
          ],
          'premio':
              'Insignia Explorador de la 13 + 20% descuento en tienda de artesanías',
          'completados': 3,
        },
        {
          'emoji': '🏛️',
          'nombre': 'Patrimonial del Centro',
          'zona': 'La Candelaria',
          'tipo': 'Historia',
          'duracion': '2.5h',
          'dificultad': 'Fácil',
          'precio': '\$4.900',
          'descripcion':
              'El corazón histórico de Medellín con arquitectura republicana, esculturas de Botero y museos de talla mundial.',
          'sitios': [
            'Plaza Botero',
            'Museo de Antioquia',
            'Palacio de la Cultura',
            'Basílica de la Candelaria',
            'Parque de Berrío',
          ],
          'premio':
              'Insignia Guardián del Patrimonio + entrada gratis Museo de Antioquia',
          'completados': 0,
        },
        {
          'emoji': '🌿',
          'nombre': 'Verde del Norte',
          'zona': 'Aranjuez',
          'tipo': 'Naturaleza',
          'duracion': '3h',
          'dificultad': 'Fácil',
          'precio': '\$5.900',
          'descripcion':
              'El pulmón verde de la ciudad: jardines, ciencia interactiva y el Orquideorama.',
          'sitios': [
            'Jardín Botánico',
            'Orquideorama',
            'Parque Explora',
            'Planetario',
            'Parque de los Deseos',
          ],
          'premio':
              'Insignia Guardabosque Urbano + 15% descuento cafetería Jardín Botánico',
          'completados': 0,
        },
        {
          'emoji': '🚡',
          'nombre': 'Metrocable & Arví',
          'zona': 'Santo Domingo',
          'tipo': 'Innovación',
          'duracion': '4h',
          'dificultad': 'Medio',
          'precio': '\$7.900',
          'descripcion':
              'Subir en cable aéreo sobre los barrios populares para llegar al bosque más importante de la ciudad.',
          'sitios': [
            'Estación Acevedo',
            'Metrocable Línea K',
            'Biblioteca España',
            'Mirador Santo Domingo',
            'Parque Arví',
          ],
          'premio':
              'Insignia Viajero de las Alturas + bebida gratis mercado de Arví',
          'completados': 0,
        },
        {
          'emoji': '🍽️',
          'nombre': 'Gourmet Poblado',
          'zona': 'El Poblado',
          'tipo': 'Gastronomía',
          'duracion': '2.5h',
          'dificultad': 'Fácil',
          'precio': '\$5.900',
          'descripcion':
              'Recorrido gastronómico por el barrio más cosmopolita de Medellín.',
          'sitios': [
            'Parque El Poblado',
            'Calle Provenza',
            'Mercado del Poblado',
            'Café Pergamino',
            'Parque Lleras',
          ],
          'premio':
              'Insignia Catador Paisa + postre gratis en restaurante aliado',
          'completados': 0,
        },
        {
          'emoji': '🪂',
          'nombre': 'Ruta de las Alturas',
          'zona': 'San Félix · Bello',
          'tipo': 'Aventura Premium',
          'duracion': '5h',
          'dificultad': 'Medio',
          'precio': '\$15.900',
          'descripcion':
              'Vuelo en parapente biplaza sobre Medellín desde la zona de despegue de San Félix.',
          'sitios': [
            'Mirador San Félix',
            'Zona de despegue',
            'Vuelo en parapente',
            'Zona de aterrizaje',
            'Mirador El Túnel',
          ],
          'premio':
              'Insignia Águila del Valle + 15% descuento próximo vuelo + foto aérea',
          'completados': 0,
        },
      ];

  Widget _buildRouteList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RouteDetailScreen(route: routes[index]),
              ),
            );
          },
          child: _buildRouteCard(routes[index]),
        );
      },
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222222), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                route['emoji'],
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route['nombre'],
                  style: const TextStyle(
                    color: Color(0xFFF0EDE6),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${route['zona']} · ${route['tipo']}',
                  style: const TextStyle(
                    color: Color(0xFF8A8278),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildChip('⏱ ${route['duracion']}'),
                    const SizedBox(width: 6),
                    _buildChip('💪 ${route['dificultad']}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFC9A84C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              route['precio'],
              style: const TextStyle(
                color: Color(0xFF0D0D0D),
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF8A8278), fontSize: 11),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        border: Border(top: BorderSide(color: Color(0xFF222222), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('🗺️', 'Explorar', true),
          _buildNavItem('🎒', 'Mis Rutas', false),
          _buildNavItem('🏆', 'Insignias', false),
          GestureDetector(
            onTap: () => _mostrarMenuPerfil(context),
            child: _buildNavItem('👤', 'Perfil', false),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String emoji, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFFC9A84C) : const Color(0xFF555555),
            fontSize: 10,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ── DETALLE DE RUTA ───────────────────────────────────────────────────────────
class RouteDetailScreen extends StatelessWidget {
  final Map<String, dynamic> route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final sitios = route['sitios'] as List<String>;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF111111),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFF0EDE6),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A4D2E), Color(0xFF0D0D0D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        route['emoji'],
                        style: const TextStyle(fontSize: 64),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route['nombre'],
                    style: const TextStyle(
                      color: Color(0xFFF0EDE6),
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${route['zona']} · ${route['tipo']}',
                    style: const TextStyle(
                      color: Color(0xFF8A8278),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _metricChip('⏱', route['duracion']),
                      const SizedBox(width: 8),
                      _metricChip('💪', route['dificultad']),
                      const SizedBox(width: 8),
                      _metricChip('📍', '${sitios.length} sitios'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      color: Color(0xFFC9A84C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    route['descripcion'],
                    style: const TextStyle(
                      color: Color(0xFF8A8278),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sitios del recorrido',
                    style: TextStyle(
                      color: Color(0xFFC9A84C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...sitios
                      .asMap()
                      .entries
                      .map((e) => _sitioItem(e.key + 1, e.value)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A00),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFC9A84C).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Premio al completar',
                                style: TextStyle(
                                  color: Color(0xFFC9A84C),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                route['premio'],
                                style: const TextStyle(
                                  color: Color(0xFFF0EDE6),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreen(route: route),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A4D2E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF2D6A4F)),
                      ),
                      child: const Center(
                        child: Text(
                          '🗺️  Ver mapa del recorrido',
                          style: TextStyle(
                            color: Color(0xFFF0EDE6),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PurchaseScreen(route: route),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC9A84C).withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Comprar ruta · ${route['precio']}',
                          style: const TextStyle(
                            color: Color(0xFF0D0D0D),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF0EDE6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sitioItem(int numero, String nombre) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF1A4D2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$numero',
                style: const TextStyle(
                  color: Color(0xFFC9A84C),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            nombre,
            style: const TextStyle(color: Color(0xFFF0EDE6), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ── MAPA ──────────────────────────────────────────────────────────────────────
class MapScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  const MapScreen({super.key, required this.route});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late int _completados;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late BuildContext _buildContext;

  int _filtro = 0;
  int? _pinSeleccionado;
  late AnimationController _pinSelectController;
  late Animation<double> _pinSelectAnim;

  @override
  void initState() {
    super.initState();
    _completados = widget.route['completados'] as int? ?? 0;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pinSelectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pinSelectAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pinSelectController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pinSelectController.dispose();
    super.dispose();
  }

  void _seleccionarPin(int index) {
    setState(() => _pinSeleccionado = index);
    _pinSelectController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    final sitios = widget.route['sitios'] as List<String>;
    final progreso = _completados / sitios.length;
    final bool rutaCompleta = _completados >= sitios.length;
    final int mostrar = _pinSeleccionado ??
        (_completados < sitios.length ? _completados : sitios.length - 1);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) =>
                  _handleMapTap(details.localPosition, sitios),
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, __) => CustomPaint(
                  painter: MapPainter(
                    sitios: sitios,
                    completados: _completados,
                    pulseValue: _pulseAnim.value,
                    filtro: _filtro,
                    pinSeleccionado: _pinSeleccionado,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111).withOpacity(0.92),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFF333333)),
                            ),
                            child: const Icon(Icons.arrow_back,
                                color: Color(0xFFF0EDE6), size: 20),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111).withOpacity(0.92),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFF333333)),
                            ),
                            child: Row(
                              children: [
                                Text(widget.route['emoji'],
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.route['nombre'],
                                    style: const TextStyle(
                                        color: Color(0xFFF0EDE6),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A4D2E),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(progreso * 100).toInt()}%',
                                    style: const TextStyle(
                                        color: Color(0xFF4CAF7C),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111).withOpacity(0.92),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF333333)),
                          ),
                          child: const Center(
                              child:
                                  Text('📍', style: TextStyle(fontSize: 18))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _filtroChip(0, 'Todos', '🗺️'),
                        const SizedBox(width: 6),
                        _filtroChip(1, 'Visitados', '✅'),
                        const SizedBox(width: 6),
                        _filtroChip(2, 'Pendientes', '🔒'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF111111).withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color(0xFFC9A84C).withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Text(
                    '${(progreso * 100).toInt()}%',
                    style: const TextStyle(
                        color: Color(0xFFC9A84C),
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progreso,
                        backgroundColor: const Color(0xFF1E1E1E),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFC9A84C)),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_completados/${sitios.length}',
                    style: const TextStyle(
                        color: Color(0xFF8A8278),
                        fontSize: 9,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomCard(context, sitios, mostrar, rutaCompleta),
          ),
        ],
      ),
    );
  }

  void _handleMapTap(Offset tapPos, List<String> sitios) {
    for (int i = 0; i < sitios.length; i++) {
      _seleccionarPin(i);
      break;
    }
  }

  Widget _filtroChip(int idx, String label, String emoji) {
    final active = _filtro == idx;
    return GestureDetector(
      onTap: () => setState(() => _filtro = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFC9A84C)
              : const Color(0xFF111111).withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFFC9A84C) : const Color(0xFF333333),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 11)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    active ? const Color(0xFF0D0D0D) : const Color(0xFF8A8278),
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context, List<String> sitios,
      int mostrar, bool rutaCompleta) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Color(0xFF222222))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(2)),
          ),
          if (!rutaCompleta) ...[
            AnimatedBuilder(
              animation: _pinSelectAnim,
              builder: (_, child) =>
                  Transform.scale(scale: _pinSelectAnim.value, child: child),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: mostrar < _completados
                        ? const Color(0xFF4CAF7C).withOpacity(0.4)
                        : mostrar == _completados
                            ? const Color(0xFFC9A84C).withOpacity(0.5)
                            : const Color(0xFF333333),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mostrar < _completados
                            ? const Color(0xFF1A4D2E)
                            : mostrar == _completados
                                ? const Color(0xFFC9A84C)
                                : const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          mostrar < _completados ? '✓' : '${mostrar + 1}',
                          style: TextStyle(
                            color: mostrar < _completados
                                ? const Color(0xFF4CAF7C)
                                : mostrar == _completados
                                    ? const Color(0xFF0D0D0D)
                                    : const Color(0xFF555555),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mostrar < _completados
                                ? 'SITIO COMPLETADO'
                                : mostrar == _completados
                                    ? 'SIGUIENTE DESTINO'
                                    : 'SITIO PENDIENTE',
                            style: TextStyle(
                              color: mostrar < _completados
                                  ? const Color(0xFF4CAF7C)
                                  : mostrar == _completados
                                      ? const Color(0xFFC9A84C)
                                      : const Color(0xFF555555),
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sitios[mostrar],
                            style: const TextStyle(
                                color: Color(0xFFF0EDE6),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          if (mostrar == _completados) ...[
                            const SizedBox(height: 4),
                            const Text('📍 A 0.2 km de tu ubicación',
                                style: TextStyle(
                                    color: Color(0xFF8A8278), fontSize: 11)),
                          ],
                        ],
                      ),
                    ),
                    if (mostrar == _completados)
                      GestureDetector(
                        onTap: () => _abrirValidacion(_buildContext),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('📷 Ir',
                              style: TextStyle(
                                  color: Color(0xFF0D0D0D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      )
                    else if (mostrar < _completados)
                      const Text('✅', style: TextStyle(fontSize: 24))
                    else
                      const Text('🔒',
                          style: TextStyle(
                              fontSize: 22, color: Color(0xFF444444))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (mostrar == _completados)
              GestureDetector(
                onTap: () => _abrirValidacion(_buildContext),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFC9A84C).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: const Center(
                    child: Text('📷  VALIDAR ESTE SITIO',
                        style: TextStyle(
                            color: Color(0xFF0D0D0D),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5)),
                  ),
                ),
              ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF1A4D2E), Color(0xFF2D6A4F)]),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: const Color(0xFF4CAF7C).withOpacity(0.5)),
              ),
              child: Row(
                children: const [
                  Text('🏆', style: TextStyle(fontSize: 28)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('¡RUTA COMPLETADA!',
                            style: TextStyle(
                                color: Color(0xFF4CAF7C),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2)),
                        SizedBox(height: 3),
                        Text('Todos los sitios verificados',
                            style: TextStyle(
                                color: Color(0xFF8A8278), fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                  _buildContext,
                  MaterialPageRoute(
                      builder: (_) => RewardScreen(route: widget.route))),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFC9A84C).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: const Center(
                  child: Text('🏅  RECLAMAR MI PREMIO',
                      style: TextStyle(
                          color: Color(0xFF0D0D0D),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5)),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sitios.length,
              itemBuilder: (_, i) {
                final isDone = i < _completados;
                final isActive = i == _completados && !rutaCompleta;
                final isSelected = _pinSeleccionado == i;
                return GestureDetector(
                  onTap: () => _seleccionarPin(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2A2000)
                          : isDone
                              ? const Color(0xFF1A4D2E)
                              : isActive
                                  ? const Color(0xFFC9A84C)
                                  : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFC9A84C)
                            : isDone
                                ? const Color(0xFF4CAF7C).withOpacity(0.5)
                                : isActive
                                    ? const Color(0xFFC9A84C)
                                    : const Color(0xFF333333),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                            isDone
                                ? '✅'
                                : isActive
                                    ? '📍'
                                    : '🔒',
                            style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 5),
                        Text(
                          sitios[i].split(' ').first,
                          style: TextStyle(
                            color: isDone
                                ? const Color(0xFF4CAF7C)
                                : isActive
                                    ? const Color(0xFF0D0D0D)
                                    : const Color(0xFF8A8278),
                            fontSize: 11,
                            fontWeight: isActive || isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirValidacion(BuildContext ctx) async {
    final sitiosLocal = widget.route['sitios'] as List<String>;
    final completadosLocal = _completados;
    final bool esUltimo = completadosLocal + 1 >= sitiosLocal.length;

    final validated = await Navigator.push<bool>(
      ctx,
      MaterialPageRoute(
        builder: (_) => PhotoValidationScreen(
          sitio: sitiosLocal[completadosLocal],
          numero: completadosLocal + 1,
        ),
      ),
    );

    if (validated == true && mounted) {
      final nuevoTotal = (_completados + 1).clamp(0, sitiosLocal.length);
      setState(() {
        _completados = nuevoTotal;
        widget.route['completados'] = _completados;
        _pinSeleccionado = null;
      });

      // Guardar progreso en Firestore
      await AuthService.guardarRutaComprada(widget.route['nombre']);

      if (esUltimo) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted) return;
        Navigator.push(
            ctx,
            MaterialPageRoute(
                builder: (_) => RewardScreen(route: widget.route)));
      }
    }
  }
}

class MapPainter extends CustomPainter {
  final List<String> sitios;
  final int completados;
  final double pulseValue;
  final int filtro;
  final int? pinSeleccionado;

  static final _rnd = Random(42);
  static List<Offset>? _cachedPositions;
  static int _cachedCount = 0;

  MapPainter({
    required this.sitios,
    required this.completados,
    required this.pulseValue,
    this.filtro = 0,
    this.pinSeleccionado,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0E1A0E),
    );

    final gridP = Paint()
      ..color = const Color(0xFF1A261A)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 32)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridP);
    for (double y = 0; y < size.height; y += 32)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridP);

    final blockP = Paint()..color = const Color(0xFF122012);
    final blocks = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.08, size.width * 0.22,
          size.height * 0.12),
      Rect.fromLTWH(size.width * 0.34, size.height * 0.06, size.width * 0.18,
          size.height * 0.14),
      Rect.fromLTWH(size.width * 0.62, size.height * 0.10, size.width * 0.28,
          size.height * 0.10),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.28, size.width * 0.16,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.28, size.height * 0.30, size.width * 0.20,
          size.height * 0.16),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.26, size.width * 0.14,
          size.height * 0.20),
      Rect.fromLTWH(size.width * 0.76, size.height * 0.28, size.width * 0.18,
          size.height * 0.14),
      Rect.fromLTWH(size.width * 0.08, size.height * 0.52, size.width * 0.24,
          size.height * 0.12),
      Rect.fromLTWH(size.width * 0.40, size.height * 0.50, size.width * 0.16,
          size.height * 0.14),
      Rect.fromLTWH(size.width * 0.64, size.height * 0.48, size.width * 0.20,
          size.height * 0.16),
    ];
    for (final b in blocks) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(b, const Radius.circular(4)), blockP);
    }

    final avW = Paint()
      ..color = const Color(0xFF1C2E1C)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    final avN = Paint()
      ..color = const Color(0xFF172717)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.24),
        Offset(size.width, size.height * 0.24), avW);
    canvas.drawLine(Offset(0, size.height * 0.48),
        Offset(size.width, size.height * 0.48), avW);
    canvas.drawLine(Offset(size.width * 0.32, 0),
        Offset(size.width * 0.32, size.height), avW);
    canvas.drawLine(Offset(size.width * 0.68, 0),
        Offset(size.width * 0.68, size.height), avW);
    canvas.drawLine(Offset(0, size.height * 0.36),
        Offset(size.width * 0.68, size.height * 0.36), avN);
    canvas.drawLine(Offset(size.width * 0.32, size.height * 0.60),
        Offset(size.width, size.height * 0.60), avN);
    canvas.drawLine(Offset(size.width * 0.16, 0),
        Offset(size.width * 0.16, size.height * 0.48), avN);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.24),
        Offset(size.width * 0.52, size.height), avN);
    canvas.drawLine(Offset(size.width * 0.82, 0),
        Offset(size.width * 0.82, size.height * 0.60), avN);
    canvas.drawLine(Offset(0, size.height * 0.68),
        Offset(size.width * 0.45, size.height * 0.52), avN);
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.52),
        Offset(size.width, size.height * 0.62), avN);

    final positions = _getPositions(size, sitios.length);

    if (filtro != 1) {
      _drawRouteLine(canvas, positions, completados);
    }

    for (int i = 0; i < positions.length; i++) {
      final isDone = i < completados;
      final isActive = i == completados;
      final isSelected = pinSeleccionado == i;

      if (filtro == 1 && !isDone) continue;
      if (filtro == 2 && isDone) continue;

      _drawBubblePin(canvas, positions[i], sitios[i], i + 1, isDone, isActive,
          isSelected, pulseValue);
    }

    _drawUserDot(canvas, Offset(size.width * 0.46, size.height * 0.51));
  }

  void _drawRouteLine(Canvas canvas, List<Offset> positions, int completados) {
    if (completados > 0) {
      final donePath = Path();
      donePath.moveTo(positions[0].dx, positions[0].dy);
      for (int i = 1; i < min(completados + 1, positions.length); i++) {
        donePath.lineTo(positions[i].dx, positions[i].dy);
      }
      canvas.drawPath(
          donePath,
          Paint()
            ..color = const Color(0xFF4CAF7C).withOpacity(0.6)
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round);
    }

    final startIdx = completados == 0 ? 0 : completados;
    if (startIdx < positions.length - 1) {
      final pendPath = Path();
      pendPath.moveTo(positions[startIdx].dx, positions[startIdx].dy);
      for (int i = startIdx + 1; i < positions.length; i++) {
        pendPath.lineTo(positions[i].dx, positions[i].dy);
      }
      canvas.drawPath(
          pendPath,
          Paint()
            ..color = const Color(0xFFC9A84C).withOpacity(0.35)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round);
    }
  }

  void _drawBubblePin(Canvas canvas, Offset pos, String nombre, int numero,
      bool isDone, bool isActive, bool isSelected, double pulse) {
    final baseColor = isDone
        ? const Color(0xFF4CAF7C)
        : isActive
            ? const Color(0xFFC9A84C)
            : const Color(0xFF2A2A2A);
    final double radius = isActive
        ? 20
        : isSelected
            ? 18
            : 14;

    if (isActive) {
      for (double r = 1.0; r <= 1.8; r += 0.4) {
        canvas.drawCircle(
            pos,
            radius * r * (0.8 + (pulse - 0.8) * 0.5),
            Paint()
              ..color = const Color(0xFFC9A84C).withOpacity(0.08 * (2.2 - r)));
      }
    }

    canvas.drawCircle(
        pos + const Offset(0, 3),
        radius,
        Paint()
          ..color = Colors.black.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawCircle(pos, radius, Paint()..color = baseColor);
    canvas.drawCircle(
        pos,
        radius,
        Paint()
          ..color = isActive || isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActive ? 2.5 : 1.5);

    final tp = TextPainter(
      text: TextSpan(
        text: isDone ? '✓' : '$numero',
        style: TextStyle(
          color: isDone
              ? Colors.white
              : isActive
                  ? const Color(0xFF0D0D0D)
                  : const Color(0xFF8A8278),
          fontSize: isActive ? 13 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));

    final labelTP = TextPainter(
      text: TextSpan(
        text: nombre.split(' ').take(2).join(' '),
        style: TextStyle(
          color: isActive
              ? const Color(0xFFE8C96A)
              : isDone
                  ? const Color(0xFF4CAF7C)
                  : const Color(0xFF8A8278),
          fontSize: 8,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 70);

    final labelRect = Rect.fromCenter(
      center: Offset(pos.dx, pos.dy + radius + 10),
      width: labelTP.width + 8,
      height: 14,
    );
    canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
        Paint()..color = Colors.black.withOpacity(0.65));
    labelTP.paint(canvas, Offset(labelRect.left + 4, labelRect.top + 1));
  }

  void _drawUserDot(Canvas canvas, Offset pos) {
    for (double r = 1.0; r <= 2.5; r += 0.8) {
      canvas.drawCircle(pos, 12 * r,
          Paint()..color = const Color(0xFF4A9EFF).withOpacity(0.06 * (3 - r)));
    }
    canvas.drawCircle(pos, 11, Paint()..color = const Color(0xFF4A9EFF));
    canvas.drawCircle(
        pos,
        11,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);
    canvas.drawCircle(pos, 4, Paint()..color = Colors.white);
  }

  List<Offset> _getPositions(Size size, int count) {
    if (_cachedCount == count && _cachedPositions != null)
      return _cachedPositions!;
    final rnd = Random(42);
    const cols = 3;
    final positions = <Offset>[];
    for (int i = 0; i < count; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x =
          size.width * (0.15 + col * 0.30) + (rnd.nextDouble() - 0.5) * 28;
      final y =
          size.height * (0.15 + row * 0.22) + (rnd.nextDouble() - 0.5) * 16;
      positions.add(Offset(x, y.clamp(60.0, size.height * 0.50)));
    }
    _cachedPositions = positions;
    _cachedCount = count;
    return positions;
  }

  @override
  bool shouldRepaint(MapPainter old) =>
      old.pulseValue != pulseValue ||
      old.completados != completados ||
      old.filtro != filtro ||
      old.pinSeleccionado != pinSeleccionado;
}

// ── PANTALLA DE COMPRA ────────────────────────────────────────────────────────
class PurchaseScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  const PurchaseScreen({super.key, required this.route});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen>
    with SingleTickerProviderStateMixin {
  int _metodoPago = 0;
  bool _comprando = false;
  bool _comprado = false;

  late AnimationController _successController;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  static const _metodos = [
    {'icon': '💳', 'label': 'Tarjeta'},
    {'icon': '🏦', 'label': 'Nequi'},
    {'icon': '💰', 'label': 'Daviplata'},
  ];

  static const _incluye = [
    {'icon': '🗺️', 'text': 'Mapa interactivo con guía de cada sitio'},
    {'icon': '📷', 'text': 'Validación por foto con GPS'},
    {'icon': '🏅', 'text': 'Insignia coleccionable digital'},
    {'icon': '🎁', 'text': 'Recompensa exclusiva con aliados'},
    {'icon': '♾️', 'text': 'Acceso ilimitado por 30 días'},
  ];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _successScale = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _successController, curve: Curves.elasticOut));
    _successFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _successController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  Future<void> _comprar() async {
    if (_comprando || _comprado) return;
    setState(() => _comprando = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    // Guardar ruta comprada en Firestore
    await AuthService.guardarRutaComprada(widget.route['nombre']);

    setState(() {
      _comprando = false;
      _comprado = true;
    });
    _successController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final sitios = widget.route['sitios'] as List<String>;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(context)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _infoChip('${sitios.length}', 'Sitios'),
                        const SizedBox(width: 10),
                        _infoChip(widget.route['duracion'], 'Duración'),
                        const SizedBox(width: 10),
                        _infoChip('⭐ 4.8', 'Rating'),
                        const SizedBox(width: 10),
                        _infoChip(widget.route['dificultad'], 'Nivel'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('RECOMPENSA AL COMPLETAR'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF1A1500), Color(0xFF2A2000)]),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFC9A84C).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC9A84C).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                                child:
                                    Text('🏅', style: TextStyle(fontSize: 22))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(widget.route['premio'],
                                style: const TextStyle(
                                    color: Color(0xFFE8C96A),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('INCLUYE'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF222222)),
                      ),
                      child: Column(
                        children: _incluye.asMap().entries.map((e) {
                          final isLast = e.key == _incluye.length - 1;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              border: isLast
                                  ? null
                                  : const Border(
                                      bottom:
                                          BorderSide(color: Color(0xFF1E1E1E))),
                            ),
                            child: Row(
                              children: [
                                Text(e.value['icon']!,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Text(e.value['text']!,
                                        style: const TextStyle(
                                            color: Color(0xFFF0EDE6),
                                            fontSize: 13))),
                                const Text('✓',
                                    style: TextStyle(
                                        color: Color(0xFF4CAF7C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('MÉTODO DE PAGO'),
                    const SizedBox(height: 10),
                    Row(
                      children: _metodos.asMap().entries.map((e) {
                        final selected = _metodoPago == e.key;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _metodoPago = e.key),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(right: e.key < 2 ? 8 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFC9A84C).withOpacity(0.1)
                                    : const Color(0xFF141414),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: selected
                                        ? const Color(0xFFC9A84C)
                                        : const Color(0xFF222222),
                                    width: selected ? 1.5 : 1),
                              ),
                              child: Column(
                                children: [
                                  Text(e.value['icon']!,
                                      style: const TextStyle(fontSize: 22)),
                                  const SizedBox(height: 4),
                                  Text(e.value['label']!,
                                      style: TextStyle(
                                        color: selected
                                            ? const Color(0xFFE8C96A)
                                            : const Color(0xFF8A8278),
                                        fontSize: 10,
                                        fontWeight: selected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        letterSpacing: 0.5,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0D).withOpacity(0.97),
                border: const Border(top: BorderSide(color: Color(0xFF1E1E1E))),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('PRECIO',
                          style: TextStyle(
                              color: Color(0xFF8A8278),
                              fontSize: 9,
                              letterSpacing: 2)),
                      const SizedBox(height: 2),
                      Text(widget.route['precio'],
                          style: const TextStyle(
                              color: Color(0xFFC9A84C),
                              fontSize: 26,
                              fontWeight: FontWeight.w900)),
                      const Text('COP · Pago único',
                          style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 9,
                              letterSpacing: 0.5)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _comprar,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: _comprado
                              ? const LinearGradient(colors: [
                                  Color(0xFF1A4D2E),
                                  Color(0xFF2D6A4F)
                                ])
                              : const LinearGradient(
                                  colors: [
                                      Color(0xFFC9A84C),
                                      Color(0xFFE8C96A)
                                    ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: (_comprado
                                        ? const Color(0xFF4CAF7C)
                                        : const Color(0xFFC9A84C))
                                    .withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 6))
                          ],
                        ),
                        child: Center(
                          child: _comprando
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF0D0D0D),
                                      strokeWidth: 2.5))
                              : Text(
                                  _comprado
                                      ? '✓ RUTA DESBLOQUEADA'
                                      : 'COMPRAR RUTA',
                                  style: const TextStyle(
                                      color: Color(0xFF0D0D0D),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_comprado)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedBuilder(
                  animation: _successController,
                  builder: (_, __) => FadeTransition(
                    opacity: _successFade,
                    child: Container(
                      color: Colors.black.withOpacity(0.0),
                      child: Align(
                        alignment: const Alignment(0, -0.2),
                        child: ScaleTransition(
                          scale: _successScale,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color:
                                      const Color(0xFF4CAF7C).withOpacity(0.5)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF4CAF7C)
                                        .withOpacity(0.15),
                                    blurRadius: 40,
                                    spreadRadius: 4)
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('✅', style: TextStyle(fontSize: 48)),
                                const SizedBox(height: 12),
                                const Text('¡RUTA COMPRADA!',
                                    style: TextStyle(
                                        color: Color(0xFF4CAF7C),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2)),
                                const SizedBox(height: 8),
                                Text(widget.route['nombre'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color(0xFFF0EDE6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              MapScreen(route: widget.route)),
                                      (r) => r.isFirst,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFFC9A84C),
                                        Color(0xFFE8C96A)
                                      ]),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                        child: Text('IR AL MAPA →',
                                            style: TextStyle(
                                                color: Color(0xFF0D0D0D),
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.5,
                                                fontSize: 14))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF1A2A1A), Color(0xFF2D4A2D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
        Positioned(
            top: 44,
            right: 20,
            child: Text(widget.route['emoji'],
                style: const TextStyle(fontSize: 72))),
        Positioned(
          bottom: 20,
          left: 20,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('RUTA DISPONIBLE',
                  style: TextStyle(
                      color: Color(0xFF8A8278), fontSize: 9, letterSpacing: 2)),
              const SizedBox(height: 4),
              Text(widget.route['nombre'].toString().toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFFF0EDE6),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(widget.route['zona'],
                  style:
                      const TextStyle(color: Color(0xFF8A8278), fontSize: 12)),
            ],
          ),
        ),
        Positioned(
          top: 44,
          left: 16,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.15))),
                child: const Icon(Icons.arrow_back,
                    color: Color(0xFFF0EDE6), size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF222222))),
        child: Column(
          children: [
            Text(val,
                style: const TextStyle(
                    color: Color(0xFFF0EDE6),
                    fontSize: 16,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF8A8278), fontSize: 9, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text,
        style: const TextStyle(
            color: Color(0xFF8A8278),
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold));
  }
}

// ── VALIDACIÓN CON FOTO ───────────────────────────────────────────────────────
enum _ValidationState { idle, capturing, analyzing, success }

class PhotoValidationScreen extends StatefulWidget {
  final String sitio;
  final int numero;

  const PhotoValidationScreen(
      {super.key, required this.sitio, required this.numero});

  @override
  State<PhotoValidationScreen> createState() => _PhotoValidationScreenState();
}

class _PhotoValidationScreenState extends State<PhotoValidationScreen>
    with TickerProviderStateMixin {
  _ValidationState _state = _ValidationState.idle;

  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _successController;
  late AnimationController _cornerController;

  late Animation<double> _scanAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _successScale;
  late Animation<double> _successOpacity;
  late Animation<double> _cornerAnim;

  int _analyzeStep = 0;

  @override
  void initState() {
    super.initState();
    _scanController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _scanAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _successController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _successScale = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _successController, curve: Curves.elasticOut));
    _successOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _successController, curve: Curves.easeIn));
    _cornerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _cornerAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _cornerController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _successController.dispose();
    _cornerController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_state != _ValidationState.idle) return;
    setState(() => _state = _ValidationState.capturing);
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      _state = _ValidationState.analyzing;
      _analyzeStep = 0;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _analyzeStep = 1);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _analyzeStep = 2);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _state = _ValidationState.success);
    _successController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraBackground(),
          if (_state == _ValidationState.capturing)
            Container(color: Colors.white.withOpacity(0.85)),
          if (_state == _ValidationState.idle ||
              _state == _ValidationState.analyzing)
            _buildViewfinder(),
          if (_state == _ValidationState.analyzing) _buildAnalyzingOverlay(),
          if (_state == _ValidationState.success) _buildSuccessOverlay(),
          if (_state != _ValidationState.success)
            Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),
          if (_state != _ValidationState.success)
            Positioned(left: 0, right: 0, bottom: 170, child: _buildSiteInfo()),
          if (_state != _ValidationState.success)
            Positioned(bottom: 0, left: 0, right: 0, child: _buildControls()),
        ],
      ),
    );
  }

  Widget _buildCameraBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF0A1A0A), Color(0xFF141F14), Color(0xFF0D150D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: CustomPaint(painter: _ScenePainter(), size: Size.infinite),
    );
  }

  Widget _buildViewfinder() {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_scanController, _cornerController, _pulseController]),
        builder: (context, _) {
          return SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              children: [
                CustomPaint(
                    size: const Size(260, 260), painter: _GridPainter()),
                ..._buildCorners(),
                if (_state == _ValidationState.idle)
                  Positioned(
                    top: 8 + _scanAnim.value * 244,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          const Color(0xFFC9A84C).withOpacity(0.9),
                          Colors.transparent
                        ]),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 28.0;
    const thickness = 2.5;
    final color = Color.lerp(const Color(0xFFC9A84C).withOpacity(0.4),
        const Color(0xFFC9A84C), _cornerAnim.value)!;
    Widget corner(bool top, bool left) => Positioned(
          top: top ? 0 : null,
          bottom: top ? null : 0,
          left: left ? 0 : null,
          right: left ? null : 0,
          child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                  painter: _CornerPainter(
                      top: top,
                      left: left,
                      color: color,
                      thickness: thickness))),
        );
    return [
      corner(true, true),
      corner(true, false),
      corner(false, true),
      corner(false, false)
    ];
  }

  Widget _buildAnalyzingOverlay() {
    final List<Map<String, dynamic>> chips = [
      {'label': '📍 GPS', 'done': _analyzeStep >= 0 ? true : null},
      {'label': '📷 Foto', 'done': _analyzeStep >= 1 ? true : null},
      {'label': '🏛️ Lugar', 'done': _analyzeStep >= 2 ? true : null},
    ];
    return Container(
      color: Colors.black.withOpacity(0.65),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 80),
            const SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                    color: Color(0xFFC9A84C), strokeWidth: 3)),
            const SizedBox(height: 20),
            const Text('ANALIZANDO FOTO',
                style: TextStyle(
                    color: Color(0xFFC9A84C),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4)),
            const SizedBox(height: 8),
            const Text('Verificando ubicación y lugar…',
                style: TextStyle(
                    color: Color(0xFF8A8278), fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: chips
                  .map((c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _verifyChip(c['label'], c['done'])))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verifyChip(String label, bool? done) {
    final color =
        done == null ? const Color(0xFF555555) : const Color(0xFF4CAF7C);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done == null)
            const SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: Color(0xFF8A8278)))
          else
            Text('✓',
                style: TextStyle(
                    color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(color: color, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return AnimatedBuilder(
      animation: _successController,
      builder: (context, _) => FadeTransition(
        opacity: _successOpacity,
        child: Container(
          color: Colors.black.withOpacity(0.88),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 0, 0),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF333333))),
                      child: const Icon(Icons.arrow_back,
                          color: Color(0xFFF0EDE6), size: 18),
                    ),
                  ),
                ),
                const Spacer(),
                ScaleTransition(
                  scale: _successScale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                          colors: [Color(0xFF1A4D2E), Color(0xFF2D6A4F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      border:
                          Border.all(color: const Color(0xFF4CAF7C), width: 3),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF4CAF7C).withOpacity(0.35),
                            blurRadius: 40,
                            spreadRadius: 8)
                      ],
                    ),
                    child: const Center(
                        child: Text('✓',
                            style: TextStyle(
                                color: Color(0xFF4CAF7C),
                                fontSize: 56,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('¡SITIO VALIDADO!',
                    style: TextStyle(
                        color: Color(0xFF4CAF7C),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4)),
                const SizedBox(height: 8),
                Text(widget.sitio,
                    style: const TextStyle(
                        color: Color(0xFFF0EDE6),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Sitio ${widget.numero} completado · +50 XP',
                    style: const TextStyle(
                        color: Color(0xFF8A8278),
                        fontSize: 12,
                        letterSpacing: 1)),
                const SizedBox(height: 28),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: const Color(0xFF4CAF7C).withOpacity(0.3))),
                  child: Column(
                    children: [
                      _detailRow('📍 Ubicación', 'Verificada · 8m del sitio'),
                      const Divider(color: Color(0xFF222222), height: 20),
                      _detailRow('📷 Foto', 'Reconocida correctamente'),
                      const Divider(color: Color(0xFF222222), height: 20),
                      _detailRow('🕐 Hora', _getTime()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF0A1A0A), Color(0xFF1A2A1A)]),
                    border: Border.all(
                        color: const Color(0xFF4CAF7C).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Text('📸', style: TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.sitio,
                                style: const TextStyle(
                                    color: Color(0xFFF0EDE6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3),
                            const Text('Guardado en tu diario de viaje',
                                style: TextStyle(
                                    color: Color(0xFF8A8278), fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: const Color(0xFF4CAF7C).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('✓',
                            style: TextStyle(
                                color: Color(0xFF4CAF7C), fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFFC9A84C).withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: const Center(
                          child: Text('SIGUIENTE DESTINO →',
                              style: TextStyle(
                                  color: Color(0xFF0D0D0D),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Color(0xFF8A8278), fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: Color(0xFFF0EDE6),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _getTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF333333))),
                child: const Icon(Icons.arrow_back,
                    color: Color(0xFFF0EDE6), size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF333333))),
                child: Row(
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Color(0xFF4CAF7C), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    const Text('GPS ACTIVO',
                        style: TextStyle(
                            color: Color(0xFF4CAF7C),
                            fontSize: 10,
                            letterSpacing: 2)),
                    const Spacer(),
                    const Text('📍 VALIDAR SITIO',
                        style: TextStyle(
                            color: Color(0xFFE8C96A),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSiteInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC9A84C).withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)]),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text('${widget.numero}',
                    style: const TextStyle(
                        color: Color(0xFF0D0D0D),
                        fontSize: 20,
                        fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('FOTOGRAFÍA ESTE LUGAR',
                    style: TextStyle(
                        color: Color(0xFF8A8278),
                        fontSize: 9,
                        letterSpacing: 2)),
                const SizedBox(height: 4),
                Text(widget.sitio,
                    style: const TextStyle(
                        color: Color(0xFFF0EDE6),
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Column(
            children: [
              Text('📍', style: TextStyle(fontSize: 16)),
              SizedBox(height: 2),
              Text('12m',
                  style: TextStyle(
                      color: Color(0xFF4CAF7C),
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final isIdle = _state == _ValidationState.idle;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 44),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.92)]),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            opacity: isIdle ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Text('Encuadra el lugar en el visor y toma la foto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF8A8278),
                      fontSize: 12,
                      letterSpacing: 0.5)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _controlBtn(
                  icon: '🖼️', label: 'Galería', onTap: isIdle ? () {} : null),
              GestureDetector(
                onTap: isIdle ? _takePicture : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                        color: isIdle
                            ? const Color(0xFFC9A84C)
                            : const Color(0xFF555555),
                        width: 4),
                    boxShadow: isIdle
                        ? [
                            BoxShadow(
                                color:
                                    const Color(0xFFC9A84C).withOpacity(0.45),
                                blurRadius: 24,
                                spreadRadius: 6)
                          ]
                        : null,
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isIdle
                            ? const LinearGradient(
                                colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)
                            : const LinearGradient(
                                colors: [Colors.grey, Colors.grey]),
                      ),
                    ),
                  ),
                ),
              ),
              _controlBtn(
                  icon: '🔦', label: 'Flash', onTap: isIdle ? () {} : null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _controlBtn(
      {required String icon, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap != null ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF333333))),
              child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(color: Color(0xFF8A8278), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ── PANTALLA DE RECOMPENSA ────────────────────────────────────────────────────
class RewardScreen extends StatefulWidget {
  final Map<String, dynamic> route;
  const RewardScreen({super.key, required this.route});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with TickerProviderStateMixin {
  late AnimationController _entradaController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _slideController;

  late Animation<double> _badgeScale;
  late Animation<double> _badgeFade;
  late Animation<double> _glow;
  late Animation<double> _slideUp;
  late Animation<double> _particleAnim;

  bool _copiado = false;

  String get _codigoPremio =>
      'RUTERO-${widget.route['zona'].toString().split('·').first.trim().toUpperCase().replaceAll(' ', '').substring(0, min(4, widget.route['zona'].toString().length))}25';
  String get _premio => widget.route['premio'] as String;
  String get _emoji => widget.route['emoji'] as String;
  String get _nombre => widget.route['nombre'] as String;

  @override
  void initState() {
    super.initState();
    _entradaController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _glowController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _badgeScale = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _entradaController, curve: Curves.elasticOut));
    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entradaController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
    _glow = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    _slideUp = Tween<double>(begin: 60.0, end: 0.0).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _particleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _particleController, curve: Curves.linear));

    _entradaController.forward().then((_) => _slideController.forward());
  }

  @override
  void dispose() {
    _entradaController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _copiarCodigo() {
    setState(() => _copiado = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiado = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleAnim,
            builder: (_, __) => CustomPaint(
                painter: _ParticlePainter(progress: _particleAnim.value),
                size: Size.infinite),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 0.9,
                  colors: [
                    Color(0xFF2D1F00),
                    Color(0xFF1A1200),
                    Color(0xFF0D0D0D)
                  ]),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFF333333))),
                          child: const Icon(Icons.arrow_back,
                              color: Color(0xFFF0EDE6), size: 20),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: const Color(0xFFC9A84C).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color(0xFFC9A84C).withOpacity(0.4))),
                        child: const Row(
                          children: [
                            Text('🏆', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 6),
                            Text('PREMIO DESBLOQUEADO',
                                style: TextStyle(
                                    color: Color(0xFFC9A84C),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation:
                        Listenable.merge([_entradaController, _glowController]),
                    builder: (_, __) => Column(
                      children: [
                        const SizedBox(height: 20),
                        FadeTransition(
                            opacity: _badgeFade,
                            child: const Text('¡FELICITACIONES!',
                                style: TextStyle(
                                    color: Color(0xFF8A8278),
                                    fontSize: 11,
                                    letterSpacing: 4))),
                        const SizedBox(height: 20),
                        ScaleTransition(
                          scale: _badgeScale,
                          child: FadeTransition(
                            opacity: _badgeFade,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFC9A84C)
                                            .withOpacity(0.06 * _glow.value))),
                                Container(
                                    width: 155,
                                    height: 155,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFC9A84C)
                                            .withOpacity(0.1 * _glow.value))),
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF2A1F00),
                                          Color(0xFF4A3800)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    border: Border.all(
                                        color: Color.lerp(
                                            const Color(0xFFC9A84C),
                                            const Color(0xFFFFE599),
                                            _glow.value)!,
                                        width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0xFFC9A84C)
                                              .withOpacity(0.4 * _glow.value),
                                          blurRadius: 40,
                                          spreadRadius: 8)
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(_emoji,
                                          style:
                                              const TextStyle(fontSize: 58))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                            opacity: _badgeFade,
                            child: Text(_nombre.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color(0xFFC9A84C),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3))),
                        const SizedBox(height: 6),
                        FadeTransition(
                            opacity: _badgeFade,
                            child: const Text('COMPLETADA · 100%',
                                style: TextStyle(
                                    color: Color(0xFF4CAF7C),
                                    fontSize: 12,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold))),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _slideController,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _slideUp.value),
                    child: FadeTransition(
                        opacity: _slideController,
                        child: _buildRewardPanel(context)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardPanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFC9A84C).withOpacity(0.25))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xFFC9A84C).withOpacity(0.12),
                Colors.transparent
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                  bottom: BorderSide(
                      color: const Color(0xFFC9A84C).withOpacity(0.15))),
            ),
            child: Row(
              children: [
                const Text('🎁', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TU RECOMPENSA',
                          style: TextStyle(
                              color: Color(0xFFC9A84C),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2)),
                      SizedBox(height: 2),
                      Text('Ganada al completar la ruta',
                          style: TextStyle(
                              color: Color(0xFF8A8278), fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4CAF7C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF4CAF7C).withOpacity(0.4))),
                  child: const Text('✓ GANADO',
                      style: TextStyle(
                          color: Color(0xFF4CAF7C),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2A2A2A))),
                  child: Row(
                    children: [
                      const Text('🏅', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(_premio,
                              style: const TextStyle(
                                  color: Color(0xFFF0EDE6),
                                  fontSize: 13,
                                  height: 1.5))),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _copiarCodigo,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _copiado
                          ? const Color(0xFF4CAF7C).withOpacity(0.1)
                          : const Color(0xFF1A1600),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: _copiado
                              ? const Color(0xFF4CAF7C).withOpacity(0.5)
                              : const Color(0xFFC9A84C).withOpacity(0.4)),
                    ),
                    child: Column(
                      children: [
                        Text(
                            _copiado
                                ? 'CÓDIGO COPIADO ✓'
                                : 'TU CÓDIGO DE CANJE',
                            style: TextStyle(
                                color: _copiado
                                    ? const Color(0xFF4CAF7C)
                                    : const Color(0xFF8A8278),
                                fontSize: 10,
                                letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text(_codigoPremio,
                            style: TextStyle(
                                color: _copiado
                                    ? const Color(0xFF4CAF7C)
                                    : const Color(0xFFC9A84C),
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 5)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                _copiado
                                    ? Icons.check_circle_outline
                                    : Icons.copy_outlined,
                                color: _copiado
                                    ? const Color(0xFF4CAF7C)
                                    : const Color(0xFF555555),
                                size: 13),
                            const SizedBox(width: 4),
                            Text(
                                _copiado
                                    ? 'Listo, muéstralo en el establecimiento'
                                    : 'Toca para copiar · Válido 30 días',
                                style: TextStyle(
                                    color: _copiado
                                        ? const Color(0xFF4CAF7C)
                                        : const Color(0xFF555555),
                                    fontSize: 10,
                                    letterSpacing: 0.5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _statChip('⏱', widget.route['duracion']),
                    const SizedBox(width: 8),
                    _statChip('📍',
                        '${(widget.route['sitios'] as List).length} sitios'),
                    const SizedBox(width: 8),
                    _statChip('⭐', '50 XP ganados'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('¡Logro compartido! 🎉'),
                                backgroundColor: Color(0xFF1A4D2E))),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFF333333))),
                          child: const Center(
                              child: Text('🔗 Compartir',
                                  style: TextStyle(
                                      color: Color(0xFFF0EDE6),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFC9A84C).withOpacity(0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6))
                            ],
                          ),
                          child: const Center(
                              child: Text('EXPLORAR MÁS RUTAS →',
                                  style: TextStyle(
                                      color: Color(0xFF0D0D0D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String emoji, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF8A8278), fontSize: 9, letterSpacing: 0.5),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── PAINTERS ──────────────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double progress;
  static final _rnd = Random(99);
  static final List<_Particle> _particles = List.generate(
      35,
      (i) => _Particle(
            x: _rnd.nextDouble(),
            y: _rnd.nextDouble(),
            size: 1.5 + _rnd.nextDouble() * 3,
            speed: 0.1 + _rnd.nextDouble() * 0.3,
            phase: _rnd.nextDouble(),
          ));

  const _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in _particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final y = size.height * (1.0 - t);
      final x = size.width * p.x + sin(t * pi * 2 + p.phase * pi) * 20;
      final opacity = sin(t * pi).clamp(0.0, 1.0) * 0.6;
      paint.color = const Color(0xFFC9A84C).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, size, speed, phase;
  const _Particle(
      {required this.x,
      required this.y,
      required this.size,
      required this.speed,
      required this.phase});
}

class _ScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(7);
    final skyPaint = Paint()
      ..shader = const LinearGradient(
              colors: [Color(0xFF0A120A), Color(0xFF101810)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    final buildingPaint = Paint()..color = const Color(0xFF0D1A0D);
    final builds = [
      Rect.fromLTWH(0, size.height * 0.55, size.width * 0.25, size.height),
      Rect.fromLTWH(
          size.width * 0.2, size.height * 0.45, size.width * 0.18, size.height),
      Rect.fromLTWH(
          size.width * 0.35, size.height * 0.5, size.width * 0.22, size.height),
      Rect.fromLTWH(
          size.width * 0.55, size.height * 0.4, size.width * 0.2, size.height),
      Rect.fromLTWH(size.width * 0.73, size.height * 0.52, size.width * 0.27,
          size.height),
    ];
    for (final r in builds) canvas.drawRect(r, buildingPaint);

    final windowPaint = Paint()
      ..color = const Color(0xFFC9A84C).withOpacity(0.18);
    for (int i = 0; i < 45; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = size.height * 0.45 + rnd.nextDouble() * size.height * 0.4;
      canvas.drawRect(Rect.fromLTWH(x, y, 4, 5), windowPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFC9A84C).withOpacity(0.12)
      ..strokeWidth = 0.5;
    canvas.drawLine(
        Offset(size.width / 3, 0), Offset(size.width / 3, size.height), p);
    canvas.drawLine(Offset(size.width * 2 / 3, 0),
        Offset(size.width * 2 / 3, size.height), p);
    canvas.drawLine(
        Offset(0, size.height / 3), Offset(size.width, size.height / 3), p);
    canvas.drawLine(Offset(0, size.height * 2 / 3),
        Offset(size.width, size.height * 2 / 3), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CornerPainter extends CustomPainter {
  final bool top;
  final bool left;
  final Color color;
  final double thickness;

  const _CornerPainter(
      {required this.top,
      required this.left,
      required this.color,
      required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_CornerPainter old) =>
      old.color != color || old.thickness != thickness;
}
