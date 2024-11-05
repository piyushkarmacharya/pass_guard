import 'package:flutter/material.dart';
import 'package:pass_guard/constants/strings.dart';
import 'package:pass_guard/widgets/footer.dart';
import 'package:pass_guard/widgets/my_painter.dart';
import 'package:pass_guard/widgets/signup_form.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/signup-page";

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final keyboardActive = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          if (keyboardActive == 0.0)
            CustomPaint(
              painter: MyPainter(),
              child: Container(),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: keyboardActive == 0.0
                    ? 0.15 * screenSize.height
                    : 0.07 * screenSize.height,
              ),
              SizedBox(
                height: keyboardActive == 0.0
                    ? 0.25 * screenSize.height
                    : 0.1 * screenSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (keyboardActive == 0.0)
                      SizedBox(
                        width: 0.5 * screenSize.width,
                        height: 0.12 * screenSize.height,
                        child: Image.asset(
                          "assets/images/lock.png",
                        ),
                      ),
                    SizedBox(
                      height: 0.015 * screenSize.height,
                    ),
                    const Text(
                      Strings.mainTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 28,
                        fontFamily: "PublicSans",
                        fontWeight: FontWeight.w500,
                        height: 42 / 28,
                      ),
                    ),
                    SizedBox(
                      height: 0.015 * screenSize.height,
                    ),
                    if (keyboardActive == 0.0)
                      const Text(
                        Strings.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                          height: 22 / 15,
                          fontFamily: "PublicSans",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: keyboardActive == 0.0
                    ? 0.1 * screenSize.height
                    : 0.01 * screenSize.height,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFF3F2F5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 22.0),
                      child: Column(
                        children: [
                          const SignupForm(),
                          if (keyboardActive == 0.0)
                            Footer(screenSize: screenSize)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
