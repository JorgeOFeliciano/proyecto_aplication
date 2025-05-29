import 'package:flutter/material.dart';
import 'package:proyecto_aplication/items/items.dart';

class CambiarContrasenaScreen extends StatefulWidget {
  final Map<String, String> usuario;

  const CambiarContrasenaScreen({super.key, required this.usuario});

  @override
  State<CambiarContrasenaScreen> createState() => _CambiarContrasenaScreenState();
}

class _CambiarContrasenaScreenState extends State<CambiarContrasenaScreen> {
  final _formKey = GlobalKey<FormState>();
  String nuevaContrasena = '';
  String confirmarContrasena = '';
  bool cambiosRealizados = false;
  bool mostrarNuevaContrasena = false;
  bool mostrarConfirmarContrasena = false;

  bool tieneMayuscula = false;
  bool tieneNumero = false;
  bool minimoCaracteres = false;

  void detectarCambios(String value) {
    setState(() {
      nuevaContrasena = value;
      tieneMayuscula = nuevaContrasena.contains(RegExp(r'[A-Z]'));
      tieneNumero = nuevaContrasena.contains(RegExp(r'[0-9]'));
      minimoCaracteres = nuevaContrasena.length >= 6;
      cambiosRealizados = nuevaContrasena.isNotEmpty &&
          nuevaContrasena == confirmarContrasena &&
          tieneMayuscula &&
          tieneNumero &&
          minimoCaracteres;
    });
  }

  void guardarNuevaContrasena() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada correctamente')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'Introduce tu nueva contraseña',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              _buildPasswordField(
                'Nueva contraseña',
                nuevaContrasena,
                detectarCambios,
                mostrarNuevaContrasena,
                () {
                  setState(() {
                    mostrarNuevaContrasena = !mostrarNuevaContrasena;
                  });
                },
              ),

              _buildRequirement('Mínimo 6 caracteres', minimoCaracteres),
              _buildRequirement('Al menos una mayúscula', tieneMayuscula),
              _buildRequirement('Al menos un número', tieneNumero),

              const SizedBox(height: 30),

              _buildPasswordField(
                'Confirmar contraseña',
                confirmarContrasena,
                (value) {
                  setState(() {
                    confirmarContrasena = value;
                    cambiosRealizados = nuevaContrasena.isNotEmpty &&
                        nuevaContrasena == confirmarContrasena &&
                        tieneMayuscula &&
                        tieneNumero &&
                        minimoCaracteres;
                  });
                },
                mostrarConfirmarContrasena,
                () {
                  setState(() {
                    mostrarConfirmarContrasena = !mostrarConfirmarContrasena;
                  });
                },
              ),

              const SizedBox(height: 20),

              CustomButton(
                label: 'Guardar cambios',
                onPressed: cambiosRealizados ? guardarNuevaContrasena : null,
                isActive: cambiosRealizados,
              ),

              const SizedBox(height: 10),

              SimpleButton(
                label: 'Cancelar',
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: const Color.fromARGB(255, 121, 120, 120),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label,
      String value,
      Function(String) onChanged,
      bool mostrarContrasena,
      Function() toggleVisibilidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: !mostrarContrasena,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(mostrarContrasena ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibilidad,
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