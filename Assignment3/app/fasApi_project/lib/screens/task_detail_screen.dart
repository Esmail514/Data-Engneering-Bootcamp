import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  Future<void> _refreshData() async {
    final provider = context.read<AppProvider>();
    await provider.fetchTasks();
    final updatedTask = provider.tasks.firstWhere(
      (t) => t.id == _currentTask.id,
      orElse: () => _currentTask,
    );
    setState(() {
      _currentTask = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    if (_currentTask.status.toLowerCase() == 'todo')
      statusColor = const Color(0xFFF59E0B); // Amber
    if (['in progress', 'doing'].contains(_currentTask.status.toLowerCase()))
      statusColor = const Color(0xFF3B82F6); // Blue
    if (['done', 'completed'].contains(_currentTask.status.toLowerCase()))
      statusColor = const Color(0xFF10B981); // Green

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
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
                  color: statusColor.withOpacity(0.1),
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
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _currentTask.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentTask.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentTask.description,
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
                      'Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoSection(
                      context,
                      [
                        _infoTile(context, Icons.work_outline, 'Project',
                            _currentTask.project.title),
                        _infoTile(context, Icons.person_outline, 'Assignee',
                            _currentTask.assignee.username),
                        _infoTile(
                          context,
                          Icons.calendar_today_outlined,
                          'Created On',
                          DateFormat('MMMM d, yyyy')
                              .format(_currentTask.createdAt),
                        ),
                        _infoTile(context, Icons.assignment_outlined, 'Task ID',
                            _currentTask.id.toString()),
                      ],
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

  Widget _infoSection(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
