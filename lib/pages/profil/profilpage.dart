import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pizzaapp/auth/user_provider.dart';
import 'package:pizzaapp/models/suivi_livraison/pizzeria_map.dart';
import 'package:pizzaapp/pages/profil/commandes.dart';
import 'package:pizzaapp/pages/profil/parametres.dart';

class ProfilPage extends StatelessWidget {
  final UserProvider? userProvider;
  final firebase_auth.User? user;

  const ProfilPage({
    super.key,
    required this.userProvider,
    required this.user, required Map userProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('User ID: ${user?.uid}'); // Test afin de voir si je récupère l'ID Authentifié de l'utilisateur
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Stack(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/images/photo/jack.jpg'),
                    ),
                  ),
                  const SizedBox(width: 15, height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: userProvider?.getUserInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
                          }

                          if (snapshot.hasData) {
                            // Récupération ds données utilisateur
                            final userData = snapshot.data!;
                            final nom = userData['nom'];
                            final prenom = userData['prenom'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$nom $prenom', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255))),
                              ],
                            );
                          } else {
                            return const Text('Erreur données utilisateur');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // Engrenage des paramèttres
              Positioned(
                right: 0,
                top: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParametrePage(user: null,),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 70,
        color: Colors.black,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Ma carte client "QRcode"
            const Card(
              elevation: 5,
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Icon(Icons.qr_code, size: 100, color: Colors.black),
                  SizedBox(height: 5),
                  Text('Ma carte', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                ],
              ),
            ),

            // Liste d'éléments avec icônes
            ListTile(
              leading: const Icon(Icons.rocket, color: Colors.white),
              title: const Text('Vos commandes', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                // Lien vers l'écran des commandes éffectués
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserOrdersPage(user: user),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Paramètres', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParametrePage(user: null,),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Color.fromARGB(255, 255, 255, 255)),
              title: const Text('Centre d\'aide', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                // Afficher le centre d'aide
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel, color: Colors.white),
              title: const Text('Mentions légales', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                // Afficher les mentions légales
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.white),
              title: const Text('Nous situer', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                Navigator.push(
                context,
                  MaterialPageRoute(
                  builder: (context) => PizzeriaMap(user: user),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

  // Méthode pour récupérer tous les utilisateurs
  Future<void> getAllUsers() async {
    try {
      // Récupères tous les utilisateurs de la collection "users"
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> usersData = querySnapshot.docs.map((doc) => doc.data()).toList();

        if (kDebugMode) {
          // Affiche les dztails de chaque utilisateur
          for (var userData in usersData) {
            print(
                'utilisateur: prenom: ${userData['prenom']} nom: ${userData['nom']} adresse: ${userData['adresse']} uid: ${userData['uid']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Aucun utilisateur trouvé dans la collection "utilisateurs".');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des utilisateurs: $e');
      }
    }
  }
