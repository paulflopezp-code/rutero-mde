import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();
  static final _db = FirebaseFirestore.instance;

  // Cache local para evitar consultas repetidas a Firestore
  static String? _tipoUsuarioCache;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign-In
  static Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) return null;

      final isNew = result.additionalUserInfo?.isNewUser ?? false;
      if (isNew) {
        await _crearPerfilUsuario(user);
        _tipoUsuarioCache = 'pendiente';
      }

      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<void> _crearPerfilUsuario(User user) async {
    await _db.collection('usuarios').doc(user.uid).set({
      'nombre': user.displayName ?? '',
      'email': user.email ?? '',
      'foto': user.photoURL ?? '',
      'tipo': 'pendiente',
      'pais': '',
      'rutasCompradas': [],
      'insignias': [],
      'xp': 0,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> guardarTipoUsuario(String tipo) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    _tipoUsuarioCache = tipo; // Guardar en cache inmediatamente
    await _db.collection('usuarios').doc(uid).update({'tipo': tipo});
  }

  // Verificar onboarding usando cache para evitar llamada a Firestore
  static Future<bool> necesitaOnboarding() async {
    final uid = currentUser?.uid;
    if (uid == null) return false;

    // Si ya tenemos el tipo en cache, usarlo
    if (_tipoUsuarioCache != null) {
      return _tipoUsuarioCache == 'pendiente';
    }

    // Solo consultar Firestore si no hay cache
    try {
      final doc = await _db
          .collection('usuarios')
          .doc(uid)
          .get(const GetOptions(source: Source.cache))
          .timeout(const Duration(seconds: 2));
      final tipo = doc.data()?['tipo'] ?? 'pendiente';
      _tipoUsuarioCache = tipo;
      return tipo == 'pendiente';
    } catch (_) {
      // Si falla cache, intentar servidor con timeout
      try {
        final doc = await _db
            .collection('usuarios')
            .doc(uid)
            .get()
            .timeout(const Duration(seconds: 3));
        final tipo = doc.data()?['tipo'] ?? 'pendiente';
        _tipoUsuarioCache = tipo;
        return tipo == 'pendiente';
      } catch (_) {
        return false; // Si falla todo, asumir que no necesita onboarding
      }
    }
  }

  static Future<void> guardarRutaComprada(String rutaNombre) async {
    final uid = currentUser?.uid;
    if (uid == null) return;
    await _db.collection('usuarios').doc(uid).update({
      'rutasCompradas': FieldValue.arrayUnion([rutaNombre]),
    });
  }

  static Future<List<String>> obtenerRutasCompradas() async {
    final uid = currentUser?.uid;
    if (uid == null) return [];
    try {
      final doc = await _db
          .collection('usuarios')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 3));
      final rutas = doc.data()?['rutasCompradas'] as List<dynamic>? ?? [];
      return rutas.cast<String>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> signOut() async {
    _tipoUsuarioCache = null; // Limpiar cache al cerrar sesión
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
