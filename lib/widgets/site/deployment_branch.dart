import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laravel_forge/http.dart';
import 'package:laravel_forge/models/server.dart';
import 'package:laravel_forge/models/site.dart';

class DeploymentBranch extends StatefulWidget {
  const DeploymentBranch(this.server, this.site, {super.key});

  final Server server;
  final Site site;

  @override
  State<DeploymentBranch> createState() => _DeploymentBranchState();
}

class _DeploymentBranchState extends State<DeploymentBranch> {
  final _formKey = GlobalKey<FormState>();
  String? _errorText;
  var _enteredBranch = '';
  bool _isLoading = false;

  void _updateBranch() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _errorText = null;
        _isLoading = true;
      });

      try {
        await Http().dio.put(
          '/servers/${widget.server.id}/sites/${widget.site.id}/git',
          data: {
            'branch': _enteredBranch,
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Branch updated')),
        );
      } on DioException catch (e) {
        if (e.response!.statusCode == 422) {
          _errorText = 'Branch not found';
        } else {
          _errorText = 'Something went wrong';
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
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
              "Deployment Branch",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.site.repositoryBranch ?? '',
                        decoration: InputDecoration(
                          labelText: 'Branch',
                          errorText: _errorText,
                        ),
                        onSaved: (value) {
                          _enteredBranch = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a branch';
                          }

                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      iconSize: 18,
                      onPressed: _isLoading ? null : _updateBranch,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 24, 182, 155)),
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      icon: _isLoading
                          ? Container(
                              width: 18,
                              height: 18,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_alt),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
