// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/service.dart';
import 'package:panchikawatta/models/sparepart.dart';

class PostApiService {
  Future<SparePart> postSparePart({
    required int sellerId,
    required String title,
    required String description,
    required int price,
    required List<String> imageUrls,
    required String type,
    required String make,
    required String model,
    required String origin,
    required String condition,
    required String fuel,
    required int year,
  }) async {
    final url = Uri.parse('${Utils.baseUrl}/adPosting/postSparePart');

    final body = jsonEncode({
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'type': type,
      'make': make,
      'model': model,
      'origin': origin,
      'condition': condition,
      'fuel': fuel,
      'year': year,
    });

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 201) {
      throw Exception('Failed to post spare part');
    }

    final jsonResponse = jsonDecode(response.body);
    return SparePart.fromJson(jsonResponse);
  }

  //Post Services
  Future<Service> postService({
    required int sellerId,
    required String title,
    required String description,
    required String price,
    required List<String> imageUrls,
  }) async {
    try {
      final url = Uri.parse('${Utils.baseUrl}/adPosting/postService');

      final body = jsonEncode({
        'sellerId': sellerId,
        'title': title,
        'description': description,
        'price': price,
        'imageUrls': imageUrls,
      });

      final headers = {
        'Content-Type': 'application/json',
      };

      final response = await http.post(url, headers: headers, body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return Service.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to post service: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
