import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:noteit/core/constants/constants.dart';
import 'package:noteit/entities/user.dart';

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
  String currProfilePicture = '';

  void _changeProfilePicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        currProfilePicture = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  if (selectedAccountIndex != -1 && selectedAccountIndex != -2)
                    IconButton(
                      onPressed: () async {
                        await isarService.deleteCredentials(
                            credentialsList[selectedAccountIndex].id);
                        setState(() {
                          selectedAccountIndex = -1;
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  FutureBuilder<List<DropdownMenuItem<int>>>(
                    future: getAccountItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading indicator or placeholder
                        return const CircularProgressIndicator();
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
              const SizedBox(height: 16),
              if (selectedAccountIndex == -1) ...[
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ],
              if (selectedAccountIndex == -2) ...[
                InkWell(
                  onTap: _changeProfilePicture,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (currProfilePicture.isNotEmpty)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(currProfilePicture)),
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () async {
                  switch (selectedAccountIndex) {
                    case -1:
                      username = _usernameController.text;
                      password = _passwordController.text;
                      // Check if username or password in database
                      if (await isarService.verifyCredentials(
                          username, password)) {
                        // Login
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AppState()),
                        );
                      } else {
                        // Show an alert dialog
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Username or password is incorrect.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      break;
                    case -2:
                      username = _usernameController.text;
                      password = _passwordController.text;
                      profilePicture = currProfilePicture;
                      // Check if username or password is empty
                      if (username.isEmpty ||
                          password.isEmpty ||
                          profilePicture.isEmpty) {
                        // Show an alert dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Username or password cannot be empty or profile picture is not selected.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      UserEntity credentials =
                          UserEntity(username, password, profilePicture);
                      await isarService.saveCredentials(credentials);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AppState()),
                      );
                      break;
                    default:
                      // Login
                      UserEntity? credentials =
                          await isarService.getCredentials(
                              credentialsList[selectedAccountIndex].id);
                      if (credentials != null) {
                        username = credentials.username;
                        password = credentials.password;
                        profilePicture = credentials.profilePicture;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AppState()),
                        );
                      }
                      break;
                  }
                },
                child: const Text('Login'),
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
      const DropdownMenuItem<int>(
        value: -1,
        child: Text('Login'),
      ),
    );

    items.add(
      const DropdownMenuItem<int>(
        value: -2,
        child: Text('Create account'),
      ),
    );

    for (int i = 0; i < credentialsList.length; i++) {
      items.add(
        DropdownMenuItem<int>(
          value: i,
          child: Row(
            children: [
              if (credentialsList[i].profilePicture.isNotEmpty)
                CircleAvatar(
                  backgroundImage:
                      FileImage(File(credentialsList[i].profilePicture)),
                ),
              const SizedBox(width: 8),
              Text('${credentialsList[i].username}'),
            ],
          ),
        ),
      );
    }

    return items;
  }
}
