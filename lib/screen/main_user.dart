import 'package:flutter/material.dart';
import 'package:proyecto_aplication/items/nav_bar.dart';
import 'package:proyecto_aplication/users/user/favoritos.dart';
import 'package:proyecto_aplication/users/user/perfil.dart';
import 'package:proyecto_aplication/users/user/reserva.dart';
import 'package:proyecto_aplication/users/user/restaurantes.dart';

class MainUserScreen extends StatefulWidget {
  const MainUserScreen({super.key});

  @override
  State<MainUserScreen> createState() => _MainUserScreenState();
}

class _MainUserScreenState extends State<MainUserScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Restaurante(),
    Favoritos(),
    Reserva(),
    Perfil(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}