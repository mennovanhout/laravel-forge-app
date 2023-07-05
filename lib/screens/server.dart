import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';
import 'package:unicons/unicons.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen(this.server, {super.key});

  final Server server;

  @override
  _ServerScreenState createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  List<Site>? _sites;

  @override
  void initState() {
    super.initState();

    _loadSites();
  }

  void _loadSites() async {
    var response = await Http().dio.get('/servers/${widget.server.id}/sites');

    List<Site> sites = [];

    for (var site in response.data['sites']) {
      sites.add(Site.fromJson(site));
    }

    setState(() {
      _sites = sites;
    });
  }

  List<Widget> subInfo(Site site) {
    List<Widget> items = [];

    if (site.telegramChatId != null) {
      items.add(const Icon(
        UniconsLine.telegram,
        size: 20,
      ));

      items.add(const SizedBox(width: 5));
    }

    if (site.slackChannel != null) {
      items.add(const Icon(
        UniconsLine.slack,
        size: 20,
      ));

      items.add(const SizedBox(width: 5));
    }

    if (site.repository != null) {
      items.add(Row(
        children: [
          const Icon(
            UniconsLine.github,
            size: 20,
          ),
          Text(
            '${site.repository!}:${site.repositoryBranch!}',
            overflow: TextOverflow.ellipsis,
          )
        ],
      ));

      items.add(const SizedBox(width: 5));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(child: CircularProgressIndicator());

    if (_sites != null) {
      body = ListView.builder(
          itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_sites![index].name),
                        subInfo(_sites![index]).isNotEmpty
                            ? const SizedBox(height: 5)
                            : Container(),
                        Row(
                          children: [
                            for (var item in subInfo(_sites![index]))
                              Container(child: item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          itemCount: _sites!.length);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server.name),
      ),
      body: Center(
        child: body,
      ),
    );
  }
}
