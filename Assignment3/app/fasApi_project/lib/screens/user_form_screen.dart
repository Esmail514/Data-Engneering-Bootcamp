import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_provider.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.user?.username ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _passwordController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AppProvider>();
      final data = {
        'username': _usernameController.text,
        'phone': _phoneController.text,
        if (_passwordController.text.isNotEmpty)
          'password': _passwordController.text,
      };

      if (widget.user == null) {
        await provider.addUser(data);
      } else {
        await provider.updateUser(widget.user!.id, data);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
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
                  'User Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please fill in the details below to ${widget.user == null ? 'create a new' : 'edit the'} user account.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person_outline,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a username'
                      : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: widget.user == null
                      ? 'Password'
                      : 'New Password (Optional)',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (widget.user == null &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
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
                      widget.user == null ? 'CREATE ACCOUNT' : 'SAVE CHANGES',
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
    bool obscureText = false,
    TextInputType? keyboardType,
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
          obscureText: obscureText,
          keyboardType: keyboardType,
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
