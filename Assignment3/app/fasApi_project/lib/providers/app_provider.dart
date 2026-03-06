import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<User> _users = [];
  List<Project> _projects = [];
  List<Task> _tasks = [];

  User? _currentUser;
  bool _isLoading = false;

  List<User> get users => _users;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Auth
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _apiService.login(username, password);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final newUser = await _apiService.createUser(data);
      _users.add(newUser);
      _currentUser = newUser;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Users
  Future<void> fetchUsers() async {
    _setLoading(true);
    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    try {
      final newUser = await _apiService.createUser(data);
      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final updatedUser = await _apiService.updateUser(id, data);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _apiService.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Projects
  Future<void> fetchProjects() async {
    _setLoading(true);
    try {
      _projects = await _apiService.getProjects();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProject(Map<String, dynamic> data) async {
    try {
      final newProject = await _apiService.createProject(data);
      _projects.add(newProject);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProject(int id, Map<String, dynamic> data) async {
    try {
      final updatedProject = await _apiService.updateProject(id, data);
      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = updatedProject;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await _apiService.deleteProject(id);
      _projects.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Tasks
  Future<void> fetchTasks() async {
    _setLoading(true);
    try {
      _tasks = await _apiService.getTasks();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(Map<String, dynamic> data) async {
    try {
      final newTask = await _apiService.createTask(data);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> data) async {
    try {
      final updatedTask = await _apiService.updateTask(id, data);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
