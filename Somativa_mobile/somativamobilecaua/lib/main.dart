import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:somativamobilecaua/providers/bag_provider.dart';
import 'package:somativamobilecaua/screens/login.dart'; // Sua tela inicial de Login

void main() {
  runApp(
    // Envolve o aplicativo com o ChangeNotifierProvider para o BagProvider
    ChangeNotifierProvider(
      create: (context) => BagProvider(), // Instancia o BagProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mange Eats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const Login(), 
    );
  }
}