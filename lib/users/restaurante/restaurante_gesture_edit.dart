import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_aplication/items/items.dart';
import 'package:proyecto_aplication/data/maps.dart'; // ✅ Importa la lista de restaurantes

class RestaurantEditScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantEditScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<RestaurantEditScreen> createState() => _RestaurantEditScreenState();
}

class _RestaurantEditScreenState extends State<RestaurantEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.restaurant['title'] ?? "";
    _phoneController.text = widget.restaurant['phone'] ?? "";
    _directionController.text = widget.restaurant['direction'] ?? "";

    // Precarga horarios si existen
    final horarios = widget.restaurant['horariosDisponibles'];
    if (horarios is Map) {
      _startTimeController.text = horarios['inicio'] ?? "";
      _endTimeController.text = horarios['fin'] ?? "";
    }

    // Precarga servicios como cadena separada por comas
    if (widget.restaurant['services'] is List) {
      _servicesController.text = (widget.restaurant['services'] as List).join(", ");
    }

    // Precarga imagen actual
    _imagePath = widget.restaurant['image'] ?? "";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _phoneController.dispose();
    _directionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  // Método para seleccionar la hora
  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  // Método para seleccionar imagen
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final int index = restaurants.indexWhere(
        (r) => r['id'] == widget.restaurant['id'], // ✅ Guarda cambios por ID
      );

      if (index != -1) {
        restaurants[index] = {
          ...restaurants[index], // Mantiene valores previos
          'title': _titleController.text,
          'phone': _phoneController.text,
          'direction': _directionController.text,
          'horariosDisponibles': {
            'inicio': _startTimeController.text,
            'fin': _endTimeController.text,
          },
          'services': _servicesController.text
              .split(',')
              .map((service) => service.trim())
              .where((service) => service.isNotEmpty)
              .toList(),
          'image': _imagePath,
        };

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Restaurante actualizado correctamente.")),
        );

        Navigator.pop(context, restaurants[index]); // ✅ Envía el restaurante actualizado
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar Restaurante",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Título (ahora editable)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(), // ✅ Se agrega borde
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa un título.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Teléfono
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Teléfono",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa un teléfono.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Dirección
              TextFormField(
                controller: _directionController,
                decoration: const InputDecoration(
                  labelText: "Dirección",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa una dirección.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Horarios (Inicio y Fin en la misma línea)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startTimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Inicio",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _selectTime(_startTimeController),
                        ),
                      ),
                      onTap: () => _selectTime(_startTimeController),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _endTimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Fin",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () => _selectTime(_endTimeController),
                        ),
                      ),
                      onTap: () => _selectTime(_endTimeController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Campo Servicios
              TextFormField(
                controller: _servicesController,
                decoration: const InputDecoration(
                  labelText: "Servicios (separados por coma)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Botón para modificar la imagen
              IconButtonCustom(
                label: "Cambiar Imagen",
                icon: Icons.image,
                onPressed: _pickImage,
              ),
              const SizedBox(height: 20),

              // Botón para guardar los cambios
              CustomButton(
                label: "Guardar Cambios",
                isActive: true,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}