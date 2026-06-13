import 'package:flutter/material.dart';
import 'package:crud_withnodejs_b/models/empresa.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Empresa empresa =
        ModalRoute.of(context)!.settings.arguments as Empresa;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la Empresa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  empresa.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("RUC: ${empresa.ruc}"),
                const SizedBox(height: 10),
                Text("Dirección: ${empresa.direccion ?? '-'}"),
                const SizedBox(height: 10),
                Text("Rubro: ${empresa.rubro ?? '-'}"),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/form',
                          arguments: empresa,
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Editar"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // luego podemos mejorar esto
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Eliminar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}