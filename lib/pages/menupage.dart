import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pizzaapp/models/pizza/pizze.dart';
import 'package:pizzaapp/models/paiements/cart.dart';

List<CartItem> cartItems = []; // Panier d'achat

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'Menu des pizzas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: pizzeList.length,
          itemBuilder: (context, index) {
            return PizzeCard(pizze: pizzeList[index]);
          },
        ),
      ),
    );
  }
}

class PizzeCard extends StatefulWidget {
  final Pizze pizze;
  const PizzeCard({super.key, required this.pizze});

  @override
  PizzeCardState createState() => PizzeCardState();
}

// Class pour la création de card
class PizzeCardState extends State<PizzeCard> {
  int quantity = 1; // Quantité évalué à 1 pour l'achat d'au moins 1 pizza
  List<String> selectedIngredients = []; // Suppléments d'ingrédients

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _showDetailsCard(context); // Apelle la methode des détails de la pizza cliqué
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.pizze.image,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pizze.name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 163, 0, 0)),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.pizze.isPizzaRose == true
                    ? 'Pizza Rose'
                    : 'Pizza Bianchi',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                const SizedBox(height: 10),
                if ((widget.pizze.description.length) <= 50)
                  Text(
                    widget.pizze.description,
                    style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                if ((widget.pizze.description.length) > 50)
                  Text(
                    '${widget.pizze.description.substring(0, 53)}...',
                    style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                const SizedBox(height: 10),
                Text(
                  'Prix: ${widget.pizze.prices.join(', ')}€',
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Text(
                  'Taille ${widget.pizze.sizes.join(', ')}',
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),

                // quantité de pizzas a commander
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                              }
                            });
                          },
                        ),
                        Text(
                          'Quantité: $quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 19, 156, 6)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),

                    // Ajout d'ingrédients supplémentaire
                    if (widget.pizze.addIngredients.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            items: widget.pizze.addIngredients
                              .map((ingredient) => DropdownMenuItem<String>(
                                  value: ingredient,
                                  child: Text(ingredient),
                                ))
                              .toList(),
                            onChanged: (String? selectedIngredient) {
                              setState(() {
                                // Gestion de la sélection d'ingrédient
                                if (selectedIngredient != null) {
                                  selectedIngredients.add(selectedIngredient);
                                }
                              });
                            },
                            hint: const Text(
                              'supplément',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    addToCart(widget.pizze, quantity, selectedIngredients);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 31, 158, 27), // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5, 
                  ),
                  child: const Text(
                    'Ajouter au panier',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(Pizze pizze, int quantity, List<String> selectedIngredients) {
    if (kDebugMode) {
    print(
      'Ajouté au panier: ${pizze.name} x $quantity avec un suppléments : $selectedIngredients');
    }
    // Ajouter pizzas au panier
    CartItem cartItem = CartItem(
      pizze: pizze,
      quantity: quantity,
      selectedIngredients: selectedIngredients, selectedAddress: '', selectedCoordinates: [],
    );
    cartItems.add(cartItem);
  }
  
  Future<void> _showDetailsCard(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.pizze.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(
                  widget.pizze.image,
                  width: 200,
                  height: 350,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.pizze.description,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
