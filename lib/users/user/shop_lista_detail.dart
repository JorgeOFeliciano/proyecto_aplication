import 'package:flutter/material.dart';

class DetalleCompraScreen extends StatelessWidget {
  final Map<String, dynamic> compra;

  const DetalleCompraScreen({super.key, required this.compra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compra del ${compra['fecha']}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista de productos
            Expanded(
              child: ListView.builder(
                itemCount: compra['productos'].length,
                itemBuilder: (context, index) {
                  final producto = compra['productos'][index];
                  // Usamos las claves consistentes: 'name', 'quantity' y 'price'
                  final int cantidad = producto['quantity'] ?? 0;
                  final double precio = producto['price'] ?? 0.0;
                  final totalProducto = (cantidad * precio).toStringAsFixed(2);
                  return ListTile(
                    title: Text(producto['name'] ?? ""),
                    subtitle: Text("Cantidad: $cantidad - Precio Unitario: \$$precio"),
                    trailing: Text("\$$totalProducto"),
                  );
                },
              ),
            ),
            const Divider(height: 30, thickness: 2),
            Text(
              "Total: \$${(compra['total'] as num).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Estado: ${compra['estado']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}