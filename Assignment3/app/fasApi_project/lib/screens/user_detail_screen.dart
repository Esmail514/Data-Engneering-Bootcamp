import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  Future<void> _refreshData() async {
    final provider = context.read<AppProvider>();
    await provider.fetchUsers();
    // Update local user state from provider to reflect changes
    final updatedUser = provider.users
        .firstWhere((u) => u.id == _currentUser.id, orElse: () => _currentUser);
    setState(() {
      _currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Implementation for edit could go here
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
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.3),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          _currentUser.username[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _currentUser.username,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser.phone ?? 'No phone number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
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
                      'Account Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoCard(
                      context,
                      [
                        _infoTile(context, Icons.fingerprint, 'User ID',
                            _currentUser.id.toString()),
                        _infoTile(
                          context,
                          Icons.calendar_today_outlined,
                          'Created On',
                          DateFormat('MMMM d, yyyy')
                              .format(_currentUser.createdAt),
                        ),
                        _infoTile(
                          context,
                          Icons.update_outlined,
                          'Last Updated',
                          DateFormat('MMMM d, yyyy')
                              .format(_currentUser.updatedAt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Go Back'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
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

  Widget _infoCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: children,
      ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.primary, size: 22),
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
          ),
        ],
      ),
    );
  }
}
