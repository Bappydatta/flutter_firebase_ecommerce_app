import 'package:firebase_auth/firebase_auth.dart';
import '../config/admin_config.dart';

bool isAdmin() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null && user.email == adminEmail;
}