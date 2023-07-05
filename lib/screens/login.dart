import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/screens/servers_overview.dart';
import 'package:laravel_forge/storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _errorText;
  var _enteredToken = '';
  var _isChecking = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isChecking = true;
        _errorText = null;
      });

      Http()
          .dio
          .get('/user',
              options:
                  Options(headers: {'Authorization': 'Bearer $_enteredToken'}))
          .then((value) async {
        await storage.write(key: 'token', value: _enteredToken);

        await Http().init();

        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ServersOverviewScreen()));
        }
      }).catchError((error) {
        setState(() {
          _errorText = 'Invalid API Token';
        });
      }).whenComplete(() {
        setState(() {
          _isChecking = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-In'),
      ),
      body: Center(
          child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.all(22.0),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    heightFactor: 1,
                    child: Text(
                      'Sign in to your account',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                const SizedBox(
                  height: 22,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'API Token',
                            errorText: _errorText,
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid token';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredToken = value!;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                ElevatedButton(
                    onPressed: _isChecking ? null : _submitForm,
                    child: _isChecking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                        : const Text('Continue')),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
