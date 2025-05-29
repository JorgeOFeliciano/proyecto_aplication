import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'RESTAURANTES',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'FAVORITOS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'RESERVAS',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'PERFIL',
        ),
      ],
    );
  }
}
