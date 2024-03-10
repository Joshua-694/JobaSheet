import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobasheet/src/features/authentification/screens/forget_password/forget_password_option/forget_password_model_bottom_sheet.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/dashboard.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      print("Error signing in: $error");
      throw "Error signing in. Please try again.";
    }
  }

  Future<String> fetchUsernameFromDatabase(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        // Assuming you have a 'username' field in your user document
        String username = userSnapshot['username'];
        return username;
      } else {
        throw "User document not found in the database.";
      }
    } catch (error) {
      print("Error fetching username: $error");
      throw "Error fetching username from the database.";
    }
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isSecurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              controller: _emailController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value!.length < 7) {
                  return "Password must be at least 7 characters long";
                } else {
                  return null;
                }
              },
              obscureText: _isSecurePassword,
              controller: _passwordController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: togglePassword(),
                prefixIcon: Icon(Icons.fingerprint),
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: Text('Forget Password?'),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  side: BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  signIn();
                  _formKey.currentState?.validate();
                },
                child: Text('Login'.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget togglePassword() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      child: _isSecurePassword
          ? Icon(Icons.visibility, color: Colors.grey)
          : Icon(Icons.visibility_off, color: Colors.grey),
    );
  }

  void signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Show loading indicator while fetching data
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent users from closing the dialog
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Signing In..."),
              ],
            ),
          );
        },
      );

      // Checking conditions
      FocusScope.of(context).unfocus();

      if (email.isEmpty || password.isEmpty) {
        throw ("Please enter both email and password.");
      }

      User? user = await _auth.signInWithEmailAndPassword(email, password);

      // Dismiss the loading indicator
      Navigator.pop(context);

      if (user != null) {
        try {
          String username = await _auth.fetchUsernameFromDatabase(user.uid);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                username: username,
              ),
            ),
          );
        } catch (error) {
          print("Error: $error");
          // Handle error fetching username
        }
      } else {
        throw ("Invalid email or password. Please try again.");
      }
    } catch (error) {
      // Handle errors here
      print("Error: $error");
    }
  }
}
