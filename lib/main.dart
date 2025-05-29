import 'package:flutter/material.dart';
import 'package:proyecto_aplication/home/welcome_screen.dart';
import 'package:proyecto_aplication/home/login_screen.dart';
import 'package:proyecto_aplication/home/register_screen.dart';
import 'package:proyecto_aplication/screen/main_user.dart';
import 'package:proyecto_aplication/users/user/help.dart';
import 'package:proyecto_aplication/users/user/restaurante_detail.dart';
import 'package:proyecto_aplication/users/user/restaurante_detail_menu.dart';
import 'package:proyecto_aplication/users/user/restaurante_detail_mesas.dart';
import 'package:proyecto_aplication/users/user/personal_data.dart';
import 'package:proyecto_aplication/users/user/setting.dart'; // ✅ Cambié settings.dart por personal_data.dart

void main() {
  runApp(const TableSmartApp());
}

class TableSmartApp extends StatelessWidget {
  const TableSmartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableSmart',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/user': (context) => const MainUserScreen(),
        '/user_rest_det': (context) => const RestaurantDetail(),
        '/tables': (context) => const TableReservationScreen(),
        '/menu': (context) => const RestaurantMenuScreen(),
        '/personal_data': (context) { // ✅ Cambié settings por datos personales
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return PersonalDataScreen(usuario: args);
        },
        '/settings': (context) { // ✅ Cambié settings por datos personales
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return SettingsScreen(usuario: args);
        },
        '/help': (context) => const HelpScreen(),
      },
    );
  }
}