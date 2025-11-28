import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>?> fetchAddress(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Verifica se a API retornou erro
        if (data.containsKey('erro') && data['erro'] == true) {
          return null; 
        }
        return data;
      } else {
        // Erro na requisição HTTP
        return null;
      }
    } catch (e) {
      // Erro de conexão ou parsing
      return null;
    }
  }
}