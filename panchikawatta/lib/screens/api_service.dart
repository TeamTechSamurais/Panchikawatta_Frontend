import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseURL = "http://192.168.8.117:8000";

  static Future <Map<String, dynamic>> getUserByEmail(String email) async {
    //print('inside the getUserByEmail function');
    try {

      final response = await http.get(Uri.parse('$baseURL/users/$email')).timeout(const Duration(seconds: 10)) ;   //$baseURL/users/$email

      if (response.statusCode == 200) {
        return json.decode(response.body);  
      } else {
        return {
          "status": "error",
          "message": "User not found"
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred"
      };
    }
  }


  static Future <Map<String, dynamic>> updateUser(String email, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/users/$email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          "status": "error",
          "message": "User not found"
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred"
      };
    }
  }


  static Future <Map<String, dynamic>> deleteUser(String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/delete-users/$email'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          "status": "error",
          "message": "User not found"
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred"
      };
    }
  }
} 