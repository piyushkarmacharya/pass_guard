import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pass_guard/database/user_table.dart';
import 'package:pass_guard/models/user.dart';
import 'package:pass_guard/pages/homepage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameCtr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  bool loading = false;

  void loginSuccess() {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  //for biometrics
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    _getAvailableBiometrics();
    _checkBiometrics();

    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      debugPrint(e.toString());
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      debugPrint(e.toString());
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  //Authenticate with biometrics , face , and pin of device
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      setState(() {
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
    if (_authorized == "Authorized") {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason:
  //           'Scan your fingerprint (or face or whatever) to authenticate',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),
  //     );
  //     setState(() {
  //       _authorized = 'Authenticating';
  //     });
  //   } on PlatformException catch (e) {
  //     debugPrint(e.toString());
  //     setState(() {
  //       _authorized = 'Error - ${e.message}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';

  //   setState(() {
  //     _authorized = message;
  //   });
  //   if (_authorized == "Authorized") {
  //     Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  //   }
  // }

  // Future<void> _cancelAuthentication() async {
  //   await auth.stopAuthentication();
  //   setState(() => _isAuthenticating = false);
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "available biometrics: $_availableBiometrics & can check bio: $_canCheckBiometrics");
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Login",
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
            controller: usernameCtr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter username";
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          List<User> users = await UserTable().fetchAll();
                          User user = users[users.length - 1];
                          if (usernameCtr.text == user.username &&
                              passwordCtr.text == user.password) {
                            setState(() {
                              loading = false;
                            });

                            showMessage("Welcome ${usernameCtr.text}");
                            loginSuccess();
                          } else {
                            setState(() {
                              loading = false;
                            });
                            showMessage("Invalid credentials");
                          }
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
                              "Sign in",
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
                if (_supportState == _SupportState.supported &&
                    _canCheckBiometrics == true &&
                    _availableBiometrics != null &&
                    _availableBiometrics!.isNotEmpty)
                  SizedBox(
                    height: 48,
                    width: 70,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.blueGrey.shade700),
                        onPressed: _authenticate,
                        child: const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                        )),
                  ),
              ],
            ),
          ),
          if (_canCheckBiometrics == true && _availableBiometrics!.isEmpty)
            Text(
              "Biometrics supported, but not set up or enabled on the device.",
              style: TextStyle(
                color: Colors.red.shade900, // Default error color
                fontSize: 12.0, // Standard size for error text
                fontWeight: FontWeight.w400, // Regular weight for error text
              ),
            ),
        ],
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
