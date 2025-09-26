import 'package:flutter/material.dart';
import '../model/drink.dart';

class CartData extends ChangeNotifier {
  final List<Drink> _cart = [];

  List<Drink> get cart => _cart;

  void addToCart(Drink drink) {
    _cart.add(drink);
    notifyListeners();
  }

  void removeFromCart(Drink drink) {
    _cart.remove(drink);
    notifyListeners();
  }
}
