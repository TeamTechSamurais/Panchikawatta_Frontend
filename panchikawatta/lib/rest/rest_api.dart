 import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:panchikawatta/constant/utils.dart';

Future userLogin(String Username, String Password) async {
  final response = await http.post(
    Uri.parse('${Utils.baseUrl}/user/login'),
    headers: {"Accept": "Application/json"},
    body: {'Username': Username, 'Password': Password},
  );
  
  var decodedData = jsonDecode(response.body);
  return decodedData;
}
