import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'authprovider.dart';

class UserProvider extends ChangeNotifier {
  // Instance de l'authentification
  final AuthProvider _authProvider;
 
  UserProvider(this._authProvider);
  firebase_auth.User? get user => _authProvider.user;

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      // Récupération de l'utilisateur authentifié
      firebase_auth.User? currentUser = _authProvider.user;

      if (currentUser != null) {    
        String userId = currentUser.uid; // Récupération de l'UID de utilisateur
        // Récupération du document utilisateur via le Cloud
        var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists) {
          // Si le document utilisateur existeje récupère ses données
          var userData = userDoc.data() ?? {};

          if (kDebugMode) {
            print('Data getUserInfo: $userData');
            print('ID getUserInfo: $userId');
          }
          return userData;

        } else {
          if (kDebugMode) {
            print('Aucun document utilisateur trouvé pour l\'UID: $userId');
          }
          return {};
        }
      } else {
        if (kDebugMode) {
          print('Utilisateur null');
        }
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des informations utilisateur: $e');
      }
      return {};
    }
  }
}
