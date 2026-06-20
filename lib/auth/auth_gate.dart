import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/auth/login_view.dart';
import '../views/main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation(); // ✅ LOGGED IN
        }

        return const LoginView(); // ❌ NOT LOGGED IN
      },
    );
  }
}
