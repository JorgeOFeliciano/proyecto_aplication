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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(), // Utiliza la clase CustomDrawer
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return CustomTopSearchBar(
                  onMenuTap: () => Scaffold.of(context).openDrawer(), // Abre el drawer correctamente
                  onBack: () => Navigator.pop(context), // Permite regresar si no es pantalla principal
                  onCartTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListShops()), // Redirige al historial de compras
                    );
                  },
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
            // Lista de restaurantes en un grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 280,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return RestaurantCardItem(data: restaurants[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}