import 'package:crud_withnodejs_b/models/empresa.dart';
import 'package:crud_withnodejs_b/providers/empresa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _rucController = TextEditingController();
  final _direccionController = TextEditingController();
  final _rubroController = TextEditingController();
  Empresa? _empresa;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_empresa != null) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Empresa) {
      _empresa = args;
      _nombreController.text = _empresa!.nombre;
      _rucController.text = _empresa!.ruc;
      _direccionController.text = _empresa!.direccion ?? '';
      _rubroController.text = _empresa!.rubro ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rucController.dispose();
    _direccionController.dispose();
    _rubroController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese $fieldName';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = Provider.of<EmpresaProvider>(context, listen: false);
    final empresa = Empresa(
      id: _empresa?.id,
      nombre: _nombreController.text.trim(),
      ruc: _rucController.text.trim(),
      direccion: _direccionController.text.trim().isEmpty
          ? null
          : _direccionController.text.trim(),
      rubro: _rubroController.text.trim().isEmpty
          ? null
          : _rubroController.text.trim(),
      esactivo: _empresa?.esactivo ?? true,
    );

    try {
      if (_empresa != null && _empresa!.id != null) {
        await provider.update(_empresa!.id!, empresa);
      } else {
        await provider.add(empresa);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error guardando empresa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _empresa != null ? 'Editar Empresa' : 'Nueva Empresa';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => _requiredValidator(value, 'el nombre'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _rucController,
                decoration: const InputDecoration(labelText: 'RUC'),
                validator: (value) => _requiredValidator(value, 'el RUC'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Direccion'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _rubroController,
                decoration: const InputDecoration(labelText: 'Rubro'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
