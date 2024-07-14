// ignore_for_file: avoid_print
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/service.dart';
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
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SparePart.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spare parts');
    }
  }

  Future<List<Service>> getServices() async {
    final response =
        await http.get(Uri.parse('${Utils.baseUrl}/adListing/getServices'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse); // Print the JSON response for debugging
      final List<dynamic> servicesJson = jsonDecode(response.body);
      return servicesJson.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<SparePart> getSparePartById(int id) async {
    final response = await http
        .get(Uri.parse('${Utils.baseUrl}/adListing/getSparepartById/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return SparePart.fromJson(data);
    } else {
      throw Exception('Failed to load spare part');
    }
  }

  Future<Service> getServiceById(int serviceId) async {
    print('Fetching service with ID: $serviceId');
    final url = '${Utils.baseUrl}/users/services/$serviceId';
    print('URL: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('JSON Response: $jsonResponse');
      final Service service = Service.fromJson(jsonResponse);
      print('Service Object: $service');
      return service;
    } else {
      print('Failed to load services: ${response.body}');
      throw Exception('Failed to load services');
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

  Future<List<Service>> searchServices(String keyword) async {
    final response = await http.get(Uri.parse(
        '${Utils.baseUrl}/adListing/searchServices?keyword=$keyword'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
}
