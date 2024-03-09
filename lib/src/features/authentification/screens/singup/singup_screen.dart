import 'package:flutter/material.dart';
import 'package:jobasheet/src/common_widgets/form/form_header_widget.dart';
import 'package:jobasheet/src/constants/text_string.dart';
import 'package:jobasheet/src/features/authentification/screens/singup/singup_footer_widget.dart';
import 'package:jobasheet/src/features/authentification/screens/singup/singup_form_widget.dart';
import '../../../../constants/image_string.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                FormHeaderWidget(
                  image: jSingUpImage,
                  subTitle: jSingUpSubTitle,
                  title: jSingUpTitle,
                ),
                SingUpForm(),
                SingUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
