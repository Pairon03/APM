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
  bool _isLoading = true;
  
  // IP REAL DO HOST - Usado para Mídia/Imagens (mais confiável se a rede estiver aberta)
  static const String _hostIp = '10.109.83.16';
  // IP DO EMULADOR - Usado para a API (GET/POST)
  static const String _emuladorIp = '10.0.2.2';


  @override
  void initState() {
    super.initState();
    _fetchProdutos(); 
  }

  Future<void> _fetchProdutos() async {
    // Usamos o IP do emulador para a API, pois é o padrão de roteamento
    final url = Uri.parse('http://$_emuladorIp:8000/api/cardapio/'); 

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        setState(() {
          _produtos = data.map((json) {
            final precoDouble = double.parse(json['preco']); 
            
            return Produto.fromJson({
              'id': json['id'].toString(),
              'nome': json['nome'] as String,
              'descricao': json['descricao'] as String,
              'preco': precoDouble,
              'categoria': json['categoria'] as String,
              'imagem': json['imagem'], // Caminho parcial: /media/produtos/...
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
  
  // Função que constrói a imagem do produto com tratamento de erro e carregamento
  Widget _buildProductImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, color: Colors.grey, size: 40),
            )
          : const Icon(Icons.fastfood, color: Colors.red, size: 40),
    );
  }

  // Função que constrói o card do produto (Melhorando a estética)
  Widget _buildProductCard(Produto produto, BagProvider bagProvider) {
    // CORREÇÃO: Usamos o IP REAL do host para o carregamento da imagem (MÍDIA)
    // O Django deve estar rodando em 0.0.0.0:8000 para que isso funcione.
    final imageUrl = produto.imagemUrl != null 
        ? 'http://10.109.83.16:8000/media/${produto.imagemUrl!}' 
        : null; 
        
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildProductImage(imageUrl),
        title: Text(
          produto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.descricao,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart, color: Colors.green, size: 30),
          onPressed: () {
            bagProvider.adicionarItem(produto);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${produto.nome} adicionado!'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  // Função que constrói o título da seção
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: Colors.black87
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bagProvider = Provider.of<BagProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mange Eats - Cardápio'),
          backgroundColor: Colors.red,
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    // Filtra os produtos para as duas categorias principais
    final pizzas = _produtos.where((p) => p.categoria == 'pizza').toList();
    final lanches = _produtos.where((p) => p.categoria == 'lanche').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mange Eats - Cardápio'),
        backgroundColor: Colors.red,
        actions: [
          // Botão Carrinho com contador (RESTAURADO)
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarrinhoScreen(),
                    ),
                  );
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
      body: ListView(
        children: [
          // Seção PIZZAS
          _buildSectionTitle('🍕 Nossas Pizzas'),
          ...pizzas.map((produto) => _buildProductCard(produto, bagProvider)).toList(),

          const Divider(height: 40, indent: 15, endIndent: 15),

          // Seção LANCHES
          _buildSectionTitle('🍔 Nossos Lanches'),
          ...lanches.map((produto) => _buildProductCard(produto, bagProvider)).toList(),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
