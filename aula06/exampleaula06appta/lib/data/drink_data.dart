import 'package:flutter/material.dart';
import '../model/drink.dart';

class DrinkData extends ChangeNotifier {
  final List<Drink> _drinks = [
    Drink(name: "Coca-Cola Lata", image: "assets/drinks/coca.png", price: 5.0),
    Drink(name: "Guaraná Antártica", image: "assets/drinks/guarana.png", price: 4.5),
    Drink(name: "Suco de Laranja", image: "assets/drinks/suco.png", price: 6.0),
  ];

  List<Drink> get drinks => _drinks;
}
