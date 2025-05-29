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

  if (reviews.isEmpty) return 0.0;

  final double sumRatings = reviews.map<double>((review) => review['rating'] as double).reduce((a, b) => a + b);
  return sumRatings / reviews.length;
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
                  color: Colors.black.withAlpha(25), // 0.1 * 255 ≈ 25
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
                const SizedBox(height: 16),
                if (reservationDate != null || reservationTime != null || tableNumber != null) ...[
                  const Divider(thickness: 1),
                  _buildInfoRow(Icons.calendar_today, reservationDate ?? "Sin fecha", Colors.teal),
                  _buildInfoRow(Icons.access_time, reservationTime ?? "Sin hora", Colors.orange),
                  _buildInfoRow(Icons.table_bar, "Mesa ${tableNumber ?? "No asignada"}", Colors.green),
                ],
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
        Expanded(child: Text(info, style: TextStyle(color: Colors.grey.shade500))), // ✅ Texto en gris claro
      ],
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
      seats: calcularMesasDisponibles(restaurantTitle),
      totalSeats: data['totalSeats'],
      rating: calcularPromedioCalificaciones(restaurantTitle).toInt(),
      maxRating: 5,
      favorites: obtenerTotalFavoritos(restaurantTitle),
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