import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_tracker/widgets/left_drawer.dart';
import 'package:mental_health_tracker/screens/menu.dart';

class MoodEntryFormPage extends StatefulWidget {
  const MoodEntryFormPage({super.key});

  @override
  State<MoodEntryFormPage> createState() => _MoodEntryFormPageState();
}

class _MoodEntryFormPageState extends State<MoodEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _mood = "";
  String _feelings = "";
  int _moodIntensity = 0;

  // Function to reset the form
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _mood = "";
      _feelings = "";
      _moodIntensity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Your Mood Today',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mood Input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Mood",
                    labelText: "Mood",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _mood = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Mood cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),

              // Feelings Input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Feelings",
                    labelText: "Feelings",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _feelings = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Feelings cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),

              // Mood Intensity Input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Mood Intensity (0 to 10)",
                    labelText: "Mood Intensity",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _moodIntensity = int.tryParse(value ?? '0') ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Mood intensity cannot be empty!";
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0 || int.parse(value) > 10) {
                      return "Please enter a valid intensity between 0 and 10!";
                    }
                    return null;
                  },
                ),
              ),

              // Save Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                          // Send request to Django and wait for the response
                          // TODO: Change the URL to your Django app's URL. Don't forget to add the trailing slash (/) if needed.
                          final response = await request.postJson(
                              "http://localhost:8000/create-flutter/",
                              jsonEncode(<String, String>{
                                  'mood': _mood,
                                  'feelings': _feelings,
                                  'mood_intensity': _moodIntensity.toString(),
                              }),
                          );
                          if (context.mounted) {
                              if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                  content: Text("New mood has saved successfully!"),
                                  ));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyHomePage()),
                                  );
                              } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                          Text("Something went wrong, please try again."),
                                  ));
                              }
                          }
                      }
                  },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
