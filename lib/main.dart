import 'package:crud_withnodejs_b/providers/empresa_provider.dart';
import 'package:crud_withnodejs_b/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(isLogged: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLogged;

  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmpresaProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Registro de Empresas',
        theme: ThemeData(primarySwatch: Colors.indigo),

        home: isLogged ? const ListScreen() : const LoginScreen(),

        routes: {
          '/list': (context) => const ListScreen(),
          '/form': (context) => const FormScreen(),
          '/detail': (context) => const DetailScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
