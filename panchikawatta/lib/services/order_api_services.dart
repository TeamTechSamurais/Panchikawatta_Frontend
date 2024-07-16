import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';

class ApiService {


  // Fetch buyer orders
  static Future<List<Map<String, dynamic>>> getBuyerOrders(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/adListing/orders/getByUserId/$userId'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load orders');
    }
  }
  // Fetch seller orders
static Future<List<Map<String, dynamic>>> getSellerOrdersByUserId(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/adListing/orders/getBySellerId/$userId'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load seller orders');
    }
  }

  // Mark order as dispatched
static Future<void> markOrderAsDispatched(int orderId, int userId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/adListing/orders/markAsDispatched'),
      body: json.encode({'orderId': orderId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark order as dispatched');
    }
  }

  // Mark order as delivered
static Future<void> markOrderAsDelivered(int orderId, int userId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/adListing/orders/markAsDelivered/$orderId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark order as delivered');
    }
  }

}
