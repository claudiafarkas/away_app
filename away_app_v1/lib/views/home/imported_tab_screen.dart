import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:away_app_v1/services/import_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyImportsTabScreen extends StatefulWidget {
  const MyImportsTabScreen({super.key});

  @override
  State<MyImportsTabScreen> createState() => _MyImportsTabScreenState();
}

class _MyImportsTabScreenState extends State<MyImportsTabScreen> {
  // Instead of a static folders map, keep track of custom boards only.
  List<String> _boardNames = ["All Locations"];
  Map<String, List<Map<String, dynamic>>> _customBoards = {};
  Set<int> _selectedIndices = {};
  bool _isSelectionMode = false;

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
                  if (name.isNotEmpty && !_boardNames.contains(name)) {
                    setState(() {
                      _boardNames.add(name);
                      _customBoards[name] = [];
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          ),
    );
  }

  void _createFolderAndAssign() {
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
                  // only create if name is non-empty and not already a board
                  if (name.isNotEmpty && !_boardNames.contains(name)) {
                    final allPins = ImportService.instance.importedLocations;
                    setState(() {
                      // Add new board
                      _boardNames.add(name);
                      _customBoards[name] = [];

                      // move each selected pin from "All Locations" into this board
                      for (var idx in _selectedIndices) {
                        if (idx >= 0 && idx < allPins.length) {
                          _customBoards[name]!.add(allPins[idx]);
                        }
                      }

                      // Clear selection mode
                      _selectedIndices.clear();
                      _isSelectionMode = false;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          ),
    );
  }

  void _addToFolder() {
    final folderNames = _boardNames;
    showDialog(
      context: context,
      builder:
          (_) => SimpleDialog(
            title: const Text("Select Folder"),
            children: [
              ...folderNames.map((fname) {
                return SimpleDialogOption(
                  onPressed: () {
                    if (fname != "All Locations" &&
                        _customBoards.containsKey(fname)) {
                      final allPins = ImportService.instance.importedLocations;
                      setState(() {
                        for (var idx in _selectedIndices) {
                          if (idx >= 0 && idx < allPins.length) {
                            _customBoards[fname]!.add(allPins[idx]);
                          }
                        }
                        _selectedIndices.clear();
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text(fname),
                );
              }).toList(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _createFolderAndAssign();
                },
                child: const Text("Create New Folder"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> folders = {
      "All Locations": ImportService.instance.importedLocations,
      ..._customBoards,
    };
    final boardNames = folders.keys.toList();

    return DefaultTabController(
      length: boardNames.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          title: const Text("Your saved imports"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isSelectionMode = !_isSelectionMode;
                  if (!_isSelectionMode) _selectedIndices.clear();
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: Text(_isSelectionMode ? "Cancel" : "Select"),
            ),
            TextButton(
              onPressed: _showCreateFolderDialog,
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: const Text("+", style: TextStyle(fontSize: 24)),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs:
                boardNames.map((name) {
                  return Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(name),
                        const SizedBox(width: 4),
                        if (folders[name]!.isNotEmpty)
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black26,
                            child: Text(
                              folders[name]!.length.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
        body: TabBarView(
          children:
              boardNames.map((board) {
                final pinList = folders[board]!;
                if (pinList.isEmpty) {
                  return Center(
                    child: Text(
                      "No pins in \"$board\" yet.",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: pinList.length,
                    itemBuilder: (context, index) {
                      final pin = pinList[index];
                      final pinName = pin['name'] as String? ?? 'Unknown';
                      final pinAddress = pin['address'] as String? ?? '';
                      double? lat;
                      double? lng;
                      try {
                        lat = (pin['lat'] as num).toDouble();
                        lng = (pin['lng'] as num).toDouble();
                      } catch (_) {
                        lat = null;
                        lng = null;
                      }
                      final isSelected = _selectedIndices.contains(index);

                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_isSelectionMode &&
                                  board == "All Locations") {
                                setState(() {
                                  if (isSelected)
                                    _selectedIndices.remove(index);
                                  else
                                    _selectedIndices.add(index);
                                });
                              } else if (!_isSelectionMode) {
                                if (lat != null && lng != null) {
                                  ImportService.instance.clearAll();
                                  ImportService.instance.addLocations([
                                    {
                                      'name': pinName,
                                      'address': pinAddress,
                                      'lat': lat,
                                      'lng': lng,
                                    },
                                  ]);
                                  Navigator.pushNamed(context, '/map');
                                }
                              }
                            },
                            child: Card(
                              color:
                                  isSelected ? Colors.blue[100] : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.play_circle_outline,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      pinName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pinAddress,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    if (lat != null && lng != null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Icon(Icons.map, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_isSelectionMode && board == "All Locations")
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true)
                                      _selectedIndices.add(index);
                                    else
                                      _selectedIndices.remove(index);
                                  });
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              }).toList(),
        ),
        bottomNavigationBar:
            (_isSelectionMode && _selectedIndices.isNotEmpty)
                ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _addToFolder,
                    icon: const Icon(Icons.folder_open),
                    label: const Text("Add Selected to Folder"),
                  ),
                )
                : null,
      ),
    );
  }
}
