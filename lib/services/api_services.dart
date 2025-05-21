import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://tms-server-rosy.vercel.app/';

  //getAll users
  Future<Map<String, dynamic>?> getUser(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/user/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  //login user
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('${baseUrl}users/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'user': data['user']};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<List<Map<String, dynamic>>?> getFinesByNIC(String nic) async {
    final url = Uri.parse('${baseUrl}policeIssueFine/fines-get-by-NIC/$nic');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print('response1: $data');
        // Assuming API returns a list of fines in the response body
        if (data["data"] is List) {
          // Cast each item to Map<String, dynamic>
          //print('response2: $data');
          return List<Map<String, dynamic>>.from(data["data"]);
        } else {
          // If API returns an object with fines inside
          // e.g. { "fines": [...] }
          if (data['fines'] != null && data['fines'] is List) {
            return List<Map<String, dynamic>>.from(data['fines']);
          }
        }
      } else {
        print('Failed to load fines, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception fetching fines: $e');
    }

    return null;
  }
}
