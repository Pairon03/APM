import 'package:somativamobilecaua/screens/cadastrousuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Importação da nova tela do Cardápio para navegação pós-login
import 'package:somativamobilecaua/screens/cardapio_screen.dart'; // MUDAR AQUI

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Criando variaveis para usuario e senha
  TextEditingController user = TextEditingController();
  TextEditingController senha = TextEditingController();
  // variavel para exibir a senha
  bool exibir = false;

  // função para realize o login
_verificaLogin() async {
  // ATUALIZE O IP AQUI para o seu IP real e use o endpoint customizado 'login'
  String url = "http://10.0.2.2:8000/api/usuarios/login/"; 

  // Mapeamos os campos do Flutter (user, senha) para os campos que a view de login do Django espera
  Map<String, dynamic> loginData = {
    "username": user.text, 
    "password": senha.text
  };

  try {
    http.Response resposta = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(loginData));

    if (resposta.statusCode == 200) {
      // Login bem-sucedido
      print("Login realizado com sucesso!");
      // Limpa os campos e navega para o Cardápio
      user.text = "";
      senha.text = "";
      Navigator.pushReplacement( 
          context, MaterialPageRoute(builder: (context) => CardapioScreen()));
    } else {
      // Login falhou (erro 401 ou 400)
      print("Login falhou - Status: ${resposta.statusCode}");
      user.text = "";
      senha.text = "";
      _showAlertDialog("Usuário ou senha inválidos.");
    }
  } catch (e) {
    print("Erro durante a requisição: $e");
    _showAlertDialog("Erro de conexão. Verifique o servidor Django.");
  }
}

  // Função auxiliar para exibir o AlertDialog
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container/Widget que representa o logo Mange Eats, por exemplo
            Text(
              'MANGE EATS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 300,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        icon: Icon(
                          Icons.people_alt_outlined,
                          color: Colors.red,
                        ),
                        hintText: "Digite seu login",
                      ),
                      controller: user,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        icon: Icon(Icons.key_off_outlined, color: Colors.red),
                        suffixIcon: IconButton(
                          icon: Icon(
                            exibir ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              exibir = !exibir;
                            });
                          },
                        ),
                        hintText: "Digite sua senha",
                      ),
                      obscureText: !exibir, // Correção: use !exibir
                      obscuringCharacter: '*',
                      controller: senha,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _verificaLogin,
                    child: Text("Entrar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // NAVEGA PARA A TELA DE CADASTRO (Requisito B da prova)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Cadastrousuario(),
                        ),
                      );
                    },
                    child: Text("Cadastrar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe Users não precisa de alteração, mas deve ser mantida.
class Users {
  String id;
  String login;
  String senha;

  Users(this.id, this.login, this.senha);

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(json["id"], json["login"], json["senha"]);
  }
}
