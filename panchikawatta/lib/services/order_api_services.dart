import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

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

  static Future<List<Map<String, dynamic>>> getSellerOrdersByUserId(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/adListing/orders/getBySellerId/$userId'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load seller orders');
    }
  }

  static Future<void> markOrderAsDispatched(int orderId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/adListing/orders/markAsDispatched'),
      body: json.encode({'orderId': orderId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark order as dispatched');
    }
  }

  static Future<void> markOrderAsDelivered(int orderId, int userId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/adListing/orders/markAsDelivered/$orderId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark order as delivered: ${response.body}');
    }
  }
}
