import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';

// ✅ Función para calcular la cantidad de mesas disponibles por restaurante (por ID)
int calcularMesasDisponibles(String restaurantId) {
  return tables.where(
    (mesa) => mesa['restaurantId'] == restaurantId && mesa['status'] == 'Disponible',
  ).length;
}

// ✅ Función para calcular el promedio de calificaciones basado en opiniones (por ID)
double calcularPromedioCalificaciones(String restaurantId) {
  final dynamic rawReviews = opiniones.firstWhere(
    (opinion) => opinion['restaurantId'] == restaurantId,
    orElse: () => {'reviews': []},
  )['reviews'];

  final List<Map<String, dynamic>> reviews = (rawReviews as List<dynamic>)
      .map((item) => item as Map<String, dynamic>)
      .toList();

  if (reviews.isEmpty) return 0.0;

  final double sumRatings = reviews
      .map<double>((review) => review['rating'] as double)
      .reduce((a, b) => a + b);

  return sumRatings / reviews.length;
}

// ✅ Función para obtener el número total de favoritos por restaurante (por ID)
int obtenerTotalFavoritos(String restaurantId) {
  return restaurants.firstWhere(
    (restaurant) => restaurant['id'] == restaurantId,
    orElse: () => {'favorites': 0},
  )['favorites'] as int;
}

// ✅ Tarjeta de Restaurante sin información de horarios ni reservas
class CustomRestaurantCard extends StatelessWidget {
  final String? imagePath;
  final String title;
  final int seats;
  final int totalSeats;
  final int rating;
  final int maxRating;
  final int favorites;
  final VoidCallback onTap;

  const CustomRestaurantCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.seats,
    required this.totalSeats,
    required this.rating,
    required this.maxRating,
    required this.favorites,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 2,
                  color: Colors.black.withAlpha(25),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imagePath != null && imagePath!.isNotEmpty
                      ? Image.asset(
                          imagePath!,
                          width: 120,
                          height: 99,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.store, size: 99, color: Colors.grey),
                        )
                      : const Icon(Icons.store, size: 99, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.chair_alt, "$seats/$totalSeats", Colors.blueGrey),
                _buildInfoRow(Icons.star, "$rating/$maxRating", Colors.amber),
                _buildInfoRow(Icons.favorite, "$favorites", Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String info, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            info,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}

class RestaurantCardItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const RestaurantCardItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String restaurantId = data['id'];

    return CustomRestaurantCard(
      imagePath: data['image'],
      title: data['title'],
      seats: calcularMesasDisponibles(restaurantId),
      totalSeats: data['totalSeats'] ?? 0,
      rating: calcularPromedioCalificaciones(restaurantId).toInt(),
      maxRating: 5,
      favorites: obtenerTotalFavoritos(restaurantId),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user_rest_det',
          arguments: {
            'id': restaurantId,
            'title': data['title'],
            'image': data['image'],
            'image-map': data['image-map'],
            'direction': data['direction'],
            'horariosDisponibles': data['horariosDisponibles'],
            'services': data['services'],
          },
        );
      },
    );
  }
}
