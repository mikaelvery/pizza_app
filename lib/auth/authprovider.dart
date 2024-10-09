import 'package:flutter/foundation.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class AuthProvider with ChangeNotifier {
  final firebaseAuth.FirebaseAuth auth = firebaseAuth.FirebaseAuth.instance;
  firebaseAuth.User? _user;

  AuthProvider() {
    auth.authStateChanges().listen((firebaseAuth.User? user) {
      _user = user;
      notifyListeners();
    });
  }

  firebaseAuth.User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('Utilisateur connecté: ${user?.uid}❤️');
      }
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur d\'authentification: $e');
      }
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur d\'inscription: $e');
      }
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      if (kDebugMode) {
        print('Déconnexion réussie.');
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la déconnexion: $e');
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de réinitialisation du mot de passe: $e');
      }
    }
  }
}
