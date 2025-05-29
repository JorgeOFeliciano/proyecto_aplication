import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Preguntas Frecuentes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _faqItem('¿Cómo cambio mi contraseña?', 'Ve a Configuración y modifica tu contraseña en el formulario.'),
          _faqItem('¿Cómo elimino mi cuenta?', 'Actualmente no puedes eliminarla directamente, contáctanos.'),
          _faqItem('¿Por qué no puedo iniciar sesión?', 'Verifica tu correo y contraseña o intenta restablecerla.'),
          _faqItem('¿Puedo modificar mi nombre de usuario?', 'Sí, desde la sección de Configuración.'),

          const SizedBox(height: 30),
          const Divider(),

          const Text(
            '¿Necesitas más ayuda?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          const Text(
            'Puedes contactarnos en:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.email, color: Colors.brown),
              SizedBox(width: 8),
              Text('soporte@mr0ttizapp.com'),
            ],
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.feedback),
            label: const Text('Enviar sugerencia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const FeedbackDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(answer),
        ),
      ],
    );
  }
}

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Enviar sugerencia'),
      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Escribe tu sugerencia o problema aquí...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Enviar'),
          onPressed: () {
            // Aquí podrías manejar el envío del feedback
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gracias por tu sugerencia')),
            );
          },
        ),
      ],
    );
  }
}
