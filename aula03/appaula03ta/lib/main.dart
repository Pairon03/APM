import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(TelaHome());
}

// Cria a classe tela home
class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Aula 03 App Sharedpreferences',
    debugShowCheckedModeBanner: false,
    home: TelaApp() ,
    
    );
  }
}

class TelaApp extends StatefulWidget {
  const TelaApp({super.key});

  @override
  State<TelaApp> createState() => _TelaAppState();
}

class _TelaAppState extends State<TelaApp> {
 // cria uma variavel para armazenar o que o usuario digita
 final _ctrlNome = TextEditingController(); 
 String _nomeSalvo =""; // Variavel para pegar informaçoes no banco de dados
 static const String _kUsernames = 'usernames';
 bool _existeUsername = false;
 // Cria uma lista para armazenar os nomes
 List<String> _nomes=[];
 // polimorfismo
@override
void initState(){
  super.initState();
  // implementar função para carregar os nomes
  _carregaNome();
}

@override
// Funçao monitorar o texteditcontroller

void dispose(){
  _ctrlNome.dispose();
  super.dispose();
}

// Função para salvar o nome

Future<void> _salvarNome()async{
  // faz a leitura do Sharedpreferences

  final prefs = await SharedPreferences.getInstance();
  // cria uma variavel chamada nome
  final nome = _ctrlNome.text.trim(); // trim funçao que remove os espaços em branco no texteditingcontroller
  final atuais = prefs.getStringList(_kUsernames)??[]; // armazena os nomes salvos na lista
  // contains serve para verificar se o nome ja esta na lista
  if(atuais.contains(nome)){
    _snack('Esse nome ja esta na lista');
    return;
  }

 atuais.add(nome); // atualiza a lista de nomes
 await prefs.setStringList(_kUsernames, atuais); // salva a informação
 // atualiza a informação salva com setState
 setState(() {
   _nomes=List<String>.from(atuais);
   _ctrlNome.clear(); // Limpa o campo texto

   _snack('Nome salvo com sucesso');
 });

}

// Função para carregar os nomes no aplicativo

Future<void> _carregaNome()async{

  // realiza a leitura do que está armazenado

  final prefs = await SharedPreferences.getInstance();
  setState(() => _nomes=prefs.getStringList(_kUsernames)??[]);

}

// Função para remover um nome

Future<void>_removerNome(String nome)async{
  final prefs = await SharedPreferences.getInstance();
  final atuais = prefs.getStringList(_kUsernames)??[];
  atuais.remove(nome);

  await prefs.setStringList(_kUsernames, atuais);
  setState(() {
    _nomes= List<String>.from(atuais);
    _snack('Removido $nome');
  });

}

// Função para limpar tudo
Future<void> _limparTudo()async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kUsernames);
  setState(() {
    _nomes=[];
  });

}

// Cria a função snack 
void _snack(String msg){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(msg)));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('App aula 03 - SharedPreferences'),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Digite um nome e salve localmente com SharedPreferences',
            style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              controller: _ctrlNome,
              decoration: InputDecoration(labelText: 'Nome',
              border: OutlineInputBorder()),
              textInputAction: TextInputAction.done, // Açao do texto no textfield
              onSubmitted: (_)=>_salvarNome(),
              
            ),

            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _salvarNome, icon: Icon(Icons.save),
                    label: Text('Salvar') ,)),
                    SizedBox(height: 8,),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _carregaNome, 
                        icon:Icon(Icons.refresh),label: Text('Carregar'))),
                  SizedBox(height: 8,),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _nomes.isEmpty? null:_limparTudo, label: Text('Remover'),
                      icon: Icon(Icons.delete) ,)),                 
              ],
            ),
            SizedBox(height: 16,),
            Expanded(
              child: _nomes.isEmpty?
              Center(
                child: Text('Sem nomes salvos'),
              ):ListView.separated(
                itemCount: _nomes.length,
                separatorBuilder: (_,__)=> Divider(height: 1,),
                itemBuilder: (context, i) {
                  final nome = _nomes[i];
                  return Dismissible(
                    key: ValueKey(nome), 
                    background: Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.delete),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      

                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.delete),
                    ),
                    onDismissed: (__)=>_removerNome(nome),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(nome.isNotEmpty?nome[0].toUpperCase():'?'),
                      ),
                      title: Text(nome),
                      trailing: IconButton(
                        onPressed: ()=>_removerNome(nome), icon: Icon(Icons.delete)),
                    ),
                    );

                },
                )),
                
              
              Align(
                alignment: Alignment.centerRight,
                child: Text('Total ${_nomes.length}'),
              )
          ],
        
        ),
      ),
      
    );
  }
}