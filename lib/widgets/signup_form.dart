import "package:flutter/material.dart";

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "DMSans",
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 31.25 / 24,
                color: Color(0xFF2F2B3D)),
          ),
          SizedBox(
            height: 0.03 * screenSize.height,
          ),
          TextFormField(
            controller: emailCtr,
            validator: (value) {
              RegExp emailRegExp =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (value == null || value.isEmpty) {
                return "Enter email";
              } else if (!emailRegExp.hasMatch(value)) {
                return "Enter valid email";
              }
              return null;
            },
            decoration: InputDecoration(
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              border: borderStyle,
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              prefixIcon: const Icon(
                Icons.mail_outline,
                size: 20,
                color: Colors.blueGrey,
              ),
              label: const Text(
                "Email",
                style: TextStyle(
                    color: Color(0xFFABA8B1),
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 18.23 / 14),
              ),
            ),
          ),
          SizedBox(
            height: 0.015 * screenSize.height,
          ),
          TextFormField(
            controller: passwordCtr,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter password";
              } else if (value.length < 6) {
                return "Password cannot be shorter than 6 digit";
              }
              return null;
            },
            decoration: InputDecoration(
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              border: borderStyle,
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              prefixIcon: const Icon(
                Icons.lock_outline,
                size: 20,
                color: Colors.blueGrey,
              ),
              label: const Text(
                "Password",
                style: TextStyle(
                    color: Color(0xFFABA8B1),
                    fontFamily: "DMSans",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 18.23 / 14),
              ),
            ),
          ),
          SizedBox(
            height: 0.015 * screenSize.height,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blueGrey.shade700),
                      onPressed: () async {},
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontFamily: "DMSans",
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFFFF),
                          height: 18.23 / 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
