import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/project.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Project _currentProject;

  @override
  void initState() {
    super.initState();
    _currentProject = widget.project;
  }

  Future<void> _refreshData() async {
    final provider = context.read<AppProvider>();
    await provider.fetchProjects();
    final updatedProject = provider.projects.firstWhere(
      (p) => p.id == _currentProject.id,
      orElse: () => _currentProject,
    );
    setState(() {
      _currentProject = updatedProject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Project Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit logic
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.2),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PROJECT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentProject.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentProject.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _detailTile(
                      context,
                      Icons.person_outline,
                      'Project Lead',
                      _currentProject.owner.username,
                    ),
                    _detailTile(
                      context,
                      Icons.calendar_today_outlined,
                      'Created On',
                      DateFormat('MMMM d, yyyy')
                          .format(_currentProject.createdAt),
                    ),
                    _detailTile(
                      context,
                      Icons.update_outlined,
                      'Last Updated',
                      DateFormat('MMMM d, yyyy')
                          .format(_currentProject.updatedAt),
                    ),
                    _detailTile(
                      context,
                      Icons.grid_view_outlined,
                      'Project ID',
                      _currentProject.id.toString(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTile(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
