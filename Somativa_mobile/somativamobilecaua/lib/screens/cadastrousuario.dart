import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class Cadastrousuario extends StatefulWidget {
  const Cadastrousuario({super.key});

  @override
  State<Cadastrousuario> createState() => _CadastrousuarioState();
}

class _CadastrousuarioState extends State<Cadastrousuario> {
  final TextEditingController user_n = TextEditingController();
  final TextEditingController email_n = TextEditingController(); 
  final TextEditingController senha_n = TextEditingController();
  final TextEditingController senha_confirma_n = TextEditingController(); 

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool exibir = false; // Estado para exibir/ocultar senha

  _cadastrausuario() async {
    if (!_formKey.currentState!.validate()) return;

    // URL do Django (usando 10.0.2.2 para emulador)
    String url = "http://10.0.2.2:8000/api/usuarios/"; 

    // Mapeamento para os campos do Serializer do Django
    Map<String, dynamic> mensagem = {
      "username": user_n.text, 
      "email": email_n.text, 
      "password": senha_n.text,
      "password_confirm": senha_confirma_n.text, 
    };

    try {
        http.Response response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
                'Content-type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(mensagem));

        if (response.statusCode == 201) {
            user_n.clear();
            email_n.clear();
            senha_n.clear();
            senha_confirma_n.clear();
            _showAlertDialog("Usuário cadastrado com sucesso! Faça seu login.");
        } else {
            String errorMsg = "Falha ao cadastrar. Verifique os dados.";
            try {
                var errorBody = json.decode(response.body);
                // Tentativa de formatar mensagens de erro do Django
                if (errorBody.containsKey('username')) errorMsg = "Login inválido ou já existe.";
                else if (errorBody.containsKey('email')) errorMsg = "Email inválido ou já existe.";
                else if (errorBody.containsKey('password_confirm')) errorMsg = "Confirmação de Senha inválida.";
                else if (errorBody.containsKey('password')) errorMsg = "Senha fraca ou inválida.";
            } catch (_) {}
            _showAlertDialog(errorMsg);
        }
    } catch (e) {
        _showAlertDialog("Erro de conexão. Verifique o servidor Django.");
    }
  }

  void _showAlertDialog(String message) {
     showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fechar"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Cliente Mange Eats"), 
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form( 
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(user_n, "Digite seu login (Username)", Icons.people_alt_outlined, false),
                const SizedBox(height: 15),
                _buildTextField(email_n, "Digite seu E-mail", Icons.email_outlined, false, keyboard: TextInputType.emailAddress, 
                  validator: (value) => (value == null || !value.contains('@')) ? 'Email inválido' : null),
                const SizedBox(height: 15),
                _buildPasswordField(senha_n, "Digite sua senha"),
                const SizedBox(height: 15),
                _buildPasswordField(senha_confirma_n, "Confirme sua senha", 
                  validator: (value) => (value != senha_n.text || value!.isEmpty) ? 'As senhas não conferem' : null),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _cadastrausuario, 
                      child: const Text("Cadastrar", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15))
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, bool obscure, {TextInputType? keyboard, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard ?? TextInputType.name,
      obscureText: obscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        icon: Icon(icon, color: Colors.red),
        hintText: hint,
      ),
      validator: validator ?? (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
    );
  }
  
  Widget _buildPasswordField(TextEditingController controller, String hint, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      obscureText: !exibir,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        icon: const Icon(Icons.key_off_outlined, color: Colors.red),
        hintText: hint,
        suffixIcon: IconButton(
          icon: Icon(exibir ? Icons.visibility : Icons.visibility_off),
          onPressed: () { setState(() { exibir = !exibir; }); }
        ),
      ),
      validator: validator ?? (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
    );
  }
}