// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/sparepart.dart';

class GetApiService {
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('${Utils.baseUrl}/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
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

  Future<SparePart> getSparePartById(int sparePartId) async {
    final response = await http
        .get(Uri.parse('${Utils.baseUrl}/users/spare-parts/$sparePartId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final SparePart sparePart =
          SparePart.fromJson(jsonResponse); // Directly map to SparePart
      print(sparePart);
      return sparePart;
    } else {
      throw Exception('Failed to load spare part');
    }
  }

  Future<List<SparePart>> searchSpareparts(String keyword) async {
    final response = await http
        .get(Uri.parse('${Utils.baseUrl}/adListing/search?keyword=$keyword'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SparePart.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load spare parts');
    }
  }
}
