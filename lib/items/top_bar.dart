import 'package:flutter/material.dart';
import 'package:proyecto_aplication/users/user/shop_lista.dart';

class CustomTopSearchBar extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onMenuTap;
  final VoidCallback? onCartTap;
  final Function(String)? onSearchChanged; // ✅ Función de búsqueda

  const CustomTopSearchBar({
    super.key,
    this.onBack,
    this.onMenuTap,
    this.onCartTap,
    this.onSearchChanged,
  });

  @override
  State<CustomTopSearchBar> createState() => _CustomTopSearchBarState();
}

class _CustomTopSearchBarState extends State<CustomTopSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Detectar la ruta actual
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    List<String> mainScreens = ['/user', '/menu', '/tables', '/personal_data', '/settings', '/help'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: mainScreens.contains(currentRoute) ? const Icon(Icons.menu) : const Icon(Icons.arrow_back),
            onPressed: mainScreens.contains(currentRoute) ? (widget.onMenuTap ?? () {}) : (widget.onBack ?? () => Navigator.pop(context)),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: widget.onSearchChanged, // ✅ Ejecutar filtro al escribir
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: widget.onCartTap ?? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListShops()),
              );
            },
          ),
        ],
      ),
    );
  }
}