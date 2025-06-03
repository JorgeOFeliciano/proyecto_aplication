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
import 'package:proyecto_aplication/users/user/setting.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Asegura que Flutter esté listo
  await initializeDateFormatting('es_ES', null); // ✅ Inicializa datos de fecha en español
  runApp(const TableSmartApp());
}

class TableSmartApp extends StatelessWidget {
  const TableSmartApp({super.key});

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
        '/personal_data': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;

          if (args is Map<String, String>) {
            return PersonalDataScreen(usuario: args);
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Error: No se proporcionaron datos de usuario'),
              ),
            );
          }
        },
        '/settings': (context) {
          return const SettingsScreen();
        },
        '/help': (context) => const HelpScreen(),
      },
    );
  }
}