import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextTag extends StatelessWidget {
  final Widget? icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const TextTag({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: 2,
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            icon != null ? icon! : const SizedBox(),
            SizedBox(width: icon != null ? 5 : 0),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
