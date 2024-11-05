import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final Size screenSize;
  const Footer({super.key, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFF3F2F5)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            0, 0.015 * screenSize.height, 0, 0.03 * screenSize.height),
        child: const Text(
          "Password Guard System\n© 2024 Newa Technologies",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "DMSans",
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 15.62 / 12,
          ),
        ),
      ),
    );
  }
}
