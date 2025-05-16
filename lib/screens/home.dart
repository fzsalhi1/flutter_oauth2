import 'package:flutter/material.dart';
import 'package:flutter_oauth2/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import '../helper/sliderightroute.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StatefulHomeWidget(),
    );
  }
}

class StatefulHomeWidget extends StatefulWidget {
  const StatefulHomeWidget({super.key});

  @override
  State<StatefulHomeWidget> createState() => _StatefulHomeWidgetState();
}

class _StatefulHomeWidgetState extends State<StatefulHomeWidget> {
  String secureMsg = "Chargement...";
  final storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();

  Future<void> getSecureData() async {
    try {
      final Response? resp = await apiService.getSecretArea();
      if (resp != null && mounted) {
        setState(() {
          secureMsg = resp.body.toString();
        });
      } else if (mounted) {
        setState(() {
          secureMsg = "connexion réussite";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          secureMsg = "Erreur de connexion";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSecureData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 142, 54),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 26, 255, 1)),
        title: const Text(
          'Flutter OAuth2',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Roboto Condensed',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 26, 255, 1),
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await storage.deleteAll();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                SlideRightRoute(
                  page: const LoginScreen(errMsg: 'Déconnexion réussie'),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          secureMsg,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
