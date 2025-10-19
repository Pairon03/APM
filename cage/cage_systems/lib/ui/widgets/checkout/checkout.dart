import 'package:flutter/material.dart';
import '../carrinho/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool descontoPix = false;

  @override
  Widget build(BuildContext context) {
    // Calcula total do carrinho
    int totalCarrinho = widget.cart.fold(0, (sum, item) => sum + item.total);
    int totalFinal = descontoPix ? (totalCarrinho * 0.9).toInt() : totalCarrinho;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final item = widget.cart[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item.destino, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Diárias: ${item.nDiarias}  Pessoas: ${item.nPessoas}"),
                      trailing: Text("R\$ ${item.total}"),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "R\$ $totalFinal",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: widget.cart.isEmpty
                      ? null
                      : () {
                          setState(() {
                            descontoPix = true; // aplica 10% de desconto
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Pix aplicado: R\$ $totalFinal")),
                          );
                        },
                  child: const Text("Pix (10% off)"),
                ),
                ElevatedButton(
                  onPressed: widget.cart.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Cartão: R\$ $totalFinal")),
                          );
                        },
                  child: const Text("Cartão"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: widget.cart.isEmpty
                    ? null
                    : () {
                        setState(() {
                          widget.cart.clear();
                          descontoPix = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Carrinho limpo!")),
                        );
                      },
                child: const Text("Limpar Carrinho"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
