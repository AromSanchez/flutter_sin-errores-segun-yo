import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crud_withnodejs_b/models/empresa.dart';
import 'package:crud_withnodejs_b/providers/empresa_provider.dart';
import 'package:crud_withnodejs_b/screens/login_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmpresaProvider>(context, listen: false).load();
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    int id,
    String nombre,
  ) async {
    final confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Estás seguro que deseas eliminar "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<EmpresaProvider>(context, listen: false);
      try {
        await provider.remove(id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Empresa eliminada'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmpresaProvider>(context);

    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final msg = provider.errorMessage!;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );

        provider.clearError();

        if (msg.contains('401') || msg.toLowerCase().contains('unauthorized')) {
          await _logout();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Empresas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: Column(
        children: [
          if (provider.isLoading) const LinearProgressIndicator(),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.load(),

              child: provider.empresas.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 200),
                        Center(child: Text('No hay empresas registradas')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: provider.empresas.length,
                      itemBuilder: (context, index) {
                        final Empresa e = provider.empresas[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              e.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("RUC: ${e.ruc}"),

                            onTap: () => Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: e,
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.indigo,
                                  ),
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/form',
                                    arguments: e,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(context, e.id!, e.nombre),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: provider.isLoading
            ? null
            : () => Navigator.pushNamed(context, '/form'),
        child: const Icon(Icons.add_business_outlined),
      ),
    );
  }
}
