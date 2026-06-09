import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de la Empresa"),
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              child: Column(
                children: [
                  Text("Nombre de la empresa"),
                  SizedBox(height: 10),
                  Text("RUC: ..."),
                  SizedBox(height: 10),
                  Text("Direccion: ..."),
                  SizedBox(height: 10),
                  Text("Rubro: ..."),
                  Row(
                    children: [
                      ElevatedButton.icon(onPressed: (){}, label: Text("Editar")),
                      ElevatedButton.icon(onPressed: (){}, label: Text("Eliminar"))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}