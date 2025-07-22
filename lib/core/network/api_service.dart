import 'dart:convert';
import 'package:clean_architecture_with_bloc/core/utils/logger.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    appLog("[Request] => GET $url");

    try {
      final response = await http.get(url);

      appLog("[Response] => ${response.statusCode} ${response.body}");
      return response;
    } catch (e) {
      appLog("[HttpError] => $e");
      rethrow;
    }
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    appLog("[Request] => POST $url, Body: $data");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      appLog("[Response] => ${response.statusCode} ${response.body}");
      return response;
    } catch (e) {
      appLog("[HttpError] => $e");
      rethrow;
    }
  }

// Add similar functions for PUT, DELETE etc. if needed
}
