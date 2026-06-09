import 'package:crud_withnodejs_b/models/empresa.dart';
import 'package:flutter/material.dart';

class EmpresaProvider  with ChangeNotifier{
  List<Empresa> _empresas = [];
  List<Empresa> get empresas => _empresas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
}