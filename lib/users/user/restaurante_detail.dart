import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/items/drawer.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/users/user/shop_lista.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proyecto_aplication/items/top_bar.dart';

int calcularMesasDisponibles(String restaurantTitle) {
  return tables.where((mesa) => mesa['title'] == restaurantTitle && mesa['status'] == 'Disponible').length;
}

double calcularPromedioCalificaciones(String restaurantTitle) {
  final List<Map<String, dynamic>> reviews = opiniones.firstWhere(
    (opinion) => opinion['title'] == restaurantTitle,
    orElse: () => {'reviews': []},
  )['reviews'] as List<Map<String, dynamic>>;

  if (reviews.isEmpty) return 0.0; // Si no hay opiniones, devuelve 0.0

  final double sumRatings = reviews.map<double>((review) => review['rating'] as double).reduce((a, b) => a + b);
  return sumRatings / reviews.length; // ✅ Promedio de calificación
}

int obtenerTotalFavoritos(String restaurantTitle) {
  return restaurants.firstWhere((restaurant) => restaurant['title'] == restaurantTitle, orElse: () => {'favorites': 0})['favorites'] as int;
}

// Función para alternar el estado de favorito de un restaurante
void actualizarFavorito(String restaurantTitle) {
  for (var i = 0; i < restaurants.length; i++) {
    if (restaurants[i]['title'] == restaurantTitle) {
      // Alterna isFavorite: si es null o false se vuelve true, y viceversa
      restaurants[i]['isFavorite'] = !(restaurants[i]['isFavorite'] ?? false);
      break;
    }
  }
}

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({super.key});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  @override
  Widget build(BuildContext context) {
    // Se reciben los argumentos pasados mediante Navigator
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Map<String, dynamic> restaurantData = restaurants.firstWhere(
      (restaurant) => restaurant['title'] == args['title'],
      orElse: () => {},
    );
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomTopSearchBar(
              onMenuTap: () => Scaffold.of(context).openDrawer(),
              onCartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListShops()),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildImage(restaurantData),
                    const SizedBox(height: 10),
                    _buildTitle(restaurantData['title'] ?? "Restaurante"),
                    const SizedBox(height: 20),
                    _buildAdditionalInfo(context, restaurantData),
                    const SizedBox(height: 20),
                    _buildButtons(context, restaurantData),
                    const SizedBox(height: 20),
                    _buildReviews(restaurantData),
                    const SizedBox(height: 20),
                    _buildLocation(restaurantData),
                    const SizedBox(height: 20),
                    _buildServices(restaurantData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(), // Si deseas el Drawer en esta pantalla también
    );
  }

  /// Construye la imagen principal del restaurante con un botón para marcar favorito
  Widget _buildImage(Map<String, dynamic>? restaurantData) {
    bool isFavorite = restaurantData?['isFavorite'] ?? false;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: restaurantData?['image'] != null &&
                  restaurantData?['image'].isNotEmpty
              ? Image.asset(
                  restaurantData!['image'],
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _defaultRestaurantIcon(),
                )
              : _defaultRestaurantIcon(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                actualizarFavorito(restaurantData?['title'] ?? '');
              });
            },
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  /// Icono por defecto si no se dispone de imagen
  Widget _defaultRestaurantIcon() {
    return Container(
      height: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.store, size: 100, color: Colors.brown),
    );
  }

  /// Muestra el título del restaurante
  Widget _buildTitle(String? title) {
    return Text(
      title ?? "Restaurante",
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  /// Muestra información adicional como horario, pago y promociones
  Widget _buildAdditionalInfo(BuildContext context, Map<String, dynamic>? restaurantData) {
    final Map<String, dynamic> restaurantInfo = restaurants.firstWhere(
      (restaurant) => restaurant['title'] == restaurantData?['title'],
      orElse: () => {'horariosDisponibles': {'inicio': '00:00', 'fin': '00:00'}, 'pago': 'No disponible', 'promociones': 'Sin promociones'},
    );

    final Map<String, String> horariosDisponibles = restaurantInfo['horariosDisponibles'] as Map<String, String>;
    final String horario = "${horariosDisponibles['inicio']} - ${horariosDisponibles['fin']}";
    final String pago = restaurantInfo['pago'] ?? "No disponible";
    final String promociones = restaurantInfo['promociones'] ?? "Sin promociones";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _infoBlock(Icons.access_time, "Horario", horario),
        _infoBlock(Icons.payment, "Pago", pago),
        _infoBlock(Icons.local_offer, "Promo", promociones),
      ],
    );
  }


  /// Bloque de información con ícono y texto
  Widget _infoBlock(IconData icon, String label, String data) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.brown, size: 30),
          const SizedBox(height: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(data, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Muestra los botones para realizar acciones como ver mesas, menú, o llamar
  Widget _buildButtons(BuildContext context, Map<String, dynamic>? restaurantData) {
    return Column(
      children: [
        SimpleButton(
          label: "MESAS",
          onPressed: () =>
              Navigator.pushNamed(context, '/tables', arguments: {'title': restaurantData?['title']}),
          backgroundColor: const Color(0xFF826B56),
          textColor: Colors.white,
        ),
        const SizedBox(height: 10),
        SimpleButton(
          label: "MENÚ",
          onPressed: () =>
              Navigator.pushNamed(context, '/menu', arguments: {'title': restaurantData?['title']}),
          backgroundColor: const Color(0xFF826B56),
          textColor: Colors.white,
        ),
        const SizedBox(height: 10),
        if (restaurantData?.containsKey('phone') ?? false)
          SimpleButton(
            label: "LLAMAR",
            onPressed: () => launchUrl(Uri.parse("tel:${restaurantData?['phone']}")),
            backgroundColor: Colors.green,
            textColor: Colors.white,
          ),
      ],
    );
  }
}


Widget _buildLocation(Map<String, dynamic>? restaurantData) {
    return Column(
      children: [
        const Text("Ubicación", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _infoRow(Icons.location_on, "Dirección", restaurantData?['direction'], fontSize: 18),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: restaurantData?['image-map'] != null && restaurantData?['image-map'].isNotEmpty
              ? Image.asset(restaurantData!['image-map'], height: 100, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _defaultLocationIcon())
              : _defaultLocationIcon(),
        ),
      ],
    );
  }

Widget _defaultLocationIcon() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.location_on, size: 60, color: Colors.blue),
    );
  }

