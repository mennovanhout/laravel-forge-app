import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';
import 'package:laravel_forge/screens/site.dart';
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

  void _openSite(Site site) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SiteScreen(widget.server, site)));
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
      items.add(Expanded(
        child: Row(
          children: [
            const Icon(
              UniconsLine.github,
              size: 20,
            ),
            Expanded(
              child: Text(
                '${site.repository!}:${site.repositoryBranch!}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ));

      items.add(const SizedBox(width: 5));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(child: CircularProgressIndicator());

    if (_sites != null) {
      body = GridView.extent(
          padding: const EdgeInsets.all(10),
          maxCrossAxisExtent: 400,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3,
          children: [
            for (var site in _sites!)
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    _openSite(site);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subInfo(site).isNotEmpty
                            ? const SizedBox(height: 5)
                            : Container(),
                        Row(
                          children: [
                            for (var item in subInfo(site)) item,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]);
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
