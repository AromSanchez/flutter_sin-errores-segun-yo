import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Empresas"),
      ),
      body: Column(
        children: [
          ListView.builder(itemBuilder: (context, index){
            return Card(
              child: ListTile(
                title: Text("Nombre de la empresa"),
                subtitle: Text("RUC: ..."),
                trailing: Row(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.indigo,)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.red,)),
                  ],
                ),
              ),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add_business_outlined),
      ),
    );
  }
}