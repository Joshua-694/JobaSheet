import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.heightBetween,
    this.imageColor,
    this.imageHeight = 0.2,
    required this.image,
    required this.subTitle,
    required this.title,
    this.textAlign,
    super.key,
  });
  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final double? heightBetween;
  final double imageHeight;
  final Color? imageColor;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage(image),
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        Text(subTitle,
            textAlign: textAlign, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
