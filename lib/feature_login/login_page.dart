import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:noteit/core/constants/constants.dart';
import 'package:noteit/entities/credentials.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  int selectedAccountIndex = -1; // Default to the first account
  String currUsername = '';
  String currPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add a delete button (only if an account is selected)
                  if (selectedAccountIndex != -1)
                    IconButton(
                      onPressed: () async {
                        await isarService.deleteCredentials(
                            credentialsList[selectedAccountIndex].id);
                        setState(() {
                          selectedAccountIndex = -1;
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  FutureBuilder<List<DropdownMenuItem<int>>>(
                    future: getAccountItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading indicator or placeholder
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // Error handling
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // DropdownButton once the data is ready
                        return DropdownButton<int>(
                          value: selectedAccountIndex,
                          onChanged: (index) {
                            setState(() {
                              selectedAccountIndex = index!;
                            });
                          },
                          items: snapshot.data!,
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (selectedAccountIndex == -1) ...[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () async {
                  if (selectedAccountIndex == -1) {
                    username = _usernameController.text;
                    password = _passwordController.text;
                    // Check if username or password is empty
                    if (username.isEmpty || password.isEmpty) {
                      // Show an alert dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content:
                              Text('Username or password cannot be empty.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    Credentials credentials = Credentials(username, password);
                    await isarService.saveCredentials(credentials);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AppState()),
                    );
                  } else {
                    // Login
                    Credentials? credentials = await isarService.getCredentials(
                        credentialsList[selectedAccountIndex].id);
                    if (credentials != null) {
                      username = credentials.username;
                      password = credentials.password;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AppState()),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<DropdownMenuItem<int>>> getAccountItems() async {
    List<DropdownMenuItem<int>> items = [];
    credentialsList = await isarService.getAllCredentials();

    items.add(
      DropdownMenuItem<int>(
        value: -1,
        child: Text('Add account'),
      ),
    );

    for (int i = 0; i < credentialsList.length; i++) {
      items.add(
        DropdownMenuItem<int>(
          value: i,
          child: Text('${credentialsList[i].username}'),
        ),
      );
    }

    return items;
  }
}
