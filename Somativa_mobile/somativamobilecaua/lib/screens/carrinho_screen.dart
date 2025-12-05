import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somativamobilecaua/models/produto.dart';
import 'package:somativamobilecaua/providers/bag_provider.dart';
import 'package:somativamobilecaua/screens/confirmacao_pedido_screen.dart';
import 'package:somativamobilecaua/services/viacep_service.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final TextEditingController _cepController = TextEditingController();
  final ViaCepService _cepService = ViaCepService();

  // IP REAL DO HOST (para carregar imagens do carrinho)
  static const String _hostIp = '10.109.83.16'; 

  @override
  void initState() {
    super.initState();
    final bagProvider = Provider.of<BagProvider>(context, listen: false);
    _cepController.text = bagProvider.cep;
  }

  // 🚨 NOVO: Função para confirmar e limpar o carrinho
  void _confirmAndClearCart(BagProvider provider) {
    if (provider.itens.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar Carrinho?'),
          content: const Text('Tem certeza que deseja remover todos os itens?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('LIMPAR', style: TextStyle(color: Colors.red)),
              onPressed: () {
                provider.clearBag(); // Chama o método de limpeza
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Carrinho limpo com sucesso!'), duration: Duration(seconds: 2))
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Função para buscar o endereço e calcular o frete (Mantida)
  Future<void> _buscarCep(BagProvider provider) async {
    final cep = _cepController.text.replaceAll('-', '').trim();
    if (cep.length != 8) {
      _showErrorDialog("O CEP deve ter 8 dígitos.");
      return;
    }

    try {
      final endereco = await _cepService.fetchAddress(cep);

      if (endereco != null) {
        provider.setEndereco(cep, 
          '${endereco['logradouro']}, ${endereco['bairro']} - ${endereco['localidade']}/${endereco['uf']}'
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Endereço obtido e frete calculado!"), duration: Duration(seconds: 2)));
      } else {
        _showErrorDialog("CEP não encontrado ou inválido.");
        provider.setEndereco(cep, 'CEP não encontrado.');
      }
    } catch (e) {
      _showErrorDialog("Erro ao buscar CEP. Verifique sua conexão.");
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
        actions: [
          Consumer<BagProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.white),
                onPressed: provider.itens.isEmpty ? null : () => _confirmAndClearCart(provider),
                tooltip: 'Limpar todos os itens',
              );
            },
          ),
        ],
      ),
      body: Consumer<BagProvider>(
        builder: (context, bagProvider, child) {
          return Column(
            children: [
              // Lista de Itens no Carrinho (AGRUPADA)
              Expanded(
                child: bagProvider.itens.isEmpty
                    ? const Center(child: Text("Seu carrinho está vazio."))
                    : ListView.builder(
                        itemCount: bagProvider.itens.length, // Lista de produtos únicos
                        itemBuilder: (context, index) {
                          final produto = bagProvider.itens[index];
                          final quantidade = bagProvider.getQuantidade(produto);
                          final subTotalItem = produto.preco * quantidade;
                          
                          // URL da Imagem (usando o IP real do host para Mídia)
                          final imageUrl = produto.imagemUrl != null 
                              ? 'http://10.109.83.16:8000/media/${produto.imagemUrl!}' 
                              : null;

                          return ListTile(
                            leading: imageUrl != null
                                ? Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover)
                                : const Icon(Icons.fastfood, color: Colors.grey),
                            title: Text('${produto.nome} (x$quantidade)'), // Item + Contador
                            subtitle: Text("Total do Item: R\$ ${subTotalItem.toStringAsFixed(2)}"),
                            
                            // Botões de Controle de Quantidade
                            trailing: Row( 
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botão Remover
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () => bagProvider.removerItem(produto),
                                ),
                                // Botão Adicionar
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () => bagProvider.adicionarItem(produto),
                                ),
                              ],
                            ),
                          );
                        },
                    ),
              ),

              const Divider(thickness: 2),

              // Campo CEP e Endereço (Mantido)
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
              
              // Totais e Botão de Confirmação (Mantido)
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
