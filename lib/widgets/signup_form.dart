import "package:flutter/material.dart";
import "package:pass_guard/database/user_table.dart";
import "package:pass_guard/models/user.dart";
import "package:pass_guard/services/secure_storage.dart";

class SignupForm extends StatefulWidget {
  final Function onSignup;
  const SignupForm({super.key, required this.onSignup});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernamectr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<int> signup() async {
    int temp = await UserTable()
        .create(username: usernamectr.text, password: passwordCtr.text);
    return temp;
  }

  bool loading = false;

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
            controller: usernamectr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter username";
              } else if (value.length < 6) {
                return "Enter valid email with atleast 6 character";
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
                Icons.account_circle,
                size: 20,
                color: Colors.blueGrey,
              ),
              label: const Text(
                "Username",
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
                "Confirm Password",
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
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm the password";
              } else if (value != passwordCtr.text) {
                return "Confirm password and password must be same";
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
                "Confirm Password",
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
                      onPressed: () async {
                        setState(() {});
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          if (await signup() > 0) {
                            setState(() {
                              loading = false;
                            });
                            await SecureStorage().store("signup", "done");
                            widget.onSignup();

                            showMessage("Signup successful");
                          } else {
                            setState(() {
                              loading = false;
                            });
                            showMessage("Try again later");
                          }
                          List<User> temp = await UserTable().fetchAll();
                          debugPrint(temp.toString());
                        }
                      },
                      child: loading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Sign Up",
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
