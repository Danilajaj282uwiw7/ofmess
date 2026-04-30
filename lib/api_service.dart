import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // для Pydroid
  static String? token;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (token != null) 'X-Auth-Token': token!,
  };

  static Future<void> saveToken(String t) async {
    token = t;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', t);
  }

  static Future<void> clearToken() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }

  // Auth
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      await saveToken(body['token']);
      return body;
    } else {
      throw Exception(body['error'] ?? 'Login failed');
    }
  }

  static Future<Map<String, dynamic>> register(String username, String password, String displayName) async {
    final res = await http.post(Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password, 'display_name': displayName}));
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      await saveToken(body['token']);
      return body;
    } else {
      throw Exception(body['error'] ?? 'Registration failed');
    }
  }

  // Users
  static Future<Map<String, dynamic>> getUser(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/api/users/$userId'), headers: headers);
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> searchUsers(String query) async {
    final res = await http.get(Uri.parse('$baseUrl/api/users/search?q=$query'), headers: headers);
    return jsonDecode(res.body);
  }

  // Contacts
  static Future<List<dynamic>> getContacts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/contacts'), headers: headers);
    return jsonDecode(res.body);
  }

  static Future<void> addContact(String username) async {
    await http.post(Uri.parse('$baseUrl/api/contacts'),
        headers: headers,
        body: jsonEncode({'username': username}));
  }

  // Chats
  static Future<List<dynamic>> getChats() async {
    final res = await http.get(Uri.parse('$baseUrl/api/chats'), headers: headers);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> createDirectChat(int partnerId) async {
    final res = await http.post(Uri.parse('$baseUrl/api/chats'),
        headers: headers,
        body: jsonEncode({'partner_id': partnerId, 'is_group': false}));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> createGroup(String name, List<int> members) async {
    final res = await http.post(Uri.parse('$baseUrl/api/chats'),
        headers: headers,
        body: jsonEncode({'is_group': true, 'name': name, 'members': members}));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getChatInfo(int chatId) async {
    final res = await http.get(Uri.parse('$baseUrl/api/chats/$chatId'), headers: headers);
    return jsonDecode(res.body);
  }

  // Messages
  static Future<List<dynamic>> getMessages(int chatId, {int? before, int limit = 50}) async {
    String url = '$baseUrl/api/messages/$chatId?limit=$limit';
    if (before != null) url += '&before=$before';
    final res = await http.get(Uri.parse(url), headers: headers);
    return jsonDecode(res.body);
  }

  static Future<void> sendMessage(int chatId, String text) async {
    await http.post(Uri.parse('$baseUrl/api/messages/$chatId'),
        headers: headers,
        body: jsonEncode({'text': text}));
  }
} 
