// services/employee_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/employee_model.dart';

class EmployeeService {
  static Future<List<Employee>> fetchEmployees() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Employee>.from(data.map((e) => Employee.fromJson(e)));
    } else {
      throw Exception('Failed to load employees');
    }
  }
}
