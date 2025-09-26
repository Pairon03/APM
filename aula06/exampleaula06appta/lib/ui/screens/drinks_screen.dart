import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/drink_data.dart';
import '../../../data/cart_data.dart';
import '../../../model/drink.dart';

class DrinksScreen extends StatelessWidget {
  const DrinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drinks = Provider.of<DrinkData>(context).drinks;
    final cart = Provider.of<CartData>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Bebidas")),
      body: ListView.builder(
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          Drink drink = drinks[index];
          return ListTile(
            leading: Image.asset(drink.image, width: 40),
            title: Text(drink.name),
            subtitle: Text("R\$ ${drink.price.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                cart.addToCart(drink);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${drink.name} adicionado na sacola")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
