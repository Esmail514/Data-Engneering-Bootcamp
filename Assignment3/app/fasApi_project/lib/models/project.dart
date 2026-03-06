import 'user.dart';

class Project {
  final int id;
  final String title;
  final String description;
  final User owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Project',
      description: json['description'] ?? '',
      owner: json['owner'] != null
          ? User.fromJson(json['owner'])
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
      'owner': owner.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
