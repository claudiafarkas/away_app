import 'package:flutter/material.dart';
import 'imported_tab_screen.dart';
import 'feed_tab_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MyHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Away'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Feed'), Tab(text: 'My Imports')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [MyFeedTab(), MyImportsTab()],
      ),
    );
  }
}
