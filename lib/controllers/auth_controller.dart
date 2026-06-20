import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Get current user
  User? get currentUser => _auth.currentUser;

  // 🔹 Login
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // 🔹 Signup
  Future<User?> signup({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔹 Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // 🔹 Auth state stream
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
