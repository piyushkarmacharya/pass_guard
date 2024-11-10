import 'package:flutter/material.dart';
import 'package:pass_guard/database/credentials_table.dart';
import 'package:pass_guard/database/user_table.dart';
import 'package:pass_guard/models/credential.dart';
import 'package:pass_guard/models/user.dart';
import 'package:pass_guard/widgets/credential_card.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home-page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  Future<List<Credential>>? futureCredentials;
  final credentialsTable = CredentialsTable();
  String username = " ";
  @override
  void initState() {
    super.initState();
    fetchCredentials();
    fetchUsername();
  }

  void fetchCredentials() async {
    setState(() {
      futureCredentials = credentialsTable.fetchAll();
    });
    debugPrint((await credentialsTable.fetchAll()).toString());
  }

  Future<void> fetchUsername() async {
    List<User> usr = await UserTable().fetchAll();
    setState(() {
      username = usr[usr.length - 1].username;
    });
  }

  bool _showPassword = false;
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController titleCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 24,
              ),
              ClipOval(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset("assets/images/user.png"),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 13.02 / 10,
                        color: Colors.white),
                  ),
                  Text(
                    username,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 18.23 / 14,
                        color: Color(0xFFFCFCFF)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Dialog(
                            backgroundColor: Colors.grey.shade300,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Enter Credentials Below :",
                                    style: TextStyle(
                                        color: Color(0xFF161719),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        height: 28 / 18),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextField(
                                    controller: titleCtr,
                                    decoration: InputDecoration(
                                      enabledBorder: borderStyle,
                                      focusedBorder: borderStyle,
                                      border: borderStyle,
                                      prefixIcon: const Icon(
                                        Icons.title,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      label: const Text(
                                        "Title",
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
                                  TextField(
                                    controller: emailCtr,
                                    decoration: InputDecoration(
                                      enabledBorder: borderStyle,
                                      focusedBorder: borderStyle,
                                      border: borderStyle,
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      label: const Text(
                                        "Email or username",
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
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor:
                                                Colors.blueGrey.shade700),
                                        onPressed: () {
                                          credentialsTable.create(
                                              title: titleCtr.text,
                                              email: emailCtr.text,
                                              password: passwordCtr.text);
                                          Navigator.of(context).pop();
                                          fetchCredentials();
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      });
                },
                icon: const Icon(Icons.add, size: 20))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: FutureBuilder<List<Credential>>(
            future: futureCredentials,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading indicator
              } else if (snapshot.hasError) {
                return Center(
                    child:
                        Text("Error: ${snapshot.error}")); // Show error message
              } else if (snapshot.hasData) {
                final credentials = snapshot.data!;
                return ListView.builder(
                  itemCount: credentials.length,
                  itemBuilder: (context, index) {
                    final credential = credentials[index];
                    return CredentialCard(
                        cred: credential,
                        credentialsTable: credentialsTable,
                        onDelete: fetchCredentials);
                  },
                );
              } else {
                return const Text("No credentials found.");
              }
            },
          ),
        ));
  }
}
