import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/project.dart';
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.102:5000';

  // Users
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) {
          try {
            return User.fromJson(user);
          } catch (e) {
            print('Error parsing individual user: $e, Data: $user');
            rethrow;
          }
        }).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('ApiService.getUsers error: $e');
      rethrow;
    }
  }

  Future<User> createUser(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Invalid username or password');
    } else {
      throw Exception('Failed to login');
    }
  }

  // Projects
  Future<List<Project>> getProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((project) => Project.fromJson(project)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<Project> createProject(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  Future<Project> updateProject(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/projects/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update project');
    }
  }

  Future<void> deleteProject(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/projects/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete project');
    }
  }

  // Tasks
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}
