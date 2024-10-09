import 'package:pizzaapp/models/pizza/pizze.dart';

class CartItem {
  final Pizze pizze;
  final int quantity;
  final List<String> selectedIngredients;
  final String selectedAddress; 
  final List<double> selectedCoordinates; 

  CartItem({
    required this.pizze,
    required this.quantity,
    List<String>? selectedIngredients,
    required this.selectedAddress,
    required this.selectedCoordinates,
  }) : selectedIngredients = selectedIngredients ?? [];

  // Calcule du prix total du PANIER
  double get totalPrice {
    double pizzePrice = 0.0;
    if (pizze.prices.isNotEmpty) {
      pizzePrice = pizze.prices[0];
    }
    double ingredientsPrice =
        selectedIngredients.length * (pizze.addIngredientsPrices);
    return (pizzePrice + ingredientsPrice) * quantity;
  }
}
