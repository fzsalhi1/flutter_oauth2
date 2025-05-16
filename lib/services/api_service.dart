import 'package:flutter_oauth2/helper/constant.dart';
import 'package:flutter_oauth2/services/api_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Client client = InterceptedClient.build(
    interceptors: [ApiInterceptor()],
    requestTimeout: const Duration(seconds: 15),
  );

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Response> getSecretArea() async {
    try {
      final secretUrl = Uri.parse('${Constants.baseUrl}/secret');
      final response = await client.get(secretUrl);

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        // Token expiré ou invalide, rediriger vers la page de connexion
        await storage.delete(key: 'accessToken');
        throw Exception("Session expirée. Veuillez vous reconnecter.");
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      // En cas d'erreur réseau ou autre exception
      throw Exception("Erreur de connexion : $e");
    }
  }
}
