import 'package:flutter/material.dart';
import '../widgets/carrinho/cart_item.dart';

class Destino extends StatefulWidget {
  final String nome;
  final String imagem;
  final int valord;
  final int valorp;
  final List<CartItem> cart;

  const Destino({
    super.key,
    required this.nome,
    required this.imagem,
    required this.valord,
    required this.valorp,
    required this.cart,
  });

  @override
  State<Destino> createState() => _DestinoState();
}

class _DestinoState extends State<Destino> {
  int nDiarias = 0;
  int nPessoas = 0;
  int total = 0;

  void dias() {
    setState(() {
      nDiarias++;
    });
  }

  void nPessoasAdd() {
    setState(() {
      nPessoas++;
    });
  }

  void adicionarCarrinho() {
    if (nDiarias == 0 || nPessoas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione pelo menos 1 dia e 1 pessoa")),
      );
      return;
    }

    setState(() {
      total = (nDiarias * widget.valord) + (nPessoas * widget.valorp);
      widget.cart.add(
        CartItem(
          destino: widget.nome,
          nDiarias: nDiarias,
          nPessoas: nPessoas,
          total: total,
        ),
      );

      // Reseta as seleções do destino
      nDiarias = 0;
      nPessoas = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Destino adicionado ao carrinho!")),
    );
  }

  void limparSelecao() {
    setState(() {
      nDiarias = 0;
      nPessoas = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.nome,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  minHeight: 150,
                ),
                child: Image.asset(
                  widget.imagem,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text("Diária: R\$${widget.valord} - Pessoa: R\$${widget.valorp}"),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: dias, icon: const Icon(Icons.add)),
                  Text("Dias: $nDiarias"),
                  IconButton(
                    onPressed: nPessoasAdd,
                    icon: const Icon(Icons.person_add),
                  ),
                  Text("Pessoas: $nPessoas"),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: adicionarCarrinho,
                      child: const Text("Adicionar ao Carrinho"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: limparSelecao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Limpar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
