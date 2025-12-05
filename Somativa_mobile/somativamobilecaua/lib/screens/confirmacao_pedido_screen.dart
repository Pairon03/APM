import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somativamobilecaua/providers/bag_provider.dart';
import 'package:somativamobilecaua/screens/cardapio_screen.dart'; // Importa o Cardapio

class ConfirmacaoPedidoScreen extends StatelessWidget {
  const ConfirmacaoPedidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o BagProvider para obter os dados do pedido e endereço
    final bagProvider = Provider.of<BagProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Confirmado!'), // Título atualizado
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false, // Remove a seta de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0), // Aumenta o padding para mais espaço
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mensagem de Confirmação (Estilo UX com ícone maior)
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 36),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'Pedido Recebido com Sucesso!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Detalhes do Endereço de Entrega (Requisito E)
            const Text(
              'Seu Pedido será Entregue em:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                bagProvider.enderecoEntrega, 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),

            // 3. Resumo dos Totais (Requisito E)
            const Text(
              'Detalhes da Transação:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildSummaryRow('Subtotal dos Itens:', bagProvider.subTotal, Colors.black),
            _buildSummaryRow('Taxa de Entrega:', bagProvider.taxaEntrega, bagProvider.taxaEntrega == 0.0 ? Colors.green : Colors.red),
            const Divider(thickness: 1.5, height: 25),
            _buildSummaryRow('TOTAL GERAL:', bagProvider.totalGeral, Colors.red, isTotal: true),

            const SizedBox(height: 60),

            // 4. Botão Finalizar (CORREÇÃO DE NAVEGAÇÃO APLICADA)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Limpa o carrinho
                  bagProvider.clearBag();
                  
                  // CORREÇÃO: Volta DIRETAMENTE para o Cardápio, mantendo o usuário logado
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const CardapioScreen()),
                    (Route<dynamic> route) => false, // Remove todas as rotas da pilha
                  );
                },
                icon: const Icon(Icons.restaurant_menu, color: Colors.white), // Ícone sugestivo
                label: const Text('NOVO PEDIDO (VOLTAR)', style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Cor diferente para destaque
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

  // Widget auxiliar para construir as linhas de resumo (mantido, mas otimizado)
  Widget _buildSummaryRow(String label, double value, Color valueColor, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTotal ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 22 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(fontSize: isTotal ? 22 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}
