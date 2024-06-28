// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:panchikawatta/constant/utils.dart';
import 'package:panchikawatta/models/sparepart.dart';

class ApiService {
  Future<SparePart> postSparePartStep1({
    required int sellerId,
    required String title,
    required String description,
    required int price,
    XFile? image,
  }) async {
    try {
      final url = Uri.parse('${Utils.baseUrl}/adPosting/postSparePartStep1');
      final request = http.MultipartRequest('POST', url);

      request.fields['sellerId'] = sellerId.toString();
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();

      final imageBytes = await image?.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes!,
          filename: image?.name,
        ),
      );

      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return SparePart.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to post spare part (Step 1)');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Step 02 - Ad Posting
  Future<SparePart> postSparePartStep2({
    required int sparePartId,
    required String make,
    required String model,
    required String origin,
    required String condition,
    required String fuel,
    required int year,
  }) async {
    try {
      final url = Uri.parse('${Utils.baseUrl}/adPosting/postSparePartStep2');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'sparePartId': sparePartId,
          'make': make,
          'model': model,
          'origin': origin,
          'condition': condition,
          'fuel': fuel,
          'year': year,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return SparePart.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to update spare part (Step 2)');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //Post Services
  Future<SparePart> postService({
    required int sellerId,
    required String title,
    required String description,
    required int price,
    XFile? image,
  }) async {
    try {
      final url = Uri.parse('${Utils.baseUrl}/adPosting/postService');
      final request = http.MultipartRequest('POST', url);

      request.fields['sellerId'] = sellerId.toString();
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();

      final imageBytes = await image?.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes!,
          filename: image?.name,
        ),
      );

      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return SparePart.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to post spare part (Step 1)');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
