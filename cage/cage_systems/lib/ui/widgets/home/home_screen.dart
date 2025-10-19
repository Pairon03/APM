import 'package:flutter/material.dart';
import 'package:atividadeavaliativaaula08/ui/screens/destino.dart';
import '../carrinho/cart_item.dart';
import 'package:atividadeavaliativaaula08/ui/screens/cart_screen.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<CartItem> cart = [];

  final List<Map<String, dynamic>> destinos = [
    {"nome": "Angra dos Reis", "imagem": "assets/imagens/angra.jpg", "valord": 384, "valorp": 70},
    {"nome": "Jericoacoara", "imagem": "assets/imagens/jeri.jpg", "valord": 571, "valorp": 75},
    {"nome": "Arraial do Cabo", "imagem": "assets/imagens/arraial.jpg", "valord": 534, "valorp": 65},
    {"nome": "Florianópolis", "imagem": "assets/imagens/floripa.jpg", "valord": 348, "valorp": 85},
    {"nome": "Madri", "imagem": "assets/imagens/madri.jpg", "valord": 401, "valorp": 85},
    {"nome": "Paris", "imagem": "assets/imagens/paris.jpg", "valord": 546, "valorp": 95},
    {"nome": "Orlando", "imagem": "assets/imagens/orlando.jpg", "valord": 616, "valorp": 105},
    {"nome": "Las Vegas", "imagem": "assets/imagens/vegas.jpg", "valord": 504, "valorp": 110},
    {"nome": "Roma", "imagem": "assets/imagens/roma.jpg", "valord": 478, "valorp": 85},
    {"nome": "Chile", "imagem": "assets/imagens/chile.jpg", "valord": 446, "valorp": 95},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("S&M Hotel"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards por linha
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2, // altura proporcional ao conteúdo
          ),
          itemCount: destinos.length,
          itemBuilder: (context, index) {
            final destino = destinos[index];
            return Destino(
              nome: destino["nome"],
              imagem: destino["imagem"],
              valord: destino["valord"],
              valorp: destino["valorp"],
              cart: cart,
            );
          },
        ),
      ),
    );
  }
}