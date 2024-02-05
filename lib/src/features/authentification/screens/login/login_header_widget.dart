import 'package:flutter/material.dart';
import 'package:jobasheet/src/constants/image_string.dart';
import 'package:jobasheet/src/constants/text_string.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage(jLoginImage),
          height: size.height * 0.3,
        ),
        Text(jLoginTitle, style: Theme.of(context).textTheme.headline2),
        Text(jLoginSubTitle, style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }
}
