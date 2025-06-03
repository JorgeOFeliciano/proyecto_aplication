import 'package:flutter/material.dart';
import 'package:proyecto_aplication/items/items.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final TextEditingController _suggestionController = TextEditingController();
  bool _isSubmitting = false;

  void _submitSuggestion() {
    final suggestion = _suggestionController.text.trim();

    if (suggestion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un comentario o sugerencia')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
        _suggestionController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sugerencia enviada con éxito. ¡Gracias!')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // ✅ Cierra la pantalla después de 1 segundo
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias y Comentarios', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "¡Tu opinión nos importa!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Déjanos tus comentarios y sugerencias para mejorar tu experiencia.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _suggestionController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: "Escribe tu sugerencia aquí...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : CustomButton(label: "Enviar Sugerencia", isActive: true, onPressed: _submitSuggestion),
          ],
        ),
      ),
    );
  }
}