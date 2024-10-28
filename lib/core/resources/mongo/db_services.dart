import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:landing_page/config/env.dart';

class ApiService {
  static Future<List<dynamic>> getItems() async {
    final response = await http.get(Uri.parse(testUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  static Future<dynamic> addItem(Map<String, dynamic> item) async {
    final response = await http.post(
      Uri.parse(testUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(item),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add item');
    }
  }
}
