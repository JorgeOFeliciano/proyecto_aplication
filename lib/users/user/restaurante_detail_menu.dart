import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  late Map<String, List<Map<String, dynamic>>> menu;
  late List<String> categories;
  String selectedCategory = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Obtener los argumentos y restaurante
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String restaurantTitle = args['title'];

    // ✅ Generar menú usando el título del restaurante
    final generatedMenu = generateMenu(restaurantTitle);
    menu = generatedMenu[restaurantTitle] ?? {};

    categories = menu.keys.toList();

    if (categories.isNotEmpty) {
      selectedCategory = categories.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dishes = menu.containsKey(selectedCategory) ? menu[selectedCategory]! : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySelector(),
          const Divider(),
          Expanded(
            child: dishes.isEmpty
                ? const Center(
                    child: Text("No hay platillos en esta categoría", style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: dishes.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final item = dishes[index];
                      return _buildDishItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            selectedColor: Colors.brown,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            onSelected: (_) {
              setState(() {
                selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildDishItem(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item['image'] != null && item['image'].isNotEmpty
                  ? Image.asset(
                      'assets/${item['image']}', // Asegúrate de que los assets estén bien cargados
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.fastfood, size: 80, color: Colors.grey),
                    )
                  : const Icon(Icons.fastfood, size: 80, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(item['description'], style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text('\$${item['price']}', style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['name']} añadido al carrito')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
