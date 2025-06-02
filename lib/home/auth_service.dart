import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_aplication/data/maps.dart';

class AuthService {
  static const _userKey = 'user_data';

  static Future<void> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Puedes registrar sin ID si es nuevo
    final user = {'username': username, 'password': password};
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Future<String?> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Buscar dentro de la lista `usuarios`
    for (final user in usuarios) {
      if (user['username'] == username && user['password'] == password) {
        await prefs.setString(
          _userKey,
          jsonEncode({
            'id': user['id'],
            'username': user['username'],
            'password': user['password'],
          }),
        );
        return user['id'];
      }
    }

    // Revisión opcional por si ya hay una sesión previa
    final stored = prefs.getString(_userKey);
    if (stored != null) {
      final data = jsonDecode(stored);
      if (data['username'] == username && data['password'] == password) {
        return data['id'];
      }
    }

    return null;
  }

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return null;
    final user = jsonDecode(data);
    return user['id'];
  }
}
