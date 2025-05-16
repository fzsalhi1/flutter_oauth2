import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements InterceptorContract {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final token = await storage.read(key: 'accessToken');
    if (token != null) {
      data.headers['Authorization'] = 'Bearer $token';
    }
    data.headers['Content-Type'] = 'application/json';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
