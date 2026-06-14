import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    try {
      await ApiService.register(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuario registrado correctamente"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // vuelve al login
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : register,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Registrarse"),
            )
          ],
        ),
      ),
    );
  }
}