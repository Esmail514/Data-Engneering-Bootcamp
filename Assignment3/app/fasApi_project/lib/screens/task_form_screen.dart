import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedStatus;
  int? _selectedProjectId;
  int? _selectedAssigneeId;

  final List<String> _statuses = ['Todo', 'Doing', 'Done'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _selectedStatus = widget.task?.status ?? 'Todo';
    _selectedProjectId =
        widget.task?.project.id == 0 ? null : widget.task?.project.id;
    _selectedAssigneeId =
        widget.task?.assignee.id == 0 ? null : widget.task?.assignee.id;

    Future.microtask(() {
      final provider = context.read<AppProvider>();
      provider.fetchProjects();
      provider.fetchUsers();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AppProvider>();
      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'status': _selectedStatus,
        'project_id': _selectedProjectId,
        'assigned_to': _selectedAssigneeId,
      };

      if (widget.task == null) {
        await provider.addTask(data);
      } else {
        await provider.updateTask(widget.task!.id, data);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final projects = provider.projects;
    final users = provider.users;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Container(
        color: const Color(0xFFF9FAFB),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Define the task and assign it to a project and user.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _titleController,
                  label: 'Task Title',
                  icon: Icons.assignment_outlined,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151)),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: _dropdownDecoration(null),
                            items: _statuses.map((status) {
                              return DropdownMenuItem(
                                  value: status, child: Text(status));
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedStatus = value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Project',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151)),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _selectedProjectId,
                  decoration: _dropdownDecoration(Icons.work_outline),
                  items: projects.map((project) {
                    return DropdownMenuItem(
                        value: project.id, child: Text(project.title));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedProjectId = value),
                  validator: (value) =>
                      value == null ? 'Please select a project' : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Assignee',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151)),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _selectedAssigneeId,
                  decoration: _dropdownDecoration(Icons.person_outline),
                  items: users.map((user) {
                    return DropdownMenuItem(
                        value: user.id, child: Text(user.username));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedAssigneeId = value),
                  validator: (value) =>
                      value == null ? 'Please select an assignee' : null,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.task == null ? 'CREATE TASK' : 'SAVE CHANGES',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(IconData? icon) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
