import 'package:flutter/material.dart';
import 'package:proyecto_aplication/card/card_restaurant.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/drawer.dart';
import 'package:proyecto_aplication/items/top_bar.dart'; 

class Restaurante extends StatefulWidget {
  const Restaurante({Key? key}) : super(key: key);

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
      drawer: const CustomDrawer(), // ✅ Usa la clase CustomDrawer
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 Barra superior con botón de menú
            CustomTopSearchBar(
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              onLocationTap: () {},
            ),

            // 🌟 Filtros horizontales
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

            // 🌟 Lista de restaurantes
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
