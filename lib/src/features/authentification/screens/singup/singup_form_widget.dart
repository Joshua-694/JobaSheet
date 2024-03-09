import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/firebaseauthservices/firebase_auth_services.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/dashboard.dart';

class SingUpForm extends StatefulWidget {
  const SingUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SingUpForm> {
  // instance of firebase
  final FirebaseAuthService _auth = FirebaseAuthService();

  // controllers
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmpasswordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // added _formKey

  @override
  void dispose() {
    _usernamecontroller.dispose();
    _passwordcontroller.dispose();
    _emailcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Form(
              key: _formKey, // assigned _formKey to the Form widget
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 4) {
                        return "Enter at least 4 characters";
                      } else {
                        return null;
                      }
                    },
                    controller: _usernamecontroller,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      label: Text("User Name"),
                      prefixIcon: Icon(Icons.person_2_rounded),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    validator: (value) {
                      final Pattern =
                          r'(^[a-zA-Z0-9_9.+-]+@[a-z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(Pattern);

                      if (!regExp.hasMatch(value!)) {
                        return "Enter a valid email";
                      } else {
                        return null;
                      }
                    },
                    controller: _emailcontroller,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 7) {
                        return "Password must be at least 7 characters long";
                      } else {
                        return null;
                      }
                    },
                    controller: _passwordcontroller,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 7) {
                        return "Password must be at least 7 characters long";
                      } else if (value != _passwordcontroller.text) {
                        return "Passwords do not match";
                      } else {
                        return null;
                      }
                    },
                    controller: _confirmpasswordcontroller,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text("Confirm Password"),
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          side: BorderSide(color: Colors.black)),
                      onPressed: signUp,
                      child: Text(
                        "SingUp".toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailcontroller.text;
      String password = _passwordcontroller.text;

      try {
        // Show CircularProgressIndicator while data is being fetched
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Creating user...'),
                ],
              ),
            );
          },
        );

        User? user = await _auth.singupWithEmailAndPassword(email, password);

        if (user != null) {
          String username = _usernamecontroller.text;

          // Store user details in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'username': username,
            'email': email,
            // Add other user details if needed
          });
          Navigator.pop(context); // Close the CircularProgressIndicator dialog
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(username: username)));
        } else {
          Navigator.pop(context); // Close the CircularProgressIndicator dialog

          // Show an error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to create user. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the error dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print("Error: $e");
        Navigator.pop(context); // Close the CircularProgressIndicator dialog
      }
    }
  }
}
