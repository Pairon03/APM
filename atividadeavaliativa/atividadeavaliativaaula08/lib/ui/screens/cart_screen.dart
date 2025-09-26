import 'package:flutter/material.dart';
import '../widgets/carrinho/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int get total => widget.cart.fold(0, (sum, item) => sum + item.total);

  void limparCarrinho() {
    setState(() {
      widget.cart.clear();
    });
  }

  void pagarPix() {
    final desconto = (total * 0.9).toInt();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pagamento via Pix: R\$ $desconto")),
    );
    limparCarrinho();
  }

  void pagarCartao() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pagamento via Cartão: R\$ $total")),
    );
    limparCarrinho();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Carrinho"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: widget.cart.isEmpty
                  ? const Center(child: Text("Carrinho vazio"))
                  : ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final item = widget.cart[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(item.destino),
                            subtitle: Text(
                                "Diárias: ${item.nDiarias} - Pessoas: ${item.nPessoas}"),
                            trailing: Text("R\$ ${item.total}"),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Text("Total: R\$ $total",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: pagarPix, child: const Text("Pix (10% off)")),
                ElevatedButton(onPressed: pagarCartao, child: const Text("Cartão")),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: limparCarrinho,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Limpar Carrinho")),
          ],
        ),
      ),
    );
  }
}
