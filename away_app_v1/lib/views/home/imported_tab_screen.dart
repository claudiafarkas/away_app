import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:away_app_v1/services/import_service.dart';

class MyImportsTabScreen extends StatefulWidget {
  const MyImportsTabScreen({super.key});

  @override
  State<MyImportsTabScreen> createState() => _MyImportsTabScreenState();
}

class _MyImportsTabScreenState extends State<MyImportsTabScreen> {
  late Map<String, List<Map<String, dynamic>>> folders;

  @override
  void initState() {
    super.initState();
    // All imported items go under "All Locations"
    folders = {"All Locations": ImportService.instance.importedLocations};
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("New Folder"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Folder name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty && !folders.containsKey(name)) {
                    setState(() => folders[name] = []);
                  }
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Imports")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.create_new_folder),
                label: const Text("Create Folder"),
                onPressed: _showCreateFolderDialog,
              ),
            ),
            const SizedBox(height: 16),

            ...folders.entries.map((entry) {
              final folderName = entry.key;
              final videos = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        folderName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (folderName != "All Locations")
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() => folders.remove(folderName));
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  videos.isEmpty
                      ? const Text(
                        "No items imported yet.",
                        style: TextStyle(color: Colors.white70),
                      )
                      : MasonryGridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final item = videos[index];
                          final name = item['name'] as String? ?? 'Unknown';
                          return Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_pin, size: 60),
                                  const SizedBox(height: 8),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                  const SizedBox(height: 32),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
