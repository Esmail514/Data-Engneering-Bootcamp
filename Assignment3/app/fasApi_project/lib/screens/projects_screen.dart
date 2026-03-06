import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/project_card.dart';
import 'project_detail_screen.dart';
import 'project_form_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AppProvider>().fetchProjects(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.fetchProjects(),
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const Text('Projects'),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              if (provider.isLoading && provider.projects.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.projects.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_outline,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('No projects found',
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
                        final project = provider.projects[index];
                        return ProjectCard(
                          project: project,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailScreen(project: project),
                              ),
                            ).then((_) => provider.fetchProjects());
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectFormScreen(project: project),
                              ),
                            ).then((_) => provider.fetchProjects());
                          },
                          onDelete: () {
                            _showDeleteDialog(context, provider, project.id);
                          },
                        );
                      },
                      childCount: provider.projects.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addProjectFAB',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProjectFormScreen(),
            ),
          ).then((_) => provider.fetchProjects());
        },
        label: const Text('New Project'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProject(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
