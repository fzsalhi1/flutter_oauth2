import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // Méthode pour l'authentification via login
  Future<http.Response?> login(String email, String password) async {
    try {
      final url = Uri.parse('http://192.168.145.131:8000/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return response;
    } catch (e) {
      print("Erreur: $e");
      return null;
    }
  }

  // Méthode pour l'enregistrement d'un nouvel utilisateur
  Future<http.Response?> register(String email, String password, String name) async {
    try {
      final url = Uri.parse('http://192.168.145.131:8000/auth/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );
      return response;
    } catch (e) {
      print("Erreur lors de l'enregistrement: $e");
      return null;
    }
  }

  // Méthode pour rafraîchir le token via refreshToken
  Future<http.Response?> refreshToken(String refreshToken) async {
    try {
      final url = Uri.parse('http://192.168.145.131:8000/auth/refresh_token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refresh_token': refreshToken,
        }),
      );
      return response;
    } catch (e) {
      print("Erreur lors du rafraîchissement du token: $e");
      return null;
    }
  }
}
