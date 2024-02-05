import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobasheet/src/constants/image_string.dart';
import 'package:jobasheet/src/features/authentification/screens/login/login_screen.dart';

class SingUpFooterWidget extends StatefulWidget {
  const SingUpFooterWidget({
    super.key,
  });

  @override
  State<SingUpFooterWidget> createState() => _SingUpFooterWidgetState();
}

class _SingUpFooterWidgetState extends State<SingUpFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("OR"),
        SizedBox(height: 15),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              side: BorderSide(color: Colors.black)),
          onPressed: () {},
          icon: Image(
            image: AssetImage(jGoogleImage),
            width: 20.0,
          ),
          label: Text(
            'Sing in with Google',
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => LoginScreen());
          },
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Already have an Account?',
                    style: Theme.of(context).textTheme.bodyText1),
                TextSpan(text: 'Login'.toUpperCase()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
