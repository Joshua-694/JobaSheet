import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/dashboard.dart';
import 'package:jobasheet/src/firebase_auth_implementation/firebase_auth_services.dart';

class SingUpForm extends StatefulWidget {
  const SingUpForm({
    super.key,
  });

  @override
  State<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SingUpForm> {
//instance of firebase
  final FirebaseAuthService _auth = FirebaseAuthService();

  //controllers
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confirmpasswordcontroller = TextEditingController();

  @override
  void dispose() {
    _usernamecontroller.dispose();
    _passwordcontroller.dispose();
    _emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
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
                      onPressed: singUp,
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

  void singUp() async {
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;

    User? user = await _auth.singUpWithEmailAndPassword(email, password);
    //checking conditions

    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("User is successfuly created",
                style: TextStyle(color: Colors.green)),
            content: Image(
              image: AssetImage("assets/images/check.png"),
              width: 70,
              height: 70,
            ),
          );
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Some error occured please try again later!",
              style: TextStyle(color: Colors.red),
            ),
            content: Image.asset(
              "assets/images/warning.png",
              width: 70,
              height: 70,
            ),
          );
        },
      );
    }
  }
}
