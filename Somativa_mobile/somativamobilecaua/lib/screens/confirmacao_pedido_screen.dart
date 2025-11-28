import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somativamobilecaua/providers/bag_provider.dart';

class ConfirmacaoPedidoScreen extends StatelessWidget {
  const ConfirmacaoPedidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o BagProvider para obter os dados do pedido e endereço
    final bagProvider = Provider.of<BagProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação do Pedido'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mensagem de Confirmação
            const Text(
              '✅ Seu pedido foi recebido com sucesso!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // 2. Detalhes do Endereço de Entrega (Requisito E)
            const Text(
              'Endereço de Entrega:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                bagProvider.enderecoEntrega, // Endereço obtido via Via CEP 
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            // 3. Resumo dos Totais (Requisito E)
            const Text(
              'Resumo da Compra:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildSummaryRow('Subtotal dos Itens:', bagProvider.subTotal, Colors.black),
            _buildSummaryRow('Taxa de Entrega:', bagProvider.taxaEntrega, bagProvider.taxaEntrega == 0.0 ? Colors.green : Colors.red),
            const Divider(thickness: 1.5, height: 20),
            _buildSummaryRow('TOTAL GERAL:', bagProvider.totalGeral, Colors.red, isTotal: true),

            const SizedBox(height: 40),

            // 4. Botão Finalizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Limpa o carrinho e volta para a tela inicial (Cardápio ou Login)
                  bagProvider.clearBag();
                  // Usa pushAndRemoveUntil para limpar a pilha de navegação
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', // Rota que deve levar ao Cardápio ou Login
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text('VOLTAR PARA O CARDÁPIO', style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget auxiliar para construir as linhas de resumo
  Widget _buildSummaryRow(String label, double value, Color valueColor, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTotal ? 0 : 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 20 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(fontSize: isTotal ? 20 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}