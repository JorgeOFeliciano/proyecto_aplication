import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/home/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:proyecto_aplication/items/items.dart';

class CreateRestaurantScreen extends StatefulWidget {
  const CreateRestaurantScreen({super.key});

  @override
  State<CreateRestaurantScreen> createState() => _CreateRestaurantScreenState();
}

class _CreateRestaurantScreenState extends State<CreateRestaurantScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _totalSeatsController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final List<String> _services = [];
  File? _mainImage;
  File? _mapImage;
  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;

  @override
  void initState() {
    super.initState();
    _clearSavedRestaurant(); // Limpia los datos guardados previos
  }

  Future<void> _clearSavedRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedRestaurant');
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    return time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : '--:--';
  }

  void _saveRestaurantData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = await AuthService.getCurrentUserId();

    final Map<String, dynamic> newRestaurant = {
      'id': 'R${DateTime.now().millisecondsSinceEpoch}',
      'ownerId': userId, // ✅ Asigna el ID del usuario actual
      'title': _nameController.text,
      'direction': _locationController.text,
      'image': _mainImage?.path ?? 'assets/default.png',
      'image-map': _mapImage?.path ?? 'assets/default_map.png',
      'totalSeats': int.tryParse(_totalSeatsController.text) ?? 0,
      'seats': int.tryParse(_totalSeatsController.text) ?? 0,
      'rating': 0,
      'favorites': 0,
      'isFavorite': false,
      'phone': _phoneController.text,
      'horariosDisponibles': {
        'inicio': _formatTimeOfDay(_openingTime),
        'fin': _formatTimeOfDay(_closingTime),
      },
      'services': _services,
    };

    await prefs.setString('savedRestaurant', jsonEncode(newRestaurant));
    restaurants.add(newRestaurant);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Restaurante creado con éxito')),
      );
      Navigator.pop(context, true);
    }
  }

  void _addService(String serviceInput) {
    final String service = serviceInput.trim();

    if (service.isNotEmpty && !_services.contains(service)) {
      setState(() {
        _services.add(service);
      });
    }

    _serviceController.clear();
  }

  void _pickImage(bool isMap) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isMap) {
          _mapImage = File(image.path);
        } else {
          _mainImage = File(image.path);
        }
      });
    }
  }

  void _selectTime(bool isOpening) async {
    final TimeOfDay initial = isOpening
        ? (_openingTime ?? const TimeOfDay(hour: 8, minute: 0))
        : (_closingTime ?? const TimeOfDay(hour: 20, minute: 0));

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      setState(() {
        if (isOpening) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final openingLabel = 'Hora Apertura (${_formatTimeOfDay(_openingTime)})';
    final closingLabel = 'Hora Cierre (${_formatTimeOfDay(_closingTime)})';

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Restaurante')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Restaurante'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Ubicación'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _totalSeatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total de Asientos'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: IconButtonCustom(
                      label: openingLabel,
                      icon: Icons.schedule,
                      onPressed: () => _selectTime(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: IconButtonCustom(
                      label: closingLabel,
                      icon: Icons.schedule,
                      onPressed: () => _selectTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              IconButtonCustom(
                label: "Agregar Imagen",
                icon: Icons.image,
                onPressed: () => _pickImage(false),
              ),
              IconButtonCustom(
                label: "Agregar Imagen de Mapa",
                icon: Icons.map,
                onPressed: () => _pickImage(true),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _serviceController,
                      decoration: const InputDecoration(
                        labelText: 'Añadir Servicio',
                        hintText: 'Ej: Área temática, Arcade...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: IconButtonCustom(
                      label: "Añadir",
                      icon: Icons.add,
                      onPressed: () => _addService(_serviceController.text),
                    ),
                  ),
                ],
              ),

              Wrap(
                spacing: 8.0,
                children: _services.map((service) => Chip(label: Text(service))).toList(),
              ),
              const SizedBox(height: 20),
              IconButtonCustom(
                label: "Guardar Restaurante",
                icon: Icons.save,
                onPressed: _saveRestaurantData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
