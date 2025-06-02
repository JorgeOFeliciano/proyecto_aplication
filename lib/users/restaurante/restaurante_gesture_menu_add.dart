import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_aplication/data/maps.dart'; // Contiene generateMenu y allMenus
import 'package:proyecto_aplication/items/items.dart'; // Tus botones personalizados

class AddDishScreen extends StatefulWidget {
  final String restaurantTitle;
  final String category;

  const AddDishScreen({
    Key? key,
    required this.restaurantTitle,
    required this.category,
  }) : super(key: key);

  @override
  State<AddDishScreen> createState() => _AddDishScreenState();
}

class _AddDishScreenState extends State<AddDishScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _imagePath = '';

  Future<void> _saveDish() async {
    final newDish = {
      'name': _nameController.text,
      'description': _descController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'image': _imagePath.isNotEmpty ? _imagePath : '',
    };

    final prefs = await SharedPreferences.getInstance();
    final String menuKey = 'savedMenu_${widget.restaurantTitle}';
    Map<String, List<Map<String, dynamic>>> restaurantMenu;

    final menuJson = prefs.getString(menuKey);

    if (menuJson != null) {
      final decoded = jsonDecode(menuJson) as Map<String, dynamic>;
      restaurantMenu = decoded.map((key, value) =>
          MapEntry(key, List<Map<String, dynamic>>.from(value)));
    } else {
      final generated =
          generateMenu(widget.restaurantTitle)[widget.restaurantTitle]!;
      restaurantMenu = generated.map((key, value) =>
          MapEntry(key, List<Map<String, dynamic>>.from(value)));
    }

    // Asegura que la lista es mutable y del tipo correcto
    final List<Map<String, dynamic>> dishesList =
        List<Map<String, dynamic>>.from(
            restaurantMenu[widget.category] ?? []);

    dishesList.add(newDish);
    restaurantMenu[widget.category] = dishesList;

    await prefs.setString(menuKey, jsonEncode(restaurantMenu));
    allMenus[widget.restaurantTitle] = restaurantMenu;

    Navigator.pop(context, newDish);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Platillo"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre del Platillo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Precio",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            IconButtonCustom(
              label: "Guardar Platillo",
              icon: Icons.save,
              onPressed: _saveDish,
            ),
          ],
        ),
      ),
    );
  }
}
