// lib/data/services/api_client.dart
import 'dart:convert'; // ADICIONE
import 'package:dio/dio.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
        ));

  Future<Result<String>> get(String path) async {
    try {
      final res = await _dio.get(path);
      // ✅ se já veio objeto/lista, serialize para JSON válido
      final asString = res.data is String ? res.data as String : jsonEncode(res.data);
      return Ok<String>(asString);
    } catch (e, st) {
      logE('ApiClient', e, st);
      return Err<String>(e);
    }
  }
}
