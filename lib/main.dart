import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/screens/login.dart';
import 'package:laravel_forge/screens/servers_overview.dart';
import 'package:laravel_forge/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var token = await storage.read(key: 'token');
  await Http().init();

  runApp(MyApp(token != null));
}

class MyApp extends StatelessWidget {
  const MyApp(this.hasToken, {super.key});

  final bool hasToken;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laravel Forge',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 24, 182, 155)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 24, 182, 155),
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 243, 244, 246),
          cardTheme: const CardTheme(
              elevation: 0,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)))),
          textTheme: GoogleFonts.figtreeTextTheme(
            Theme.of(context)
                .textTheme
                .apply(bodyColor: const Color.fromARGB(255, 107, 114, 128)),
          ),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 107, 114, 128))),
      home: hasToken ? const ServersOverviewScreen() : const LoginScreen(),
    );
  }
}
