import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pizzaapp/models/paiements/cart.dart';
import 'package:firebase_auth/firebase_auth.dart' as authprovider;
import 'package:pizzaapp/auth/user_provider.dart';
import 'package:provider/provider.dart';

LatLng userDeliveryLocation =
    const LatLng(43.656693, 3.935781); // Coordonnées de livraison

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems; // List de mon panier

  const CartPage(
      {super.key, required this.cartItems}); // Construct prend une list D'items
  // Méthode pour créerr l'état de la page
  @override
  CartPageState createState() => CartPageState();
}

// Définie l'état de la Class de CartPage
class CartPageState extends State<CartPage> {
  double totalCost = 0;
  // Clé qui permet d'intéragir avec le formulaire de paiement
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(
        context); // Récupération de Userprovider via le provider
    final user = userProvider.user; // User authentifié

    // Calculate du coup total du pania
    for (CartItem cartItem in widget.cartItems) {
      totalCost += cartItem.totalPrice;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Panier',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                CartItem cartItem = widget.cartItems[index];
                // Nom de la pizza
                return ListTile(
                  title: Text(
                    cartItem.pizze.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Détail des pizzas " quantité, suppléments"
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantité: ${cartItem.quantity}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (cartItem.selectedIngredients.isNotEmpty)
                        Text(
                          'Suppléments: ${cartItem.selectedIngredients.join(", ")}',
                          style: const TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                  // Prix totall de la pizza et bouton de suppression
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${cartItem.totalPrice.toStringAsFixed(2)} €',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 34, 174, 48),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.cartItems.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Cout total / formulaire de paiement
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${totalCost.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showCreditCardForm(user);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(255, 32, 197, 34),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Payer'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // CreditCardForm(
                //   formKey: formKey,
                //   onCreditCardModelChange: (CreditCardModel data) {},
                //   obscureCvv: true,
                //   obscureNumber: true,
                //   isHolderNameVisible: true,
                //   isCardNumberVisible: true,
                //   isExpiryDateVisible: true,
                //   enableCvv: true,
                //   cvvValidationMessage: 'Veuillez entrer un CVV valide',
                //   dateValidationMessage: 'Veuillez entrer une date valide',
                //   numberValidationMessage: 'Veuillez entrer un numéro valide',
                //   cardHolderValidator: (String? cardHolderName) {
                //     return null;
                //   },
                //   cvvValidator: (String? cvv) {
                //     return null;
                //   },
                //   cardNumberValidator: (String? cardNumber) {
                //     return null;
                //   },
                //   expiryDateValidator: (String? expiryDate) {
                //     return null;
                //   },
                //   onFormComplete: () {
                //     if (formKey.currentState!.validate()) {
                //       placeOrder(user);
                //     }
                //   },
                //   cardNumber: '4978 9430 9804 7925 6301',
                //   expiryDate: '11/25',
                //   cardHolderName: 'Mr very mikael',
                //   cvvCode: '123',
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCreditCardForm(authprovider.User? user) {
    // Affiche une boite de comfirmation de commande
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation de la commande'),
          content: const Text('Voulez vous valider votre commande ?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // Display la méthode duu formulaire de paiement
                bool success = await showCreditCardEntryForm(user);
                if (success) {
                  // Affiche la page de suivi de livraison lors de la confirmation
                  // ignore: use_build_context_synchronously
                  // Navigator.push(
                  //     // context,
                  //     // MaterialPageRoute(
                  //     //   builder: (context) => DeliveryTrackingPage(deliveryLocation: userDeliveryLocation),
                  //     // ),
                  // );
                  // Ajoute la commande de l'utilisateur dans ces commandes
                  addOrderForUser(user?.uid ?? "", totalCost, widget.cartItems);
                  // Init le panier pour le vider
                  setState(() {
                    widget.cartItems.clear();
                  });
                }
              },
              child: const Text('Valider'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  // Méthode qui gère l'affichage du formulaire de paiement
  Future<bool> showCreditCardEntryForm(authprovider.User? user) async {
    return formKey.currentState!.validate();
  }

  // Méthode qui permet de passer une commande
  void placeOrder(authprovider.User? user) {
    showCreditCardForm(user); // display le formulaire
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         DeliveryTrackingPage(deliveryLocation: userDeliveryLocation),
    //   ),
    // );
  } // Appel ligne "181"

  // Méthode pour ajouter la commande a la l'utilisateur / Et appel de la méthode de la pizzeria//
  void addOrderForUser(
      String userId, double amount, List<CartItem> cartItems) async {
    try {
      // Créer la liste des pizzas pour la commande
      List<Map<String, dynamic>> pizzasData = cartItems.map((cartItem) {
        return {
          'pizzaName': cartItem.pizze.name,
          'quantity': cartItem.quantity,
          'selectedIngredients': cartItem.selectedIngredients,
        };
      }).toList();

      // Génère un ID unique pour la commande
      String orderId = FirebaseFirestore.instance.collection('orders').doc().id;

      // Ajoute la commande à la collection "orders"
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'userId': userId,
        'amount': amount,
        'pizzas': pizzasData,
        'pizzeriaId': 'Ln5g94LnWG0zvvUfNhc6',
        'orderNumber': orderId,
      });

      // Ajoute la même commande à la sous-collection "orders" de l'utilisateur
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .set({
        'amount': amount,
        'pizzas': pizzasData,
        'orderNumber': orderId,
      });

      // Ajoute la commande à la sous collection "orders" de la pizzeria
      addOrderForPizzeria(
          amount, cartItems, 'Ln5g94LnWG0zvvUfNhc6', orderId, userId);

      if (kDebugMode) {
        print('ID de la commande ajoutée: $orderId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Désolé, la commande n\'a pas pu être effectuée ! $e');
      }
    }
  }

// Méthode pour ajouter la commande à la pizzeria
  void addOrderForPizzeria(double amount, List<CartItem> cartItems,
      String pizzeriaId, String orderId, String userId) async {
    try {
      // Récupère les détails de l'utilisateur depuis la collection "users"
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Récupère les détails de la commande depuis la collection "orders"
        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .get();
        if (orderSnapshot.exists) {
          Map<String, dynamic> orderData =
              orderSnapshot.data() as Map<String, dynamic>;

          // Créer la List des pizzas pour la commande
          List<Map<String, dynamic>> pizzasData = cartItems.map((cartItem) {
            return {
              'pizzaName': cartItem.pizze.name,
              'quantity': cartItem.quantity,
              'selectedIngredients': cartItem.selectedIngredients,
            };
          }).toList();

          // Ajoute la commande a la sous collection "orders" de la pizzeria
          await FirebaseFirestore.instance
              .collection('pizzeria')
              .doc(pizzeriaId)
              .collection('orders')
              .doc(orderId)
              .set({
            'amount': amount,
            'userId': userId,
            'userDetails': userData,
            'orderDetails': orderData,
            'orderNumber': orderId,
            'pizzas': pizzasData,
          });

          if (kDebugMode) {
            print(
                'ID de la commande transmise à la pizzeria pour l\'utilisateur $userId avec le numéro $orderId');
          }
        } else {
          if (kDebugMode) {
            print(
                'La commande avec l\'ID $orderId n\'existe pas dans la collection "orders".');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              'L\'tilisateur avec l\'ID $userId n\'existe pas dans la collection "users".');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'Désolé la commande n\'a pas pu être transmise à la pizzeria ! : $e');
      }
    }
  }
}
