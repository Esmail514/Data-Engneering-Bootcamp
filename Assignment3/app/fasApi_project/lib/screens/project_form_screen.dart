import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/app_provider.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  int? _selectedOwnerId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    _selectedOwnerId =
        widget.project?.owner.id == 0 ? null : widget.project?.owner.id;

    // Fetch users for the dropdown
    Future.microtask(() => context.read<AppProvider>().fetchUsers());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedOwnerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an owner')),
        );
        return;
      }

      final provider = context.read<AppProvider>();
      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'owner_id': _selectedOwnerId,
      };

      if (widget.project == null) {
        await provider.addProject(data);
      } else {
        await provider.updateProject(widget.project!.id, data);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = context.watch<AppProvider>().users;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
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
                  'Project Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Provide the core information for your project.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _titleController,
                  label: 'Project Title',
                  icon: Icons.title_outlined,
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
                const Text(
                  'Project Lead',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _selectedOwnerId,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user.id,
                      child: Text(user.username),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedOwnerId = value),
                  validator: (value) =>
                      value == null ? 'Please select an owner' : null,
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
                      widget.project == null
                          ? 'CREATE PROJECT'
                          : 'SAVE CHANGES',
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
