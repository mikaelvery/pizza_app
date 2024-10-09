import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzaapp/pages/connexion/homepage.dart';

class ParametrePage extends StatelessWidget {
  final User? user;

  const ParametrePage({super.key, required this.user,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/photo/jack.jpg'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 18, 106, 9), backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text('MODIFIER LE COMPTE'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Déconnexion de l'utilisateur
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 176, 23, 23),
                ),
                child: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Affiche les informations des utilisateurs
              FutureBuilder<DocumentSnapshot>(
                future: user != null ? FirebaseFirestore.instance.collection('users').doc(user?.uid).get() : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('Hello Mikael very', style: TextStyle(color: Colors.white));
                  }
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  var lastLogin = userData['lastLogin'] ?? 'Jamais';
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 7),
                          ),
                          child: const CircleAvatar(
                            radius: 120,
                            backgroundImage: AssetImage('assets/images/photo/jack.jpg'),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Utilisateur: ${user?.displayName ?? 'Utilisateur inconnu'}',
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dernière connexion: $lastLogin',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
