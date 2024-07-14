import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/sparepart.dart';
import 'package:panchikawatta/models/service.dart';

class FilterApiService {
  Future<List<dynamic>> fetchFilteredAds({
    String? type,
    String? vehicleMake,
    String? model,
    String? origin,
    String? minPrice,
    String? maxPrice,
    List<String>? conditions,
    List<String>? fuelTypes,
    String? minYear,
    String? maxYear,
  }) async {
    final queryParams = {
      'vehicleType': type,
      'vehicleMake': vehicleMake,
      'model': model,
      'origin': origin,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'conditions': conditions?.join(','),
      'fuelTypes': fuelTypes?.join(','),
      'minYear': minYear,
      'maxYear': maxYear,
    };

    // Remove null values
    queryParams.removeWhere((key, value) => value == null);

    final uri =
        Uri.http('10.0.2.2:8000', '/adListing/getFilteredAds', queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> ads = json.decode(response.body);
      return ads;
    } else {
      throw Exception('Failed to fetch filtered ads');
    }
  }

  //sorting APIs
  Future<List<SparePart>> getSortedSpareParts(String sort) async {
    final response = await http.get(
        Uri.parse('${Utils.baseUrl}/adListing/getsortedspareparts?sort=$sort'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => SparePart.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sorted spare parts');
    }
  }

  Future<List<Service>> getSortedServices(String sort) async {
    final response = await http.get(
        Uri.parse('${Utils.baseUrl}/adListing/getsortedservices?sort=$sort'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sorted services');
    }
  }
}
