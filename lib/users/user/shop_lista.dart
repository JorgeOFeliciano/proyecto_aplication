import 'package:flutter/material.dart';
import 'package:proyecto_aplication/data/maps.dart';
import 'package:proyecto_aplication/users/user/shop_lista_detail.dart';

class ListShops extends StatelessWidget {
  const ListShops({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Compras"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: historialCompras.length,
          itemBuilder: (context, index) {
            final compra = historialCompras[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetalleCompraScreen(compra: compra)), // ✅ Abre los detalles
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, size: 40, color: Colors.brown), // ✅ Ícono de ticket
                  title: Text("Compra del ${compra['fecha']}"),
                  subtitle: Text("Total: \$${compra['total']} - Estado: ${compra['estado']}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}