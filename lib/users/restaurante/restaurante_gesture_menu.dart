import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/users/restaurante/restaurante_gesture_menu_add.dart';

class EditMenuScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const EditMenuScreen({super.key, required this.restaurant});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  Map<String, List<Map<String, dynamic>>> _menu = {};
  List<String> _categories = [];
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    final prefs = await SharedPreferences.getInstance();
    final menuKey = 'savedMenu_${widget.restaurant['title']}';
    final menuJson = prefs.getString(menuKey);

    Map<String, List<Map<String, dynamic>>> menu;

    if (menuJson != null) {
      final decoded = jsonDecode(menuJson) as Map<String, dynamic>;
      menu = decoded.map((key, value) => MapEntry(key, List<Map<String, dynamic>>.from(value)));
    } else {
      final generated = generateMenu(widget.restaurant['title'])[widget.restaurant['title']]!;
      menu = generated.map((key, value) => MapEntry(key, List<Map<String, dynamic>>.from(value)));
    }

    setState(() {
      _menu = menu;
      _categories = _menu.keys.toList();
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    });
  }

  void _deleteDish(int index) {
    setState(() {
      _menu[_selectedCategory]?.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    allMenus[widget.restaurant['title']] = _menu;

    final prefs = await SharedPreferences.getInstance();
    final menuKey = 'savedMenu_${widget.restaurant['title']}';
    await prefs.setString(menuKey, jsonEncode(_menu));

    final index = restaurants.indexWhere((r) => r['title'] == widget.restaurant['title']);
    if (index != -1) {
      restaurants[index]['menu'] = _menu;
    }

    final updatedRestaurant = Map<String, dynamic>.from(restaurants[index]);
    updatedRestaurant['menu'] = _menu;

    Navigator.pop(context, updatedRestaurant);
  }

  Future<void> _addNewDish() async {
    final newDish = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDishScreen(
          restaurantTitle: widget.restaurant['title'],
          category: _selectedCategory,
        ),
      ),
    );

    if (newDish != null && newDish is Map<String, dynamic>) {
      setState(() {
        _menu[_selectedCategory]?.add(newDish);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_menu.isEmpty || _categories.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCategorySelector(),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _menu[_selectedCategory]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final dish = _menu[_selectedCategory]![index];
                    return _buildDishItem(dish, index);
                  },
                ),
              ),
              const SizedBox(height: 12),
              IconButtonCustom(
                label: "Agregar Platillo",
                icon: Icons.add,
                onPressed: _addNewDish,
                backgroundColor: Colors.white,
                textColor: Colors.brown,
                borderRadius: 8,
              ),
              const SizedBox(height: 20),
              CustomButton(label: "Guardar Cambios", isActive: true, onPressed: _saveChanges),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Editar Menú"),
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.isNotEmpty ? _categories.length + 2 : 2, // ✅ Asegura que los botones siempre estén visibles
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == _categories.length || (_categories.isEmpty && index == 0)) {
            return ChoiceChip(
              label: Row(
                children: const [
                  Icon(Icons.add, size: 18),
                  SizedBox(width: 4),
                  Text("Añadir filtro", style: TextStyle(color: Colors.black)), // ✅ Texto asegurado
                ],
              ),
              selected: false,
              selectedColor: Colors.brown,
              labelStyle: const TextStyle(color: Colors.black),
              onSelected: (_) => _showAddFilterDialog(),
            );
          } else if (index == _categories.length + 1 || (_categories.isEmpty && index == 1)) {
            return ChoiceChip(
              label: Row(
                children: const [
                  Icon(Icons.remove, size: 18),
                  SizedBox(width: 4),
                  Text("Quitar filtro", style: TextStyle(color: Colors.black)), // ✅ Ajuste de visibilidad
                ],
              ),
              selected: false,
              selectedColor: Colors.red,
              labelStyle: const TextStyle(color: Colors.white),
              onSelected: (_) => _showRemoveFilterDialog(),
            );
          } else {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: Colors.brown,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              onSelected: (_) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            );
          }
        },
      ),
    );
  }

  void _showRemoveFilterDialog() {
    if (_categories.length <= 1) {
      // ✅ Si solo hay un filtro, no muestra la opción de eliminar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe haber al menos un filtro en el menú")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar filtro"),
        content: SizedBox(
          height: 250,
          child: SingleChildScrollView(
            child: Column(
              children: _categories.map((category) {
                return ListTile(
                  title: Text(category, style: const TextStyle(fontSize: 16, color: Colors.black)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _menu.remove(category);
                        _categories.remove(category);
                        if (_selectedCategory == category && _categories.isNotEmpty) {
                          _selectedCategory = _categories.first;
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar", style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }

  void _showAddFilterDialog() {
    final filterController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Añadir filtro"),
        content: TextField(
          controller: filterController,
          decoration: const InputDecoration(hintText: "Nombre del nuevo filtro"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              final newFilter = filterController.text.trim();
              if (newFilter.isNotEmpty && !_categories.contains(newFilter)) {
                setState(() {
                  _categories.add(newFilter);
                  _menu[newFilter] = [];
                  _selectedCategory = newFilter;
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text("Añadir filtro", style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }


Widget _buildDishItem(Map<String, dynamic> dish, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.fastfood, size: 50, color: Colors.brown),
        title: Text(dish['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('\$${dish['price']}'),
        trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteDish(index)),
      ),
    );
  }
}