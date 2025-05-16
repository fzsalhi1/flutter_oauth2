import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_oauth2/helper/sliderightroute.dart';
import 'package:flutter_oauth2/screens/home.dart';       // Import correct
import 'package:flutter_oauth2/screens/register.dart';   // Import correct
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_oauth2/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.errMsg}) : super(key: key);
  final String errMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulLoginWidget(errMsg: errMsg),
    );
  }
}

class StatefulLoginWidget extends StatefulWidget {
  const StatefulLoginWidget({Key? key, required this.errMsg}) : super(key: key);
  final String errMsg;

  @override
  State<StatefulLoginWidget> createState() => _StatefulLoginWidgetState();
}

class _StatefulLoginWidgetState extends State<StatefulLoginWidget> {
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await storage.read(key: "token");
    if (token != null && mounted) {
      Navigator.pushReplacement(
        context,
        SlideRightRoute(page: const HomeScreen()),  // Correct usage
      );
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();

      final res = await authService.login(_emailController.text, _passwordController.text);
      EasyLoading.dismiss();

      if (!mounted) return;

      if (res == null) {
        _showError("Une erreur s'est produite");
        return;
      }

      switch (res.statusCode) {
        case 200:
          final data = jsonDecode(res.body);
          await storage.write(key: "token", value: data['access_token']);
          await storage.write(key: "refresh_token", value: data['refresh_token']);
          Navigator.pushReplacement(
            context,
            SlideRightRoute(page: const HomeScreen()),  // Correct usage
          );
          break;
        case 401:
        default:
          _showError("Email ou mot de passe incorrect");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 142, 54),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 80, 15, 20),
                child: Text(
                  'Please login to enter the app!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              _buildEmailField(),
              _buildPasswordField(),
              _buildLoginButton(),
              _buildRegisterText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextFormField(
        controller: _emailController,
        validator: (value) => value != null && EmailValidator.validate(value)
            ? null
            : 'Please enter a valid email',
        decoration: _inputDecoration('Email', Icons.email),
        style: const TextStyle(color: Color.fromARGB(255, 128, 255, 0), fontSize: 24),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextFormField(
        controller: _passwordController,
        validator: (value) =>
        value == null || value.isEmpty ? 'Please enter your password' : null,
        obscureText: true,
        decoration: _inputDecoration('Password', Icons.password),
        style: const TextStyle(color: Color.fromARGB(255, 235, 235, 235), fontSize: 24),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 0, 0, 0),
      labelText: label,
      hintText: label,
      labelStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Color.fromARGB(255, 128, 255, 0),
      ),
      hintStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Color.fromARGB(255, 128, 255, 0),
      ),
      prefixIcon: Icon(icon, color: Color.fromARGB(255, 128, 255, 0)),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 128, 255, 0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 235, 235, 235)),
      ),
      errorStyle: const TextStyle(color: Color.fromARGB(255, 26, 255, 1)),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login, color: Colors.black),
          label: const Text(
            'LOGIN',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 200, 0),
            side: const BorderSide(color: Color.fromARGB(255, 128, 255, 0)),
          ),
          onPressed: _handleLogin,
        ),
      ),
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: RichText(
        text: TextSpan(
          text: 'Not registered? ',
          style: const TextStyle(fontSize: 18, color: Colors.black),
          children: [
            const TextSpan(text: 'Register '),
            TextSpan(
              text: 'here',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    SlideRightRoute(page: const RegisterScreen()),  // Correct usage
                  );
                },
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 128, 255, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
