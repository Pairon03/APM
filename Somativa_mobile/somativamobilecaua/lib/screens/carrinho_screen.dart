import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somativamobilecaua/models/produto.dart';
import 'package:somativamobilecaua/providers/bag_provider.dart';
import 'package:somativamobilecaua/screens/confirmacao_pedido_screen.dart';
import 'package:somativamobilecaua/services/viacep_service.dart'; // Você criará este service

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final TextEditingController _cepController = TextEditingController();
  final ViaCepService _cepService = ViaCepService();

  @override
  void initState() {
    super.initState();
    // Preenche o CEP se já tiver um no provider
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    _cepController.text = bagProvider.cep;
  }

  // Função para buscar o endereço e calcular o frete (Requisito D)
  Future<void> _buscarCep(BagProvider provider) async {
    final cep = _cepController.text.replaceAll('-', '');
    if (cep.length != 8) {
      _showErrorDialog("O CEP deve ter 8 dígitos.");
      return;
    }

    try {
      final endereco = await _cepService.fetchAddress(cep);

      if (endereco != null) {
        // Atualiza o endereço e recalcula o frete no provider
        provider.setEndereco(cep, 
          '${endereco['logradouro']}, ${endereco['bairro']} - ${endereco['localidade']}/${endereco['uf']}'
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Endereço obtido e frete calculado!"), duration: Duration(seconds: 1)));
      } else {
        _showErrorDialog("CEP não encontrado ou inválido.");
        provider.setEndereco(cep, 'CEP não encontrado.');
      }
    } catch (e) {
      _showErrorDialog("Erro ao buscar CEP: Verifique sua conexão.");
      provider.setEndereco(cep, 'Erro na busca do CEP.');
    }
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
        backgroundColor: Colors.red,
      ),
      body: Consumer<BagProvider>(
        builder: (context, bagProvider, child) {
          return Column(
            children: [
              // Lista de Itens no Carrinho
              Expanded(
                child: bagProvider.itens.isEmpty
                    ? const Center(child: Text("Seu carrinho está vazio."))
                    : ListView.builder(
                        itemCount: bagProvider.itens.length,
                        itemBuilder: (context, index) {
                          final item = bagProvider.itens[index];
                          return ListTile(
                            title: Text(item.nome),
                            subtitle: Text("R\$ ${item.preco.toStringAsFixed(2)}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => bagProvider.removerItem(item), // Remove Item (Requisito D)
                            ),
                          );
                        },
                      ),
              ),

              const Divider(thickness: 2),

              // Campo CEP e Endereço (Requisito D)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cepController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'CEP para Entrega',
                              hintText: 'Digite apenas números',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _buscarCep(bagProvider),
                          child: const Text('Buscar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Exibir endereço e frete
                    Text('Endereço: ${bagProvider.enderecoEntrega}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text('Frete: R\$ ${bagProvider.taxaEntrega.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              const Divider(thickness: 2),
              
              // Totais e Botão de Confirmação
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                        Text('R\$ ${bagProvider.subTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL GERAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('R\$ ${bagProvider.totalGeral.toStringAsFixed(2)}', 
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: bagProvider.itens.isEmpty || bagProvider.cep.isEmpty
                            ? null // Desabilita se vazio ou sem CEP
                            : () {
                                // Navega para a Tela Confirmação de Pedido (Requisito E)
                                Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => const ConfirmacaoPedidoScreen()));
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('CONFIRMAR PEDIDO', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}