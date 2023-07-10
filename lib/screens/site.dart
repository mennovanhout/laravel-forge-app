import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';
import 'package:laravel_forge/widgets/site/deployment.dart';
import 'package:laravel_forge/widgets/site/deployment_branch.dart';
import 'package:laravel_forge/widgets/site/deployment_trigger_url.dart';

class SiteScreen extends StatelessWidget {
  const SiteScreen(this.server, this.site, {super.key});

  final Site site;
  final Server server;

  void _deploy(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: const Text('Deploy'),
      content: const Text('Are you sure you want to deploy?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Deploying...'),
            ));

            Http().dio.post(
                '/servers/${server.id}/sites/${site.id}/deployment/deploy');
          },
          child: const Text('Deploy'),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(site.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: () {
                _deploy(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Deployment(server, site),
              const SizedBox(height: 10),
              DeploymentTriggerURL(server, site),
              const SizedBox(height: 10),
              DeploymentBranch(server, site)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.cloud_upload),
          onPressed: () {
            _deploy(context);
          },
        ));
  }
}
