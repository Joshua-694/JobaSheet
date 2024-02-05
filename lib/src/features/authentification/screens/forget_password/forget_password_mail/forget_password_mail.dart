import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/common_widgets/form/form_header_widget.dart';
import 'package:jobasheet/src/constants/image_string.dart';
import 'package:jobasheet/src/constants/text_string.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  ForgetPasswordMailScreen({super.key});

  @override
  State<ForgetPasswordMailScreen> createState() =>
      _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  TextEditingController _emailcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30 * 4),
                FormHeaderWidget(
                  image: jForgetPasswordImage,
                  subTitle: jForgetPasswordSubTitle,
                  title: jForgetPassword,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        label: Text('Email'),
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          side: BorderSide(color: Colors.black)),
                      onPressed: passwordReset,
                      child: Text("Reset Passsword"),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
