import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';

class DeploymentTriggerURL extends StatelessWidget {
  const DeploymentTriggerURL(this.server, this.site, {super.key});

  final Server server;
  final Site site;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deployment Trigger URL",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 255, 247, 230)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: site.deploymentUrl));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Copied to clipboard"),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.copy,
                            color: Color.fromARGB(255, 250, 176, 5),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              site.deploymentUrl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
