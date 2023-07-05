import 'package:dio/dio.dart';
import 'package:laravel_forge/storage.dart';

class Http {
  static final Http _http = Http._internal();

  late Dio dio;
  late String? token;

  factory Http() {
    return _http;
  }

  Future<void> init() async {
    token = await storage.read(key: 'token');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    dio = Dio(BaseOptions(
        baseUrl: 'https://forge.laravel.com/api/v1',
        headers: headers,
        connectTimeout: const Duration(seconds: 5)));
  }

  Http._internal();
}
