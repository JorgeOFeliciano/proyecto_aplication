import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/users/restaurante/restaurante_gesture_menu_add.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMenuScreen extends StatefulWidget {
  final String restaurantTitle;

  const EditMenuScreen({Key? key, required this.restaurantTitle})
      : super(key: key);

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  // El menú se maneja como: Map<String, List<Map<String, dynamic>>>
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
    final menuKey = 'savedMenu_${widget.restaurantTitle}';
    final menuJson = prefs.getString(menuKey);

    Map<String, List<Map<String, dynamic>>> menu;

    if (menuJson != null) {
      final decoded = jsonDecode(menuJson) as Map<String, dynamic>;
      menu = decoded.map((key, value) =>
          MapEntry(key, List<Map<String, dynamic>>.from(value)));
    } else {
      // Si no hay datos guardados, usamos la función generateMenu
      final generated =
          generateMenu(widget.restaurantTitle)[widget.restaurantTitle]!;
      menu = generated.map((key, value) =>
          MapEntry(key, List<Map<String, dynamic>>.from(value)));
    }

    setState(() {
      _menu = menu;
      _categories = _menu.keys.toList();
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    });
  }

  void _changeCategory(String? newCategory) {
    if (newCategory != null) {
      setState(() {
        _selectedCategory = newCategory;
      });
    }
  }

  Future<void> _addNewDish() async {
    final newDish = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDishScreen(
          restaurantTitle: widget.restaurantTitle,
          category: _selectedCategory,
        ),
      ),
    );

    if (newDish != null && newDish is Map<String, dynamic>) {
      setState(() {
        final currentList =
            List<Map<String, dynamic>>.from(_menu[_selectedCategory]!);
        currentList.add(newDish);
        _menu[_selectedCategory] = currentList;
      });
    }
  }

  void _deleteDish(int index) {
    setState(() {
      final currentList =
          List<Map<String, dynamic>>.from(_menu[_selectedCategory]!);
      currentList.removeAt(index);
      _menu[_selectedCategory] = currentList;
    });
  }

  // En _saveChanges() se actualizan las variables globales, se persisten los datos
  // y se retorna el restaurante actualizado.
  Future<void> _saveChanges() async {
    // 1. Se actualiza la variable global "allMenus".
    allMenus[widget.restaurantTitle] = _menu;

    // 2. Se guarda el menú actualizado en SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final menuKey = 'savedMenu_${widget.restaurantTitle}';
    await prefs.setString(menuKey, jsonEncode(_menu));

    // 3. Se actualiza el objeto restaurante en la lista global "restaurants"
    // Asumimos que cada restaurante tiene un campo 'menu' con este formato.
    final index = restaurants.indexWhere((r) => r['title'] == widget.restaurantTitle);
    if (index != -1) {
      restaurants[index]['menu'] = _menu;
    }

    // 4. Se prepara y retorna el objeto actualizado.
    final updatedRestaurant = Map<String, dynamic>.from(restaurants[index]);
    updatedRestaurant['menu'] = _menu;

    Navigator.pop(context, updatedRestaurant);
  }

  void _showAddFilterDialog() {
    final filterController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Añadir filtro"),
        content: TextField(
          controller: filterController,
          decoration: const InputDecoration(
            hintText: "Nombre del nuevo filtro",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
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
            child: const Text(
              "Añadir filtro",
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_menu.isEmpty || _categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Editar Menú"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentList =
        List<Map<String, dynamic>>.from(_menu[_selectedCategory] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Menú"),
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
            _buildCategorySelector(),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: currentList.length + 1,
                itemBuilder: (context, index) {
                  if (index < currentList.length) {
                    final dish = currentList[index];
                    return _buildDishItem(dish, index);
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: IconButtonCustom(
                        label: "Agregar Platillo",
                        icon: Icons.add,
                        onPressed: _addNewDish,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: "Guardar Cambios",
              isActive: true,
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == _categories.length) {
            return ChoiceChip(
              label: Row(
                children: const [
                  Icon(Icons.add, size: 18),
                  SizedBox(width: 4),
                  Text("Añadir filtro"),
                ],
              ),
              selected: false,
              selectedColor: Colors.brown,
              labelStyle: const TextStyle(color: Colors.black),
              onSelected: (_) => _showAddFilterDialog(),
            );
          } else {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: Colors.brown,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
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

  Widget _buildDishItem(Map<String, dynamic> item, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Ícono o imagen de comida rápida a la izquierda
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item['image'] != null && item['image'].isNotEmpty
                  ? Image.asset(
                      'assets/${item['image']}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.fastfood,
                        size: 80,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.fastfood,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 12),
            // Bloque de información del platillo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${item['price']}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            // Botón de eliminar (contenedor fijo)
            Container(
              width: 40,
              alignment: Alignment.center,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar platillo'),
                      content: const Text(
                          '¿Estás seguro de que deseas eliminar este platillo?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteDish(index);
                          },
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}