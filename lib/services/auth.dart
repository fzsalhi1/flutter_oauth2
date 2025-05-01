import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // Méthode pour l'authentification via login
  Future<http.Response?> login(String email, String password) async {
    try {
      final url = Uri.parse('http://192.168.145.131:8000/auth/login'); // Remplace par l'URL de ton API de login
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
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
      final url = Uri.parse('http://192.168.145.131:8000/auth/register'); // Remplace par l'URL de ton API d'enregistrement
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
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
      final url = Uri.parse('https://example.com/api/refresh_token'); // Remplace par l'URL de ton API pour rafraîchir le token
      final response = await http.post(
        url,
        body: {
          'refresh_token': refreshToken,
        },
      );
      return response;
    } catch (e) {
      print("Erreur lors du rafraîchissement du token: $e");
      return null;
    }
  }
}
