import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {
   
  const FormScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Empresa'),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
         child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (value) => "Ingrese su nombre",
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "RUC"),
                validator: (value) => "Ingrese su RUC",
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "Direccion"),
                validator: (value) => "Ingrese la direccion",
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "Rubro"),
                validator: (value) => "Ingrese su rubro",
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: (){}, 
                child: Text('Guardar')
                )
            ],
          )
          ),
      ),
    );
  }
}
