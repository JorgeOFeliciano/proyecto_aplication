  import 'package:flutter/material.dart';
  import 'package:proyecto_aplication/data/maps.dart';
  import 'package:proyecto_aplication/users/user/shop_lista.dart';

  class PedidoScreen extends StatefulWidget {
    final String restaurantName; // Nombre del restaurante donde se realizó el pedido
    final List<Map<String, dynamic>> pedido; // Lista de productos del pedido actual

    const PedidoScreen({super.key, required this.restaurantName, required this.pedido});

    @override
    State<PedidoScreen> createState() => _PedidoScreenState();
  }

  class _PedidoScreenState extends State<PedidoScreen> {
    // Calcula el total del pedido sumando la cantidad por el precio de cada producto
    double _calculateTotal() {
      return widget.pedido.fold(
          0.0, (sum, item) => sum + (item['quantity'] * item['price']));
    }

    // Aumenta la cantidad del producto en el pedido
    void _incrementQuantity(int index) {
      setState(() {
        widget.pedido[index]['quantity']++;
      });
    }

    // Disminuye la cantidad del producto, sin bajar de 1
    void _decrementQuantity(int index) {
      if (widget.pedido[index]['quantity'] > 1) {
        setState(() {
          widget.pedido[index]['quantity']--;
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      final total = _calculateTotal();
      final cafeClaro = Colors.brown.shade300; // Color de acento definido

      return Scaffold(
        appBar: AppBar(
          title: Text("Pedido - ${widget.restaurantName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: widget.pedido.isEmpty
            ? const Center(
                child: Text("No tienes productos en tu pedido",
                    style: TextStyle(fontSize: 18)),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Lista de productos del pedido
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.pedido.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = widget.pedido[index];
                          final lineTotal =
                              (item['quantity'] * item['price']).toStringAsFixed(2);
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.fastfood, size: 50, color: cafeClaro),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['name'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text("Precio Unitario: \$${item['price']}",
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  // Controles de cantidad
                                  Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove,
                                              size: 20, color: Colors.red),
                                          onPressed: () => _decrementQuantity(index),
                                        ),
                                        Text("${item['quantity']}",
                                            style: const TextStyle(fontSize: 16)),
                                        IconButton(
                                          icon: Icon(Icons.add,
                                              size: 20, color: cafeClaro),
                                          onPressed: () => _incrementQuantity(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text("\$$lineTotal",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(thickness: 1, height: 20),
                    // Muestra el total del pedido
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón para finalizar el pedido
                    ElevatedButton(
                      onPressed: () {
                        final now = DateTime.now();
                        final formattedDate =
                            "${now.day}/${now.month}/${now.year}";
                        // Crea el objeto compra con los datos del pedido
                        final compra = {
                          'fecha': formattedDate,
                          'total': total,
                          'estado': 'Enviado',
                          'productos': widget.pedido,
                          'restaurant': widget.restaurantName,
                        };

                        // Agrega la compra al historial y limpia el carrito para ese restaurante
                        historialCompras.add(compra);
                        carritoCompras.removeWhere((item) =>
                            item['restaurant'] == widget.restaurantName);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListShops()),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Pedido enviado con éxito")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cafeClaro,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text("Finalizar Pedido",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
      );
    }
  }