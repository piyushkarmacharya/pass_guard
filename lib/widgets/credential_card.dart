import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pass_guard/database/credentials_table.dart';
import 'package:pass_guard/database/user_table.dart';
import 'package:pass_guard/models/credential.dart';
import 'package:pass_guard/models/user.dart';

class CredentialCard extends StatefulWidget {
  final Credential cred;
  final CredentialsTable credentialsTable;
  final Function onDelete;
  const CredentialCard(
      {super.key,
      required this.cred,
      required this.credentialsTable,
      required this.onDelete});

  @override
  State<CredentialCard> createState() => _CredentialCardState();
}

class _CredentialCardState extends State<CredentialCard> {
  OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  bool _showPassword = false;
  final TextEditingController passwordCtr = TextEditingController();
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
  Future<bool> _authenticate() async {
    if (_supportState == _SupportState.supported &&
        _canCheckBiometrics == true &&
        _availableBiometrics != null &&
        _availableBiometrics!.isNotEmpty) {
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
        return false;
      }
      if (!mounted) {
        return false;
      }

      setState(
          () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
      if (_authorized == "Authorized") {
        return true;
      }
      return false;
    } else {
      bool? temp = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter password below :",
                      style: TextStyle(
                          color: Color(0xFF161719),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 28 / 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: passwordCtr,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                        ),
                        enabledBorder: borderStyle,
                        focusedBorder: borderStyle,
                        border: borderStyle,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "DMSans",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 18.23 / 14),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.blueGrey),
                          onPressed: () async {
                            List<User> users = await UserTable().fetchAll();
                            if (passwordCtr.text ==
                                users[users.length - 1].password) {
                              Navigator.of(context).pop(true);
                            } else {
                              Navigator.of(context).pop(false);
                              showMessage("Incorrect password");
                            }
                          },
                          child: const Text(
                            "Show credentials",
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ],
                ),
              ),
            );
          });
      return temp ?? false;
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
    Size screenSize = MediaQuery.of(context).size;
    final credential = widget.cred;
    final credentialsTable = widget.credentialsTable;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.grey,
        elevation: 10,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        credential.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email : ${credential.email}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Password : ${_showPassword ? credential.password : "**********"}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (_showPassword) {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            } else if ((await _authenticate()) == true) {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            }
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 0.11 * screenSize.width,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.grey,
                              title: Text(
                                  "Delete credentials for ${credential.title}?",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      height: 28 / 18)),
                              contentPadding: EdgeInsets.zero,
                              buttonPadding: EdgeInsets.zero,
                              actionsPadding: const EdgeInsets.all(8),
                              titlePadding:
                                  const EdgeInsets.fromLTRB(24, 20, 20, 0),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      credentialsTable.delete(credential.id);
                                      widget.onDelete();
                                    },
                                    child: Text(
                                      "Yes",
                                      style:
                                          TextStyle(color: Colors.red.shade900),
                                    )),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade900,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
