import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/users/user/restaurante_detail_carrito_screen.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  late Map<String, List<Map<String, dynamic>>> menu;
  late List<String> categories;
  String selectedCategory = '';
  late String restaurantTitle;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  final Map<String, dynamic> args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

  final String restaurantId = args['id'];

  final restaurantData = restaurants.firstWhere(
    (restaurant) => restaurant['id'] == restaurantId,
    orElse: () => {
      'id': '0',
      'title': 'Restaurante Desconocido',
      'image': 'default.png',
      'seats': 0,
      'totalSeats': 0,
      'rating': 0,
      'favorites': 0,
      'phone': 0,
      'image-map': 'default_map.png',
      'direction': 'Dirección no disponible',
      'horariosDisponibles': {
        'inicio': TimeOfDay(hour: 0, minute: 0),
        'fin': TimeOfDay(hour: 0, minute: 0),
      },
      'services': [],
      'isFavorite': false,
    },
  );

  restaurantTitle = restaurantData['title'];

  if (allMenus.containsKey(restaurantTitle)) {
    menu = allMenus[restaurantTitle]!;
  } else {
    final generatedMenu = generateMenu(restaurantTitle);
    allMenus[restaurantTitle] = generatedMenu[restaurantTitle] ?? {};
    menu = allMenus[restaurantTitle]!;
  }

  categories = menu.keys.toList();
  if (categories.isNotEmpty) {
    selectedCategory = categories.first;
  }
}


  @override
  Widget build(BuildContext context) {
    final dishes =
        menu.containsKey(selectedCategory) ? menu[selectedCategory]! : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Menú - $restaurantTitle'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              final pedidoRestaurante = carritoCompras
                  .where((item) => item['restaurant'] == restaurantTitle)
                  .toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PedidoScreen(
                    restaurantName: restaurantTitle,
                    pedido: pedidoRestaurante,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySelector(),
          const Divider(),
          Expanded(
            child: dishes.isEmpty
                ? const Center(
                    child: Text("No hay platillos en esta categoría",
                        style: TextStyle(color: Colors.grey)),
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
                      'assets/${item['image']}',
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
                  Text(item['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(item['description'],
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text('\$${item['price']}',
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                setState(() {
                  carritoCompras.add({
                    'restaurant': restaurantTitle,
                    'name': item['name'],
                    'price': item['price'],
                    'quantity': 1,
                  });
                });

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