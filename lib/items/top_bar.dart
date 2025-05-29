import 'package:flutter/material.dart';
import 'package:proyecto_aplication/users/user/shop_lista.dart';

class CustomTopSearchBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;
  final VoidCallback? onCartTap;

  const CustomTopSearchBar({
    super.key,
    this.onBack,
    this.onMenuTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Detectar la ruta actual
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    // ✅ Lista de pantallas principales
    List<String> mainScreens = ['/user', '/menu', '/tables', '/personal_data', '/settings', '/help'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // ✅ Si estamos en una pantalla principal, mostramos el botón de menú
          // ✅ Si NO estamos en una pantalla principal, mostramos el botón de regreso
          IconButton(
            icon: mainScreens.contains(currentRoute) ? const Icon(Icons.menu) : const Icon(Icons.arrow_back),
            onPressed: mainScreens.contains(currentRoute) ? (onMenuTap ?? () {}) : (onBack ?? () => Navigator.pop(context)),
          ),
          const SizedBox(width: 8),

          // ✅ Barra de búsqueda
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // ✅ Botón del carrito
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: onCartTap ?? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListShops()), // ✅ Abre la pantalla del carrito
              );
            },
          ),
        ],
      ),
    );
  }
}