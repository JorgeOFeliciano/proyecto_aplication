import 'package:flutter/material.dart';

class CustomTopSearchBarBack extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLocationTap;

  const CustomTopSearchBarBack({
    Key? key,
    this.onBack,
    this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Botón de regresar
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          // Barra de búsqueda
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
          // Icono de ubicación
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: onLocationTap ?? () {},
          ),
        ],
      ),
    );
  }
}


class CustomTopSearchBar extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLocationTap;

  const CustomTopSearchBar({
    Key? key,
    this.onMenuTap,
    this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: onMenuTap,
          ),
          const SizedBox(width: 8),
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
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: onLocationTap ?? () {},
          ),
        ],
      ),
    );
  }
}
