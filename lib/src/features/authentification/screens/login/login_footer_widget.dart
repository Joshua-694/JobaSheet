import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobasheet/src/constants/text_string.dart';
import 'package:jobasheet/src/features/authentification/screens/singup/singup_screen.dart';

class LoginFooterWidget extends StatefulWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  State<LoginFooterWidget> createState() => _LoginFooterWidgetState();
}

class _LoginFooterWidgetState extends State<LoginFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("OR"),
        SizedBox(height: 12),
        SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Get.to(() => SingUpScreen());
          },
          child: Text.rich(
            TextSpan(
              text: jAlready,
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: 'SingUp',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
