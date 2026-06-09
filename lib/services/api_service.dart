
import 'dart:convert';

import 'package:crud_withnodejs_b/models/empresa.dart';


import 'package:http/http.dart' as http;

class ApiService {
  static const base = 'http://localhost:3000/api/empresas';
  static Future<List<Empresa>> getEmpresa() async {
    final res = await http.get(Uri.parse(base));
    if(res.statusCode == 200){
      final List data = jsonDecode(res.body);
      return data.map((e)=> Empresa.fromJson(e)).toList();
    }else{
      throw Exception("Error al listar");
    }
  }

  static Future<Empresa> createEmpresa(Empresa e) async{
    final res = await http.post((Uri.parse(base)),
    headers: {"Content-Type": "application/json"},
    body: json.encode(e.toJson()));
    if(res.statusCode == 201){
      return Empresa.fromJson(jsonDecode(res.body));
    }else{
      throw Exception("Error al crear la empresa");
    }
  }

  static Future<Empresa> updateEmpresa(int id, Empresa e) async {
    final res = await http.put(Uri.parse('$base/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(e.toJson()),
    );

    if (res.statusCode == 200) {
      return Empresa.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Error al actualizar la empresa");
    }
  }

  static Future<void> deleteEmpresa(int id) async{
    final res = await http.delete(Uri.parse('$base/$id'));
    if (res.statusCode != 200) throw Exception("Error al eliminar");

  }
}