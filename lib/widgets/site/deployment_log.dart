import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/dracula.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';
import 'package:tint/tint.dart';

class DeploymentLog extends StatefulWidget {
  const DeploymentLog(this.server, this.site, {super.key});

  final Server server;
  final Site site;

  @override
  _DeploymentLogState createState() => _DeploymentLogState();
}

class _DeploymentLogState extends State<DeploymentLog> {
  late Future<String> _loadedLog;

  @override
  void initState() {
    super.initState();

    _loadedLog = _loadLog();
  }

  Future<String> _loadLog() async {
    var response = await Http().dio.get(
        '/servers/${widget.server.id}/sites/${widget.site.id}/deployment/log');

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadedLog,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        // There is data
        return Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: HighlightView(
                padding: const EdgeInsets.all(10),
                snapshot.data!.strip(),
                language: 'console',
                theme: draculaTheme,
              ),
            ),
          ),
        );
      },
    );
  }
}
