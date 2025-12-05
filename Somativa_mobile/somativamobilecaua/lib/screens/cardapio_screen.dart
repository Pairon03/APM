import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:somativamobilecaua/models/produto.dart';
import 'package:somativamobilecaua/providers/bag_provider.dart';
import 'package:somativamobilecaua/screens/carrinho_screen.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  List<Produto> _produtos = []; 
  String _categoriaSelecionada = 'pizza';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProdutos(); 
  }

  Future<void> _fetchProdutos() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/cardapio/'); 

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        setState(() {
          // CORREÇÃO APLICADA: Mapeamento explícito de todos os campos
          _produtos = data.map((json) {
            final precoDouble = double.parse(json['preco']); 
            
            return Produto.fromJson({
              'id': json['id'].toString(),
              'nome': json['nome'] as String,
              'descricao': json['descricao'] as String,
              'preco': precoDouble,
              'categoria': json['categoria'] as String,
              'imagem': json['imagem'], // Caminho da imagem
            });
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mange Eats - Cardápio'), backgroundColor: Colors.red),
        body: const Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    
    final produtosFiltrados = _produtos
        .where((p) => p.categoria == _categoriaSelecionada)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mange Eats - Cardápio'),
        backgroundColor: Colors.red,
        actions: [
          // Botão Carrinho com contador
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CarrinhoScreen()));
                },
              ),
              if (bagProvider.itens.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text('${bagProvider.itens.length}', style: const TextStyle(color: Colors.red, fontSize: 10)),
                  ),
                )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Menu de Categoria (Lanches/Pizzas)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('pizza', Icons.local_pizza),
                _buildCategoryButton('lanche', Icons.lunch_dining),
              ],
            ),
          ),
          
          const Divider(),

          // Lista de Produtos
          Expanded(
            child: produtosFiltrados.isEmpty
                ? Center(child: Text("Nenhum item de $_categoriaSelecionada disponível."))
                : ListView.builder(
                    itemCount: produtosFiltrados.length,
                    itemBuilder: (context, index) {
                      final produto = produtosFiltrados[index];
                      
                      // Montagem da URL completa para a imagem
                      final imageUrl = produto.imagemUrl != null 
                          ? 'http://10.0.2.2:8000${produto.imagemUrl!}' 
                          : null; 

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 2,
                        child: ListTile(
                          // Exibir Imagem se houver (leading)
                          leading: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                  },
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.grey),
                                )
                              : const Icon(Icons.fastfood, color: Colors.red),
                          
                          title: Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${produto.descricao}\nR\$ ${produto.preco.toStringAsFixed(2)}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                            onPressed: () {
                              bagProvider.adicionarItem(produto);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${produto.nome} adicionado!'), duration: const Duration(seconds: 1)),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCategoryButton (Mantido)
  Widget _buildCategoryButton(String category, IconData icon) {
    final bool isSelected = _categoriaSelecionada == category;
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _categoriaSelecionada = category;
        });
      },
      icon: Icon(icon),
      label: Text(category.toUpperCase()),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.red,
        backgroundColor: isSelected ? Colors.red : Colors.white,
        side: const BorderSide(color: Colors.red),
      ),
    );
  }
}
