class Produto {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final String categoria;
  final String? imagemUrl;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    this.imagemUrl,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as String, // Espera String
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      preco: json['preco'] as double, // Espera double
      categoria: json['categoria'] as String,
      imagemUrl: json['imagem'] as String?,
    );
  }
}
