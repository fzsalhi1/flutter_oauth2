import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:flutter_oauth2/services/auth.dart';

class ApiInterceptor implements InterceptorContract {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AuthService authService = AuthService();

  Future<String> get tokenOrEmpty async {
    var token = await storage.read(key: "token");
    return token ?? "";
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String token = await tokenOrEmpty;
    try {
      data.headers["Authorization"] = "Bearer $token";
    } catch (e) {
      if (kDebugMode) {
        print("Erreur ajout token: $e");
      }
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      var refreshToken = await storage.read(key: "refresh_token");

      if (refreshToken != null) {
        try {
          var res = await authService.refreshToken(refreshToken);
          if (res != null && res.statusCode == 200) {
            var json = jsonDecode(res.body);
            await storage.write(key: "token", value: json['access_token']);
            await storage.write(key: "refresh_token", value: json['refresh_token']);
          }
        } catch (e) {
          if (kDebugMode) {
            print("Erreur refresh token: $e");
          }
        }
      }
    }
    return data;
  }
}
