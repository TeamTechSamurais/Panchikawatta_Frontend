import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveJwtToken(String token) async {
  await storage.write(key: 'jwt_token', value: token);
}

Future<String?> getJwtToken() async {
  return await storage.read(key: 'jwt_token');
}

Future<void> deleteJwtToken() async {
  await storage.delete(key: 'jwt_token');
}
