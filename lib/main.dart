import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './handlers/atividade_handler.dart';
import './components/home_atividade.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AtividadeHandler(), 
      child: const AtividadeApp(),
    )
  );
}

class AtividadeApp extends StatelessWidget {
  const AtividadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent, 
          brightness: Brightness.light).copyWith(
            onSecondary: Colors.white
          ),
        appBarTheme: const AppBarTheme(
          color: Colors.blueAccent,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white, 
            fontSize: 22, 
            fontWeight: FontWeight.bold
          ),
          centerTitle: true,
          elevation: 0
        ),
        scaffoldBackgroundColor: Colors.grey[300],
      ),
      home: const HomeAtividade(),
    );
  }
}
