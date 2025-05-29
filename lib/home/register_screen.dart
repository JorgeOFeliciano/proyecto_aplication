import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Botón de regreso
            const Positioned(
              top: 10,
              left: 10,
              child: BackButton(),
            ),

            // Contenido principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'TABLESMART',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'REGISTRARSE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('NOMBRE'),
                    const SizedBox(height: 15),
                    _buildTextField('APELLIDOS'),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('EDAD')),
                        const SizedBox(width: 15),
                        Expanded(child: _buildTextField('SEXO')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildTextField('TELEFONO'),
                    const SizedBox(height: 15),
                    _buildTextField('CORREO'),
                    const SizedBox(height: 15),
                    _buildTextField('CONTRASEÑA', isPassword: true),
                    const SizedBox(height: 15),
                    _buildTextField('CONFIRMAR CONTRASEÑA', isPassword: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción de registro
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF826B56), // Marrón
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'REGISTRARSE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para campos de texto
  static Widget _buildTextField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
