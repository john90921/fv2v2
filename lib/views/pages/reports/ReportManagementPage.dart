import 'package:flutter/material.dart';

class ReportManagementPage extends StatefulWidget {
  const ReportManagementPage({super.key});

  @override
  State<ReportManagementPage> createState() => _ReportManagementPageState();
}

class _ReportManagementPageState extends State<ReportManagementPage> {
  String selectedCategory = 'Post';

  final Map<String, List<Map<String, String>>> reports = {
    
  };

  @override
  Widget build(BuildContext context) {
    final currentReports = reports[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Management'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category tabs
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [
                selectedCategory == 'Post',
                selectedCategory == 'Comment',
                selectedCategory == 'Reply',
              ],
              onPressed: (index) {
                setState(() {
                  selectedCategory = ['Post', 'Comment', 'Reply'][index];
                });
              },
              borderRadius: BorderRadius.circular(10),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Post')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Comment')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Reply')),
              ],
            ),
          ),

          // Report list
          Expanded(
            child: currentReports.isEmpty
                ? const Center(child: Text('No reports found'))
                : ListView.builder(
                    itemCount: currentReports.length,
                    itemBuilder: (context, index) {
                      final report = currentReports[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(report['title']!),
                          subtitle: Text('Reported by: ${report['reporter']}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'View') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Viewing report ${report['id']}')),
                                );
                              } else if (value == 'Delete') {
                                setState(() {
                                  currentReports.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Deleted report ${report['id']}')),
                                );
                              } else if (value == 'Release') {
                                setState(() {
                                  currentReports.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Released report ${report['id']}')),
                                );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'View', child: Text('View')),
                              PopupMenuItem(value: 'Delete', child: Text('Delete')),
                              PopupMenuItem(value: 'Release', child: Text('Release')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
