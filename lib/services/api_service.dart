import 'dart:convert';

import 'package:crud_withnodejs_b/models/empresa.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String base = 'http://10.0.2.2:3000/api';

  static Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$base/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['token'];
    } else {
      throw Exception("Error login");
    }
  }

  static Future<void> register(
    String nombre,
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$base/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception("Error registro");
    }
  }

  static Future<List<Empresa>> getEmpresa() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No autenticado');
    }

    final res = await http.get(
      Uri.parse('$base/empresas'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Empresa.fromJson(e)).toList();
    } else {
      throw Exception("Error al listar");
    }
  }

  static Future<Empresa> createEmpresa(Empresa e) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No autenticado');
    }

    final res = await http.post(
      Uri.parse('$base/empresas'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(e.toJson()),
    );

    if (res.statusCode == 201) {
      return Empresa.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Error al crear la empresa");
    }
  }

  static Future<Empresa> updateEmpresa(int id, Empresa e) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No autenticado');
    }

    final res = await http.put(
      Uri.parse('$base/empresas/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(e.toJson()),
    );

    if (res.statusCode == 200) {
      return Empresa.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Error al actualizar la empresa");
    }
  }

  static Future<void> deleteEmpresa(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No autenticado');
    }

    final res = await http.delete(
      Uri.parse('$base/empresas/$id'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Error al eliminar");
    }
  }
}