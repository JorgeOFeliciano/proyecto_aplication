import 'package:flutter/material.dart';
import 'package:proyecto_aplication/card/card_restaurant.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/drawer.dart';
import 'package:proyecto_aplication/items/top_bar.dart';
import 'package:proyecto_aplication/users/user/shop_lista.dart';

class Restaurante extends StatefulWidget {
  const Restaurante({super.key});

  @override
  State<Restaurante> createState() => _RestauranteState();
}

class _RestauranteState extends State<Restaurante> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> filters = ['Cerca', 'Abiertos ahora', 'Comida rápida', 'Promociones'];

  List<Map<String, dynamic>> filteredRestaurants = restaurants; // ✅ Lista filtrada inicial

  // ✅ Función para filtrar restaurantes según la búsqueda
  void _filterRestaurants(String query) {
    setState(() {
      filteredRestaurants = restaurants.where((restaurant) {
        return restaurant['title'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return CustomTopSearchBar(
                  onMenuTap: () => Scaffold.of(context).openDrawer(),
                  onBack: () => Navigator.pop(context),
                  onCartTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListShops()),
                    );
                  },
                  onSearchChanged: _filterRestaurants, // ✅ Conecta la barra de búsqueda con el filtro
                );
              },
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return FilterChip(
                    label: Text(filters[index]),
                    selected: false,
                    onSelected: (selected) {},
                  );
                },
              ),
            ),
            // ✅ Mostrar la lista filtrada en el grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 280,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredRestaurants.length, // ✅ Usar la lista filtrada
                itemBuilder: (context, index) {
                  return RestaurantCardItem(data: filteredRestaurants[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}