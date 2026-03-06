import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/user_card.dart';
import 'user_detail_screen.dart';
import 'user_form_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AppProvider>().fetchUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.fetchUsers(),
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Text('Community'),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              if (provider.isLoading && provider.users.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.users.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No users found',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final user = provider.users[index];
                        return UserCard(
                          user: user,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserDetailScreen(user: user),
                              ),
                            ).then((_) => provider.fetchUsers());
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserFormScreen(user: user),
                              ),
                            ).then((_) => provider.fetchUsers());
                          },
                          onDelete: () {
                            _showDeleteDialog(context, provider, user.id);
                          },
                        );
                      },
                      childCount: provider.users.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addUserFAB',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserFormScreen(),
            ),
          ).then((_) => provider.fetchUsers());
        },
        label: const Text('Add User'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteUser(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
