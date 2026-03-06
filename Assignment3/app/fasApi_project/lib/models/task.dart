import 'user.dart';
import 'project.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final Project project;
  final User assignee;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.project,
    required this.assignee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Task',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Todo',
      project: json['project'] != null
          ? Project.fromJson(json['project'])
          : Project(
              id: 0,
              title: 'Unknown',
              description: '',
              owner: User(
                  id: 0,
                  username: 'Unknown',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now()),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()),
      assignee: json['assignee'] != null
          ? User.fromJson(json['assignee'])
          : User(
              id: 0,
              username: 'Unknown',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'project': project.toJson(),
      'assignee': assignee.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
