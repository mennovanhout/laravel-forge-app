import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/screens/server.dart';

class ServerList extends StatefulWidget {
  const ServerList({Key? key}) : super(key: key);

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  late Future<List<Server>> _loadedServers;

  @override
  initState() {
    super.initState();

    _loadedServers = _loadServers();
  }

  void showServer(Server server) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ServerScreen(server)));
  }

  Future<List<Server>> _loadServers() async {
    var response = await Http().dio.get('/servers');
    List<Server> servers = [];

    for (var server in response.data['servers']) {
      servers.add(Server.fromJson(server));
    }

    return servers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadedServers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // There is data
          return GridView.extent(
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: 200,
            childAspectRatio: 2,
            children: [
              for (var server in snapshot.data as List<Server>)
                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      showServer(server);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            server.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: const Color.fromARGB(
                                        255, 24, 182, 155)),
                          ),
                          const SizedBox(height: 10),
                          Text('${server.phpVersion}, ${server.databaseType}'
                              .toUpperCase()),
                          Text(server.publicIp),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          );
        });
  }
}
