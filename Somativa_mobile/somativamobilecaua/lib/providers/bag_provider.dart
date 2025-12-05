import 'package:flutter/foundation.dart';
import 'package:somativamobilecaua/models/produto.dart';

class BagProvider extends ChangeNotifier {
  final Map<Produto, int> _itens = {}; 
  
  String _cep = '';
  String _enderecoEntrega = 'Informe o CEP para calcular o frete.';
  double _taxaEntrega = 0.0;
  
  List<Produto> get itens => _itens.keys.toList(); 
  int getQuantidade(Produto produto) => _itens[produto] ?? 0; 
  String get cep => _cep;
  String get enderecoEntrega => _enderecoEntrega;
  double get taxaEntrega => _taxaEntrega;

  double get subTotal {
    double total = 0.0;
    _itens.forEach((produto, quantidade) {
      total += produto.preco * quantidade;
    });
    return total;
  }
  
  double get totalGeral => subTotal + _taxaEntrega;

  void adicionarItem(Produto produto) {
    _itens.update(
      produto, 
      (quantidade) => quantidade + 1, 
      ifAbsent: () => 1
    );
    _calcularTaxaEntrega();
    notifyListeners(); 
  }

  void removerItem(Produto produto) {
    if (_itens.containsKey(produto)) {
      int novaQuantidade = _itens[produto]! - 1;
      
      if (novaQuantidade <= 0) {
        _itens.remove(produto);
      } else {
        _itens[produto] = novaQuantidade;
      }
      _calcularTaxaEntrega();
      notifyListeners(); 
    }
  }

  void setEndereco(String cep, String endereco) {
    _cep = cep;
    _enderecoEntrega = endereco;
    _calcularTaxaEntrega();
    notifyListeners();
  }

  void _calcularTaxaEntrega() {
    if (subTotal >= 100.00) {
      _taxaEntrega = 0.0;
    } else {
      _taxaEntrega = 10.00; 
    }
    notifyListeners();
  }
  
  /// MÉTODO MODIFICADO PARA GARANTIR RECALCULO DE FRETE E RESET DE ESTADO
  void clearBag() {
    _itens.clear();
    _cep = '';
    _enderecoEntrega = 'Informe o CEP para calcular o frete.';
    _taxaEntrega = 0.0; // Recalcula taxa para zero
    notifyListeners();
  }
}