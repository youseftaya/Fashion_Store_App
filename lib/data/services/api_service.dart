import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<dynamic>> _getList(Uri uri) async {
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'API request failed. Status code: ${response.statusCode}',
      );
    }

    final decodedData = jsonDecode(response.body);

    if (decodedData is List) {
      return decodedData;
    }

    throw const FormatException('Unexpected API response format.');
  }

  Future<List<dynamic>> fetchProducts({
    int limit = 10,
    int offset = 0,
  }) {
    final uri = Uri.parse('${AppConstants.baseUrl}/products').replace(
      queryParameters: {
        'offset': offset.toString(),
        'limit': limit.toString(),
      },
    );

    return _getList(uri);
  }

  Future<List<dynamic>> fetchCategories() {
    final uri = Uri.parse('${AppConstants.baseUrl}/categories').replace(
      queryParameters: {'limit': '50'},
    );

    return _getList(uri);
  }

  Future<List<dynamic>> fetchProductsByCategory({
    required int categoryId,
    int limit = 10,
    int offset = 0,
  }) {
    final uri = Uri.parse(
      '${AppConstants.baseUrl}/categories/$categoryId/products',
    ).replace(
      queryParameters: {
        'offset': offset.toString(),
        'limit': limit.toString(),
      },
    );

    return _getList(uri);
  }

  void dispose() {
    _client.close();
  }
}