import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
  });

  final void Function()? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
