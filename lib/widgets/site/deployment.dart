import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';
import 'package:laravel_forge/widgets/site/deployment_log.dart';

class Deployment extends StatefulWidget {
  const Deployment(
    this.server,
    this.site, {
    super.key,
  });

  final Server server;
  final Site site;

  @override
  State<Deployment> createState() => _DeploymentState();
}

class _DeploymentState extends State<Deployment> {
  bool _isLoading = false;

  void _showLatestDeploymentLog(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) => DeploymentLog(widget.server, widget.site));
  }

  void _toggleQuickDeploy() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.site.quickDeploy) {
      await Http().dio.delete(
          '/servers/${widget.server.id}/sites/${widget.site.id}/deployment');
    } else {
      await Http().dio.post(
          '/servers/${widget.server.id}/sites/${widget.site.id}/deployment');
    }

    setState(() {
      _isLoading = false;
      widget.site.quickDeploy = !widget.site.quickDeploy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deployment",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
                "Quick deploy allows you to easily deploy your projects when you push to source control. When you push to this application's deployment branch, Forge will pull your latest code from source control and execute your deployment script."),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: widget.site.quickDeploy
                      ? ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white)
                      : ElevatedButton.styleFrom(),
                  onPressed: _isLoading ? null : _toggleQuickDeploy,
                  child: Row(
                    children: [
                      _isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      widget.site.quickDeploy
                          ? const Text("Disable Quick Deploy")
                          : const Text("Enable Quick Deploy"),
                    ],
                  ),
                ),
                ElevatedButton(
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                    onPressed: () {
                      _showLatestDeploymentLog(context);
                    },
                    child: const Text("View Latest Log"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
