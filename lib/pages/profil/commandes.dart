import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

  class CustomCard extends StatelessWidget {
    final Widget child;

    const CustomCard({super.key, required this.child});

    @override
    Widget build(BuildContext context) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: child,
      );
    }
  }

class UserOrdersPage extends StatelessWidget {
  final User? user;

  const UserOrdersPage({super.key, required this.user});

  Future<void> getOrderByOrderNumber(String orderNumber) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user?.uid)
          .where('orderNumber', isEqualTo: orderNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = querySnapshot.docs.first.data();

        final amount = data['amount'] ?? 0;
        final orderNumber = data['orderNumber'];
        final userId = data['userId'];

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>? ?? {};
          final userName = '${userData['prenom']} ${userData['nom']}';

          if (kDebugMode) {
            print('Détails de la commande: Montant - $amount€, Numéro de commande - $orderNumber');
            print('Utilisateur associé: $userName');
          }
        } else {
          if (kDebugMode) {
            print('Aucune commande trouvée avec le numéro $orderNumber');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération de la commande: $e');
      }
    }
  }

  Future<void> deleteOrder(String orderNumber) async {
    try {
      // Supprime la commande de la base de données
      await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user?.uid)
          .where('orderNumber', isEqualTo: orderNumber)
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression de la commande: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos commandes'),
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return const Center(
              child: Text('Vous n\'avez pas encore passé de commandes.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data?.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>? ?? {};

              if (data.containsKey('amount')) {
                final amount = data['amount'] ?? 0;
                final orderNumber = data['orderNumber'];
                return CustomCard(
                  child: ListTile(
                    title: Text(
                      'Montant de la commande: $amount €',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 187, 20, 20), // Couleur du texte
                      ),
                    ),
                    subtitle: Text(
                      'Numéro de commande: $orderNumber',
                      style: const TextStyle(
                        fontSize: 15, // Taille de police
                        color: Color.fromARGB(255, 0, 0, 0), // Couleur du texte
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 54, 196, 25)),
                      onPressed: () {
                        // Appel de la fonction pour supprimer la commande
                        deleteOrder(orderNumber);
                      },
                    ),
                    onTap: () {
                      // Appel de la fonction pour récupérer la commande par son numéro
                      getOrderByOrderNumber(orderNumber);
                    },
                  ),
                );
              } else {
                return const CustomCard(
                  child: ListTile(
                    title: Text(
                      'Commande sans montant spécifié',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                );
              }
            }).toList() ?? [],
          );
        },
      ),
    );
  }
}