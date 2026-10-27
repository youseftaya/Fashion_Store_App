import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<dynamic>> fetchProducts({
    String? category,
  }) async {
    final endpoint = category == null
        ? '/products'
        : '/products/category/${Uri.encodeComponent(category)}';

    final uri = Uri.parse(
      '${AppConstants.baseUrl}$endpoint',
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData is List) {
        return decodedData;
      }

      if (decodedData is Map<String, dynamic> &&
          decodedData['products'] is List) {
        return decodedData['products'] as List<dynamic>;
      }

      throw const FormatException(
        'Unexpected products response format.',
      );
    }

    throw Exception(
      'Failed to load products. Status code: ${response.statusCode}',
    );
  }

  void dispose() {
    _client.close();
  }
}