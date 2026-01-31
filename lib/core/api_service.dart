import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://mad-edi9.onrender.com/api';

  // Store auth token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Clear auth token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Save user data
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user_data');
    if (userStr != null) {
      return jsonDecode(userStr);
    }
    return null;
  }

  // Register user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      print('Attempting to register: $email');
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'phone': phone ?? '',
            }),
          )
          .timeout(const Duration(seconds: 30));

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        // Save token and user data
        await saveToken(data['data']['token']);
        await saveUser(data['data']);
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to login: $email');
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Save token and user data
        await saveToken(data['data']['token']);
        await saveUser(data['data']);
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Logout
  static Future<void> logout() async {
    await clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  // Get events
  static Future<Map<String, dynamic>> getEvents({
    String? category,
    String? search,
    String? sort,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/events');
      final queryParams = <String, String>{};

      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (sort != null) queryParams['sort'] = sort;

      if (queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get single event
  static Future<Map<String, dynamic>> getEvent(String eventId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/events/$eventId'));
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Create event
  static Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required String category,
    required String location,
    required DateTime dateTime,
    required double price,
    required int maxAttendees,
  }) async {
    try {
      final token = await getToken();
      final user = await getUser();

      if (token == null || user == null) {
        return {'success': false, 'message': 'Please login to create events'};
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/events'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'title': title,
              'description': description,
              'category': category,
              'location': location,
              'dateTime': dateTime.toIso8601String(),
              'price': price,
              'maxAttendees': maxAttendees,
              'organizerId': user['id'],
              'organizer': user['name'],
            }),
          )
          .timeout(const Duration(seconds: 30));

      print('Create event response: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create event'
        };
      }
    } catch (e) {
      print('Create event error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get user's created events
  static Future<Map<String, dynamic>> getUserEvents() async {
    try {
      final token = await getToken();
      final user = await getUser();

      if (token == null || user == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/events/organizer/${user['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print('Get user events error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await getToken();
      final user = await getUser();

      if (token == null || user == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/${user['id']}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Update local user data
        await saveUser(data['data']);
        return data;
      }

      return data;
    } catch (e) {
      print('Get user profile error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final token = await getToken();
      final user = await getUser();

      if (token == null || user == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }

      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (avatarUrl != null) updateData['avatarUrl'] = avatarUrl;

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/${user['id']}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(updateData),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Update local user data
        await saveUser(data['data']);
        return data;
      }

      return data;
    } catch (e) {
      print('Update profile error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
