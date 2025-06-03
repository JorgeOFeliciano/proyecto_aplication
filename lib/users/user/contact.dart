import 'package:flutter/material.dart';
import 'package:proyecto_aplication/items/items.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  void _submitMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu mensaje')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
        _messageController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensaje enviado con éxito. ¡Nos pondremos en contacto!')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacto', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "¿Necesitas ayuda?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Envíanos tu mensaje y te responderemos lo antes posible.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Escribe tu mensaje aquí...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : CustomButton(label: "Enviar Mensaje", isActive: true, onPressed: _submitMessage),
          ],
        ),
      ),
    );
  }
}