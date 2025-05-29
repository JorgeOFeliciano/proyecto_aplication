import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';

// ✅ Función para calcular la cantidad de mesas disponibles por restaurante
int calcularMesasDisponibles(String restaurantTitle) {
  return tables.where((mesa) => mesa['title'] == restaurantTitle && mesa['status'] == 'Disponible').length;
}

// ✅ Función para calcular el promedio de calificaciones basado en opiniones
double calcularPromedioCalificaciones(String restaurantTitle) {
  final List<Map<String, dynamic>> reviews = opiniones.firstWhere(
    (opinion) => opinion['title'] == restaurantTitle,
    orElse: () => {'reviews': []},
  )['reviews'] as List<Map<String, dynamic>>;

  if (reviews.isEmpty) return 0.0; // Si no hay opiniones, devuelve 0.0

  final double sumRatings = reviews.map<double>((review) => review['rating'] as double).reduce((a, b) => a + b);
  return sumRatings / reviews.length; // ✅ Promedio de calificación
}

// ✅ Función para obtener el número total de favoritos por restaurante
int obtenerTotalFavoritos(String restaurantTitle) {
  return restaurants.firstWhere((restaurant) => restaurant['title'] == restaurantTitle, orElse: () => {'favorites': 0})['favorites'] as int;
}

// ✅ Tarjeta de Restaurante con Datos Dinámicos
class CustomRestaurantCard extends StatelessWidget {
  final String? imagePath;
  final String title;
  final int seats;
  final int totalSeats;
  final int rating;
  final int maxRating;
  final int favorites;
  final VoidCallback onTap;

  final String? reservationDate;
  final String? reservationTime;
  final String? tableNumber;
  final String? reservationStatus;

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
    this.reservationDate,
    this.reservationTime,
    this.tableNumber,
    this.reservationStatus,
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
                  color: Colors.black.withOpacity(0.1),
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
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.store, size: 99, color: Colors.grey),
                        )
                      : const Icon(Icons.store, size: 99, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                Text(
                  title.toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.chair_alt, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text("$seats/$totalSeats", style: const TextStyle(color: Colors.grey))),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(child: Text("$rating/$maxRating", style: const TextStyle(color: Colors.grey))),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text("$favorites", style: const TextStyle(color: Colors.grey))),
                  ],
                ),
                const SizedBox(height: 16),

                if (reservationDate != null || reservationTime != null || tableNumber != null) ...[
                  const Divider(thickness: 1),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(reservationDate ?? "Sin fecha", style: const TextStyle(color: Colors.grey))),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text(reservationTime ?? "Sin hora", style: const TextStyle(color: Colors.grey))),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.table_bar, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(child: Text("Mesa ${tableNumber ?? "No asignada"}", style: const TextStyle(color: Colors.grey))),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ Generación de tarjetas de restaurante con datos dinámicos
class RestaurantCardItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const RestaurantCardItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String restaurantTitle = data['title'];

    return CustomRestaurantCard(
      imagePath: data['image'],
      title: restaurantTitle,
      seats: calcularMesasDisponibles(restaurantTitle), // ✅ Mesas dinámicas
      totalSeats: data['totalSeats'],
      rating: calcularPromedioCalificaciones(restaurantTitle).toInt(), // ✅ Promedio dinámico
      maxRating: 5,
      favorites: obtenerTotalFavoritos(restaurantTitle), // ✅ Conteo de favoritos
      reservationDate: data['reservationDate'],
      reservationTime: data['reservationTime'],
      tableNumber: data['tableNumber'],
      reservationStatus: data['reservationStatus'],
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user_rest_det',
          arguments: {
            'title': restaurantTitle,
            'image': data['image'],
            'info': data['info'],
            'image-map': data['image-map'],
            'direction': data['direction'],
          },
        );
      },
    );
  }
}