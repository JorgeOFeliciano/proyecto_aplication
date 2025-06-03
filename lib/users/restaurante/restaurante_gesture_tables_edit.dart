import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:proyecto_aplication/items/items.dart'; // 🔥 Importa tu CustomButton

class EditTableDetailScreen extends StatefulWidget {
  final Map<String, dynamic> tableData;

  const EditTableDetailScreen({Key? key, required this.tableData}) : super(key: key);

  @override
  State<EditTableDetailScreen> createState() => _EditTableDetailScreenState();
}

class _EditTableDetailScreenState extends State<EditTableDetailScreen> {
  late TextEditingController _capacidadController;
  late TextEditingController _mensajeController;
  late String _selectedStatus;
  late String _selectedImage;

  @override
  void initState() {
    super.initState();
    _capacidadController = TextEditingController(text: widget.tableData['capacidad'].toString());
    _mensajeController = TextEditingController(text: widget.tableData['mensaje']);
    _selectedStatus = widget.tableData['status'];
    _selectedImage = widget.tableData['imagen'];
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image.path;
      });
    }
  }

  void _saveChanges() {
    setState(() {
      widget.tableData['capacidad'] = int.tryParse(_capacidadController.text) ?? widget.tableData['capacidad'];
      widget.tableData['mensaje'] = _mensajeController.text;
      widget.tableData['status'] = _selectedStatus;
      widget.tableData['imagen'] = _selectedImage;
    });

    Navigator.pop(context, widget.tableData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Mesa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: _selectedImage.startsWith("assets/")
                        ? AssetImage(_selectedImage) as ImageProvider
                        : FileImage(File(_selectedImage)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildTextField("Capacidad", widget.tableData['capacidad'].toString(), (value) {
                      _capacidadController.text = value;
                    }, keyboardType: TextInputType.number),
                    _buildTextField("Mensaje", widget.tableData['mensaje'], (value) {
                      _mensajeController.text = value;
                    }),
                    const SizedBox(height: 10),
                    _buildStatusSelector(),
                    const SizedBox(height: 20),
                    // 🔥 Usa tu CustomButton aquí
                    CustomButton(
                      label: "Guardar Cambios",
                      onPressed: _saveChanges,
                      isActive: true,
                      paddingVertical: 14,
                      borderRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: label.toUpperCase(),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color.fromARGB(255, 200, 200, 200), width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Row(
      children: ['Disponible', 'No disponible'].map((status) {
        final isSelected = _selectedStatus == status;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedStatus = status;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.brown[100]! : Colors.white,
                foregroundColor: Colors.black87,
              ),
              child: Text(status),
            ),
          ),
        );
      }).toList(),
    );
  }
}