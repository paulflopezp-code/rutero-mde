import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _cargando = false;

  Future<void> _loginGoogle() async {
    setState(() => _cargando = true);
    final user = await AuthService.signInWithGoogle();
    if (!mounted) return;
    setState(() => _cargando = false);

    if (user != null) {
      try {
        final necesita = await AuthService.necesitaOnboarding();
        if (!mounted) return;
        if (necesita) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      setState(() => _cargando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión. Intenta de nuevo.'),
          backgroundColor: Color(0xFF2A1A1A),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              Container(
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
              const SizedBox(height: 24),
              const Text(
                'RUTERO MDE',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF0EDE6),
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Descubre Medellín a tu ritmo',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A8278),
                  letterSpacing: 2,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(flex: 2),
              // Botón Google
              _cargando
                  ? const CircularProgressIndicator(
                      color: Color(0xFFC9A84C),
                    )
                  : GestureDetector(
                      onTap: _loginGoogle,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Continuar con Google',
                              style: TextStyle(
                                color: Color(0xFF0D0D0D),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              const Text(
                'Al continuar aceptas nuestros términos de uso',
                style: TextStyle(color: Color(0xFF555555), fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── ONBOARDING ────────────────────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? _seleccion;
  bool _guardando = false;

  Future<void> _continuar() async {
    if (_seleccion == null) return;
    setState(() => _guardando = true);
    try {
      await AuthService.guardarTipoUsuario(_seleccion!);
    } catch (e) {
      // continuar aunque falle Firestore
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('👋', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 16),
              const Text(
                '¿Cómo quieres\nexplorar Medellín?',
                style: TextStyle(
                  color: Color(0xFFF0EDE6),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esto nos ayuda a mostrarte el precio correcto',
                style: TextStyle(color: Color(0xFF8A8278), fontSize: 13),
              ),
              const SizedBox(height: 40),
              _opcionCard(
                tipo: 'local',
                emoji: '🏠',
                titulo: 'Soy de Medellín o Colombia',
                subtitulo: 'Precios en pesos colombianos',
              ),
              const SizedBox(height: 16),
              _opcionCard(
                tipo: 'extranjero',
                emoji: '✈️',
                titulo: 'Soy turista extranjero',
                subtitulo: 'Precios en dólares USD',
              ),
              const Spacer(),
              GestureDetector(
                onTap: _seleccion != null ? _continuar : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: _seleccion != null
                        ? const LinearGradient(
                            colors: [Color(0xFFC9A84C), Color(0xFFE8C96A)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF2A2A2A), Color(0xFF2A2A2A)],
                          ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: _guardando
                        ? const CircularProgressIndicator(
                            color: Color(0xFF0D0D0D),
                          )
                        : Text(
                            'Comenzar a explorar →',
                            style: TextStyle(
                              color: _seleccion != null
                                  ? const Color(0xFF0D0D0D)
                                  : const Color(0xFF555555),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opcionCard({
    required String tipo,
    required String emoji,
    required String titulo,
    required String subtitulo,
  }) {
    final selected = _seleccion == tipo;
    return GestureDetector(
      onTap: () => setState(() => _seleccion = tipo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFC9A84C).withOpacity(0.1)
              : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFC9A84C) : const Color(0xFF2A2A2A),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFFE8C96A)
                          : const Color(0xFFF0EDE6),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: Color(0xFF8A8278),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Text(
                '✓',
                style: TextStyle(
                  color: Color(0xFFC9A84C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
