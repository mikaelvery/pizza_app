import 'package:flutter/material.dart';
import 'package:pizzaapp/models/pizza/pizza_scroll.dart';

 Future<void> showPizzaDetails(BuildContext context, Pizza pizza) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(pizza.name),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Image.asset(
                pizza.image,
                width: 200,
                height: 350,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                pizza.description,
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

