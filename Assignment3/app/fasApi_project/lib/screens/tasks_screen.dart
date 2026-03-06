import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AppProvider>().fetchTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.fetchTasks(),
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Text('Tasks'),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.filter_list_outlined),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              if (provider.isLoading && provider.tasks.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.tasks.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt_outlined,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No tasks found',
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
                        final task = provider.tasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailScreen(task: task),
                              ),
                            ).then((_) => provider.fetchTasks());
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskFormScreen(task: task),
                              ),
                            ).then((_) => provider.fetchTasks());
                          },
                          onDelete: () {
                            _showDeleteDialog(context, provider, task.id);
                          },
                        );
                      },
                      childCount: provider.tasks.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addTaskFAB',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          ).then((_) => provider.fetchTasks());
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTask(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