Widget _buildReviews(Map<String, dynamic>? restaurantData) {
  if (restaurantData == null || !restaurantData.containsKey('title')) {
    return const Text("No se encontró el restaurante.");
  }

  final dynamic matched = opiniones.firstWhere(
    (opinion) => opinion['title'] == restaurantData['title'],
    orElse: () => {'reviews': []},
  );

  final List<dynamic> rawReviews = matched['reviews'] ?? [];

  final List<Map<String, dynamic>> reviews = rawReviews
      .whereType<Map<String, dynamic>>()
      .toList();


  return Column(
    children: [
      const Text("Opiniones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      if (reviews.isNotEmpty)
        ...reviews.map<Widget>(
          (review) => Column(
            children: [
              Row(
                children: [
                  Text(review['user'] ?? "Usuario desconocido", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  RatingBarIndicator(
                    rating: review['rating'] ?? 0.0,
                    itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 20,
                  ),
                ],
              ),
              Text(review['comment'] ?? "Sin comentarios"),
              const SizedBox(height: 10),
            ],
          ),
        ),
      if (reviews.isEmpty) const Text("Aún no hay opiniones para este restaurante."),
    ],
  );
}

  Widget _buildServices(Map<String, dynamic>? restaurantData) {
    final List availableServices = restaurants
        .firstWhere(
          (resto) => resto['id'] == restaurantData?['id'], // ✅ Buscar por ID
          orElse: () => {'services': <String>[]}, // ✅ Asegurar lista vacía si no se encuentra
        )['services'] as List<dynamic>;

    return Column(
      children: [
        const Text("Servicios", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableServices.map<Widget>(
            (service) => Chip(label: Text(service.toString()), avatar: const Icon(Icons.check_circle, color: Colors.green)),
          ).toList(),
        ),
        if (availableServices.isEmpty)
          const Text("No hay servicios disponibles para este restaurante."),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String? data, {double fontSize = 16}) {
  return Row(
    children: [
      Icon(icon, color: Colors.brown),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          '$label: ${data ?? "No disponible"}',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    ],
  );
}