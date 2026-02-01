import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Using deployed backend (Google Sign-In won't work until backend is updated)
  static const String baseUrl = 'https://mad-edi9.onrender.com/api';

  // For local backend with firewall rule:
  // static const String baseUrl = 'http://192.168.0.130:3000/api';

  // For Android emulator (local backend):
  // static const String baseUrl = 'http://10.0.2.2:3000/api';

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
          .timeout(const Duration(seconds: 15)); // Reduced from 30s

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
      if (e.toString().contains('TimeoutException')) {
        return {
          'success': false,
          'message':
              'Connection timeout. Make sure backend is running at $baseUrl'
        };
      }
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
          .timeout(const Duration(seconds: 15)); // Reduced from 30s

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
      if (e.toString().contains('TimeoutException')) {
        return {
          'success': false,
          'message':
              'Connection timeout. Check if backend is running at $baseUrl'
        };
      }
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Google Sign-In
  static Future<Map<String, dynamic>> googleSignIn({
    required String email,
    required String name,
    required String googleId,
    required String idToken,
    String? photoUrl,
  }) async {
    try {
      print('Attempting Google Sign-In: $email');
      print('Backend URL: $baseUrl/auth/google');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/google'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'name': name,
              'googleId': googleId,
              'idToken': idToken,
              'photoUrl': photoUrl,
            }),
          )
          .timeout(const Duration(seconds: 15)); // Reduced from 30s

      print('Google Sign-In response status: ${response.statusCode}');
      print('Google Sign-In response body: ${response.body}');

      // Check if response is HTML instead of JSON
      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message':
              'Backend error: The /auth/google endpoint may not exist on the deployed server. Try using local backend.'
        };
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Save token and user data
        await saveToken(data['data']['token']);
        await saveUser(data['data']);
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Google Sign-In failed'
        };
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      if (e.toString().contains('TimeoutException')) {
        return {
          'success': false,
          'message':
              'Connection timeout. Make sure backend is running at $baseUrl'
        };
      }
      if (e.toString().contains('FormatException')) {
        return {
          'success': false,
          'message':
              'Backend error: Please make sure your backend server has the Google Sign-In endpoint.'
        };
      }
      return {
        'success': false,
        'message': 'Connection failed. Check your internet and backend.'
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    await clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  // Delete account
  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final user = await getUser();
      if (user == null || user['id'] == null) {
        return {'success': false, 'message': 'User not found'};
      }

      final token = await getToken();
      print('Deleting account for user ID: ${user['id']}');
      print('Using backend: $baseUrl');
      
      final response = await http
          .delete(
            Uri.parse('$baseUrl/auth/${user['id']}'),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      // Check if response is HTML (endpoint doesn't exist)
      if (response.body.trim().startsWith('<!DOCTYPE') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Backend error: The delete endpoint may not exist on the deployed server. Try using local backend or wait for Render to deploy the latest changes.'
        };
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Clear all local data
        await logout();
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete account'
        };
      }
    } catch (e) {
      print('Delete account error: $e');
      
      // Better error message for format exceptions
      if (e.toString().contains('FormatException')) {
        return {
          'success': false,
          'message': 'Backend error: The delete endpoint is not available on the deployed server. Please use local backend or deploy latest changes to Render first.'
        };
      }
      
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
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

      // Get user ID (handle both 'id' and '_id' keys)
      final userId = user['id'] ?? user['_id'];
      if (userId == null) {
        return {'success': false, 'message': 'User ID not found'};
      }

      print('Fetching events for organizer: $userId');
      final response = await http.get(
        Uri.parse('$baseUrl/events/organizer/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print('Get user events response status: ${response.statusCode}');
      print('Get user events response body: ${response.body}');

      // Check if response is HTML (error page) instead of JSON
      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message':
              'Server error: Received HTML instead of JSON. Please check if backend is running properly.'
        };
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch events: ${response.statusCode}'
        };
      }
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

      // Get user ID (handle both 'id' and '_id' keys)
      final userId = user['id'] ?? user['_id'];
      if (userId == null) {
        return {'success': false, 'message': 'User ID not found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      // Check if response is HTML instead of JSON
      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message': 'Server error: Unable to connect to backend'
        };
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Update local user data - ensure ID is preserved
          final userData = data['data'] as Map<String, dynamic>;
          final updatedData = {
            ...userData,
            'id': userData['_id'] ?? userData['id'] ?? userId,
            '_id': userData['_id'] ?? userData['id'] ?? userId,
          };
          await saveUser(updatedData);
          return {'success': true, 'data': updatedData};
        }
        return data;
      }

      return {
        'success': false,
        'message': 'Failed to fetch profile: ${response.statusCode}'
      };
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

      // Get user ID (handle both 'id' and '_id' keys)
      final userId = user['id'] ?? user['_id'];
      if (userId == null) {
        return {'success': false, 'message': 'User ID not found'};
      }

      final Map<String, dynamic> updateData = {};
      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (phone != null && phone.isNotEmpty) updateData['phone'] = phone;
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        updateData['avatarUrl'] = avatarUrl;
      }

      print('Updating user profile for ID: $userId');
      print('Update data: $updateData');

      final response = await http
          .put(
            Uri.parse('$baseUrl/auth/$userId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(updateData),
          )
          .timeout(const Duration(seconds: 30));

      print('Update profile response status: ${response.statusCode}');
      print('Update profile response body: ${response.body}');

      // Check if response is HTML instead of JSON
      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        return {
          'success': false,
          'message':
              'Server error: Received HTML instead of JSON. Backend may not be running properly.'
        };
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Update local user data - preserve the ID field
          final updatedUserData = {
            ...user,
            'name': data['data']['name'],
            'email': data['data']['email'],
            'phone': data['data']['phone'] ?? '',
            'avatarUrl': data['data']['avatarUrl'],
            // Ensure we preserve both id formats
            'id': data['data']['_id'] ?? data['data']['id'] ?? userId,
            '_id': data['data']['_id'] ?? data['data']['id'] ?? userId,
          };
          await saveUser(updatedUserData);
          return {
            'success': true,
            'data': updatedUserData,
            'message': 'Profile updated successfully'
          };
        }
        return data;
      }

      // Handle other status codes
      try {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Update failed: ${response.statusCode}'
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Update failed with status: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Update profile error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
