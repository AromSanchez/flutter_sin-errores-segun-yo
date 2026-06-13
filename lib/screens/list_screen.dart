import 'dart:math';

import 'package:crud_withnodejs_b/models/empresa.dart';
import 'package:crud_withnodejs_b/providers/empresa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> _confirmDelete(
    BuildContext context,
    int id,
    String nombre,
  ) async {
    final confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Eliminacion'),
        content: Text('¿Estas segura que deseas eliminar "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<EmpresaProvider>(context, listen: false);
      try {
        await provider.remove(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Empresa Eliminada'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmpresaProvider>(context);

    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
            onVisible: () {
              provider.clearError();
            },
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Empresas", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          if (provider.isLoading) LinearProgressIndicator(),
          Expanded(
            child: provider.empresas.isEmpty
            ? Center(child: Text('No hay empresas registradas'),)
            : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: provider.empresas.length,
              itemBuilder: (context, index) {
                final Empresa e = provider.empresas[index];
                return Card(
                  child: ListTile(
                    title: Text(e.nombre, style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("RUC: ${e.ruc}"),
                    onTap: ()=> Navigator.pushNamed(context, '/detail', arguments: e),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: ()=>Navigator.pushNamed(context, '/form', arguments: e),
                          icon: Icon(Icons.edit, color: Colors.indigo),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: ()=> _confirmDelete(context, e.id!, e.nombre),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.isLoading ? null: () => Navigator.pushNamed(context, '/form'),
        child: Icon(Icons.add_business_outlined),
      ),
    );
  }
}
