import 'package:flutter/material.dart';
import 'package:jobasheet/src/constants/text_string.dart';
import 'package:jobasheet/src/features/authentification/screens/forget_password/forget_password_mail/forget_password_mail.dart';

import 'forget_password_btn_widget.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jForgetPasswordTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              jForgetPasswordSubTitle,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 20),
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mail_outline_rounded,
              title: "Email",
              subTitle: jResetViaEmail,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgetPasswordMailScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
