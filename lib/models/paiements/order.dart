import 'package:pizzaapp/models/paiements/cart.dart';

class Order {
  final String orderNumber;
  final List<CartItem> items;
  final double totalCost;
  final DateTime orderDate;

  Order({
    required this.orderNumber,
    required this.items,
    required this.totalCost,
    required this.orderDate,
  });
}

