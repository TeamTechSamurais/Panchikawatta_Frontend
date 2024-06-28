// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/sparepart.dart';

class ApiService {
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('${Utils.baseUrl}/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(String email, String name) async {
    final response = await http.post(
      Uri.parse('${Utils.baseUrl}/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'name': name}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }

  Future<List<SparePart>> getSpareParts() async {
    final response =
        await http.get(Uri.parse('${Utils.baseUrl}/adListing/getSpareParts'));

    if (response.statusCode == 200) {
      final List<dynamic> sparePartsJson = json.decode(response.body);
      return sparePartsJson.map((json) => SparePart.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spareparts');
    }
  }

  Future<Map<String, dynamic>> getSparePartById(int sparePartId) async {
    final response =
        await http.get(Uri.parse('${Utils.baseUrl}/spare-parts/$sparePartId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['sparePart'];
    } else {
      throw Exception('Failed to load spare part details');
    }
  }
}
