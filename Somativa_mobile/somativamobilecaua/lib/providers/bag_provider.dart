import 'package:flutter/foundation.dart';
import 'package:somativamobilecaua/models/produto.dart';

class BagProvider extends ChangeNotifier {
  // Lista que armazena os produtos no carrinho
  final List<Produto> _itens = [];
  
  // Variáveis para controle de CEP e Frete
  String _cep = '';
  String _enderecoEntrega = 'Informe o CEP para calcular o frete.';
  double _taxaEntrega = 0.0;
  
  // Getters para acessar os dados
  List<Produto> get itens => _itens;
  String get cep => _cep;
  String get enderecoEntrega => _enderecoEntrega;
  double get taxaEntrega => _taxaEntrega;

  // Calcula o subtotal dos itens (sem o frete)
  double get subTotal {
    double total = 0.0;
    for (var item in _itens) {
      total += item.preco;
    }
    return total;
  }
  
  // Calcula o total geral da compra (Subtotal + Taxa de Entrega)
  double get totalGeral => subTotal + _taxaEntrega;

  /// Adiciona um produto ao carrinho
  void adicionarItem(Produto produto) {
    _itens.add(produto);
    notifyListeners(); // Notifica as widgets para reconstruírem
  }

  /// Remove um produto do carrinho
  void removerItem(Produto produto) {
    _itens.removeWhere((item) => item.id == produto.id);
    // Nota: Em um carrinho mais complexo, você removeria apenas 1 unidade.
    notifyListeners(); 
    // Recalcula o frete, caso o subtotal caia abaixo do limite
    _calcularTaxaEntrega();
  }

  /// Define o endereço e recalcula a taxa de entrega
  void setEndereco(String cep, String endereco) {
    _cep = cep;
    _enderecoEntrega = endereco;
    _calcularTaxaEntrega();
    notifyListeners();
  }

  /// Lógica de cálculo da taxa de entrega (Requisito D)
  void _calcularTaxaEntrega() {
    if (subTotal >= 100.00) {
      _taxaEntrega = 0.0; // Acima de R$ 100,00 não tem taxa de entrega
    } else {
      // Exemplo de taxa padrão para pedidos abaixo de R$ 100,00
      _taxaEntrega = 10.00; 
    }
    notifyListeners();
  }
  
  /// Limpa o carrinho após a finalização do pedido
  void clearBag() {
    _itens.clear();
    _cep = '';
    _enderecoEntrega = 'Informe o CEP para calcular o frete.';
    _taxaEntrega = 0.0;
    notifyListeners();
  }
}