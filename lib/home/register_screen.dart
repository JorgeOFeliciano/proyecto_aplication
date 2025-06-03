import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_aplication/data/maps.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _codigoPostalController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();

  String _sexoSelected = "Masculino";
  DateTime? _selectedDate;

  bool _tieneMayuscula = false;
  bool _tieneNumero = false;
  bool _minimoCaracteres = false;
  bool _cumpleRequisitos = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // ✅ Usa la fecha actual si no hay una seleccionada
      firstDate: DateTime(1900), // ✅ Permite seleccionar desde el año 1900
      lastDate: DateTime.now(), // ✅ Bloquea fechas futuras
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _register() {
    if (_selectedDate == null ||
        _nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _codigoPostalController.text.isEmpty ||
        _ciudadController.text.isEmpty ||
        _paisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    String userId = 'U${(usuarios.length + 1).toString().padLeft(3, '0')}';

    usuarios.add({
      'id': userId,
      'nombre': _nombreController.text,
      'apellido': _apellidoController.text,
      'username': _usernameController.text,
      'correo': _correoController.text,
      'password': _passwordController.text,
      'fechaRegistro': DateFormat('MMMM yyyy', 'es_ES').format(DateTime.now()), // ✅ Fecha en formato "Mes Año"
      'telefono': _telefonoController.text,
      'fechaNacimiento': DateFormat('dd/MM/yyyy').format(_selectedDate!),
      'codigoPostal': _codigoPostalController.text,
      'ciudad': _ciudadController.text,
      'pais': _paisController.text,
      'favoritos': '0',
      'reseñas': '0',
      'seguidores': '0',
      'puntos': '0',
      'visitas': '0',
      'sexo': _sexoSelected,
      'tieneRestaurante': false, // ✅ Se asume que los nuevos usuarios no tienen restaurante por defecto
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario registrado con éxito')),
    );
    Navigator.pop(context);
  }


  // ✅ Método para validar la contraseña en tiempo real
  void _validarContrasena(String value) {
    setState(() {
      _tieneMayuscula = value.contains(RegExp(r'[A-Z]'));
      _tieneNumero = value.contains(RegExp(r'[0-9]'));
      _minimoCaracteres = value.length >= 6;
      _cumpleRequisitos = _tieneMayuscula && _tieneNumero && _minimoCaracteres &&
          value == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Encabezado con título centrado y botón de regreso
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      'TABLESMART',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Contenido desplazable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text('REGISTRARSE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    _buildTextField('Nombre', controller: _nombreController),
                    const SizedBox(height: 15),
                    _buildTextField('Apellidos', controller: _apellidoController),
                    const SizedBox(height: 15),
                    _buildTextField('Username', controller: _usernameController),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // ✅ Igual al resto de los campos
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _selectedDate == null
                                    ? 'Fecha de Nacimiento (dd/MM/yyyy)'
                                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(child: _buildSexoDropdown()), // ✅ Ya tiene el mismo fondo y bordes
                      ],
                    ),

                    const SizedBox(height: 15),
                    _buildTextField('Teléfono', controller: _telefonoController, keyboardType: TextInputType.phone),
                    const SizedBox(height: 15),
                    _buildTextField('Código Postal', controller: _codigoPostalController),
                    const SizedBox(height: 15),
                    _buildTextField('Ciudad', controller: _ciudadController),
                    const SizedBox(height: 15),
                    _buildTextField('País', controller: _paisController),
                    const SizedBox(height: 15),
                    _buildTextField('Correo', controller: _correoController, keyboardType: TextInputType.emailAddress),

                    const SizedBox(height: 15),

                    // ✅ Campo de contraseña con validación
                    _buildPasswordField('Contraseña', _passwordController, _validarContrasena),
                    _buildRequirement('Mínimo 6 caracteres', _minimoCaracteres),
                    _buildRequirement('Al menos una mayúscula', _tieneMayuscula),
                    _buildRequirement('Al menos un número', _tieneNumero),

                    const SizedBox(height: 15),

                    // ✅ Confirmación de contraseña con validación
                    _buildPasswordField('Confirmar Contraseña', _confirmPasswordController, (value) {
                      setState(() {
                        _cumpleRequisitos = _passwordController.text.isNotEmpty &&
                            _passwordController.text == value &&
                            _tieneMayuscula &&
                            _tieneNumero &&
                            _minimoCaracteres;
                      });
                    }),

                    const SizedBox(height: 30),

                    // ✅ Botón "Registrarse" habilitado solo si la contraseña cumple los requisitos
                    ElevatedButton(
                      onPressed: _cumpleRequisitos ? _register : null,
                      style: ElevatedButton.styleFrom(backgroundColor: _cumpleRequisitos ? const Color(0xFF826B56) : Colors.grey),
                      child: const Text('REGISTRARSE', style: TextStyle(color: Colors.white)),
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

  Widget _buildPasswordField(String label, TextEditingController controller, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSexoDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200], // ✅ Igual al resto de los campos
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sexoSelected,
          items: const [
            DropdownMenuItem(value: "Masculino", child: Text("Masculino")),
            DropdownMenuItem(value: "Femenino", child: Text("Femenino")),
          ],
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _sexoSelected = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false, TextEditingController? controller, TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200], // ✅ Igual al campo de contraseña
        labelText: hint,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

  Widget _buildRequirement(String text, bool cumplido) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            cumplido ? Icons.check_circle : Icons.cancel,
            color: cumplido ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
