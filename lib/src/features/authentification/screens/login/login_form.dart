import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/firebaseauthservices/firebase_auth_services.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/widgets/dashboard.dart';
import '../forget_password/forget_password_option/forget_password_model_bottom_sheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();
  //controllers
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _passwordcontroller.dispose();
    _emailcontroller.dispose();

    super.dispose();
  }

  bool _isSecurePassword = true;

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
              controller: _emailcontroller,
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
              controller: _passwordcontroller,
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
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  singIn();
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

  void singIn() async {
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();

    User? user = await _auth.singInWithEmailAndPassword(email, password);
    //checking conditions
    FocusScope.of(context).unfocus();

    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Successfuly singed in",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            content: Image(
              image: AssetImage(
                "assets/images/check.png",
              ),
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
            title: Align(
              alignment: Alignment.center,
              child: Text(
                "Some error occured try again later!",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      );
    }
  }
}
