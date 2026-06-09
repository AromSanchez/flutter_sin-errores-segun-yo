import 'package:crud_withnodejs_b/screens/screens.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Empresas',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/form',
      routes:{
        '/' : (context) => ListScreen(),
        '/form' : (context) => FormScreen(),
        '/detail' : (context) => DetailScreen()
      }
      
    );
  }
}