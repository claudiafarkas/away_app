import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// TODO: add imported video. filters, sorting, + folder, folder sharing with other users, search bar

class MyImportsTabScreen extends StatefulWidget {
  const MyImportsTabScreen({super.key});

  @override
  State<MyImportsTabScreen> createState() => _MyImportsTabScreenState();
}

class _MyImportsTabScreenState extends State<MyImportsTabScreen> {
  // folder name → list of videos
  Map<String, List<Map<String, dynamic>>> folders = {
    "All Videos": [
      {"caption": "Beach Hike", "thumbnail": Icons.terrain},
    ],
    "Island Vibes": [
      {"caption": "Mentawai Islands", "thumbnail": Icons.landscape},
    ],
    "Euro Trip '25": [
      {"caption": "Paris Getaway", "thumbnail": Icons.location_city},
    ],
  };

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
      appBar: AppBar(title: const Text("My Videos")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create Folder Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.create_new_folder),
                label: const Text("Create Folder"),
                onPressed: _showCreateFolderDialog,
              ),
            ),
            const SizedBox(height: 16),

            // Folder sections
            ...folders.entries.map((entry) {
              final folderName = entry.key;
              final videos = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Folder header with delete button
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
                      if (folderName !=
                          "All Videos") // Don't allow deleting default folder
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

                  // Videos grid or placeholder
                  videos.isEmpty
                      ? const Text(
                        "No videos yet.",
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
                          final video = videos[index];
                          return Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(video['thumbnail'], size: 60),
                                  const SizedBox(height: 8),
                                  Text(
                                    video['caption'],
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
            }),
          ],
        ),
      ),
    );
  }
}
  // show saved video
  // search bar
  // folder creation icon and function

