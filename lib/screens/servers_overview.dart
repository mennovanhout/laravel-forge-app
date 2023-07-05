import 'package:flutter/material.dart';
import 'package:laravel_forge/widgets/server_list.dart';

class ServersOverviewScreen extends StatelessWidget {
  const ServersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servers'),
      ),
      body: const Center(
        child: ServerList(),
      ),
    );
  }
}
