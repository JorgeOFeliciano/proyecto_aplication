import 'package:flutter/material.dart';
import 'package:proyecto_aplication/items/items.dart';

class AddDishScreen extends StatefulWidget {
  final String restaurantTitle;
  final String category;

  const AddDishScreen({Key? key, required this.restaurantTitle, required this.category})
      : super(key: key);

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addDish() {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();
    final double? price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || description.isEmpty || price == null) return;

    final newDish = {
      'name': name,
      'description': description,
      'price': price,
    };

    Navigator.pop(context, newDish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Nuevo Platillo"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nombre del platillo"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio"),
            ),
            const SizedBox(height: 16),
            CustomButton(label: "Agregar", isActive: true, onPressed: _addDish),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}