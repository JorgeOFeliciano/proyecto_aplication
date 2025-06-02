    import 'package:flutter/material.dart';
    import 'package:proyecto_aplication/data/maps.dart';
    import 'package:proyecto_aplication/items/items.dart';
    import 'package:proyecto_aplication/users/restaurante/restaurante_gesture_edit.dart';
    import 'package:proyecto_aplication/users/restaurante/restaurante_gesture_menu.dart';
    import 'package:proyecto_aplication/users/restaurante/restaurante_gesture_tables.dart';

    class RestaurantManageScreen extends StatefulWidget {
      final Map<String, dynamic> restaurant;

      const RestaurantManageScreen({super.key, required this.restaurant});

      @override
      State<RestaurantManageScreen> createState() => _RestaurantManageScreenState();
    }

    class _RestaurantManageScreenState extends State<RestaurantManageScreen> {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.restaurant['title'] ?? "Restaurante"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildImage(widget.restaurant),
                        const SizedBox(height: 10),
                        _buildTitle(widget.restaurant['title']),
                        const SizedBox(height: 20),
                        _buildInfoRows(context, widget.restaurant),
                        const SizedBox(height: 20),
                        _buildServices(widget.restaurant),
                        const SizedBox(height: 20),
                        _buildLocation(widget.restaurant), // ✅ Se mantiene _buildLocation()
                        const SizedBox(height: 20),
                        _buildManageButtons(),
                        const SizedBox(height: 10),
                        IconButtonCustom(
                          label: "Eliminar Restaurante",
                          icon: Icons.delete,
                          onPressed: () {
                            _confirmDeleteRestaurant();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildManageButtons() {
        return Column(
          children: [
            IconButtonCustom(
              label: "Editar Restaurante",
              icon: Icons.edit,
              onPressed: () async {
                final updatedRestaurant = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantEditScreen(restaurant: widget.restaurant),
                  ),
                );

                if (updatedRestaurant != null && updatedRestaurant is Map<String, dynamic>) {
                  setState(() {
                    widget.restaurant.clear();
                    widget.restaurant.addAll(updatedRestaurant); // ✅ Refleja los cambios en pantalla
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            IconButtonCustom(
              label: "Editar Menú",
              icon: Icons.restaurant_menu,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMenuScreen(
                      restaurantTitle: widget.restaurant['title'],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }
      
      
      Widget _buildImage(Map<String, dynamic>? restaurantData) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: restaurantData?['image'] != null &&
                  restaurantData?['image'].isNotEmpty
              ? Image.asset(restaurantData!['image'],
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _defaultRestaurantIcon())
              : _defaultRestaurantIcon(),
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

      Widget _buildTitle(String? title) {
        return Text(
          title ?? "Restaurante",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
      }

      Widget _buildInfoRows(BuildContext context, Map<String, dynamic>? restaurantData) {
        final Map<String, dynamic> restaurantInfo = restaurants.firstWhere(
          (restaurant) => restaurant['title'] == restaurantData?['title'],
          orElse: () => {
            'phone': 'No disponible',
            'direction': 'No disponible',
            'horariosDisponibles': {'inicio': '00:00', 'fin': '00:00'}
          },
        );

        final String telefono = restaurantInfo['phone'] ?? "No disponible";
        final String direccion = restaurantInfo['direction'] ?? "No disponible";
        final Map<String, String> horariosDisponibles =
            restaurantInfo['horariosDisponibles'] as Map<String, String>;
        final String horario =
            "${horariosDisponibles['inicio']} - ${horariosDisponibles['fin']}";

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoBlock(Icons.phone, "Teléfono", telefono),
            _infoBlock(Icons.location_on, "Dirección", direccion),
            _infoBlock(Icons.access_time, "Horario", horario),
          ],
        );
      }

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

      Widget _buildLocation(Map<String, dynamic>? restaurantData) {
        return Column(
          children: [
            const Text("Ubicación", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.location_on, "Dirección", restaurantData?['direction']),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: restaurantData?['image-map'] != null &&
                      restaurantData?['image-map'].isNotEmpty
                  ? Image.asset(
                      restaurantData!['image-map'],
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultLocationIcon(),
                    )
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

      Widget _buildInfoRow(IconData icon, String label, String? value) {
        return Row(
          children: [
            Icon(icon, color: Colors.brown),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label: ${value ?? "No disponible"}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      }

    void _confirmDeleteRestaurant() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Restaurante"),
        content: Text(
          "¿Estás seguro de que deseas eliminar \"${widget.restaurant['title']}\"? "
          "Esta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              _deleteRestaurant();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

    void _deleteRestaurant() {
      final index = restaurants.indexWhere(
        (r) => r['id'] == widget.restaurant['id'], // ✅ Eliminando por ID
      );

      if (index != -1) {
        setState(() {
          restaurants.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Restaurante eliminado correctamente.")),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, true); // ✅ Retorna "true" al cerrar pantalla
        });
      }
    }
  }