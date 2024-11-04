import 'package:flutter/material.dart';
import 'package:pass_guard/database/pass_guard_db.dart';
import 'package:pass_guard/models/credential.dart';

class HomePage extends StatefulWidget {
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
  final passGuardDb = PassGuardDb();
  @override
  void initState() {
    super.initState();
    fetchCredentials();
  }

  void fetchCredentials() async {
    setState(() {
      futureCredentials = passGuardDb.fetchAll();
    });
  }

  bool _showPassword = false;
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController titleCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Image.network(
                      ("https://media.istockphoto.com/id/1196083861/vector/simple-man-head-icon-set.jpg?s=612x612&w=0&k=20&c=a8fwdX6UKUVCOedN_p0pPszu8B4f6sjarDmUGHngvdM=")),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        height: 13.02 / 10,
                        color: Color(0xFFFCFCFF)),
                  ),
                  Text(
                    "User",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
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
                            backgroundColor: Colors.grey,
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
                                        "Email",
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
                                            backgroundColor: Colors.blueGrey),
                                        onPressed: () {
                                          passGuardDb.create(
                                              title: titleCtr.text,
                                              email: emailCtr.text,
                                              password: passwordCtr.text);
                                          Navigator.of(context).pop();
                                          fetchCredentials();
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.black),
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
        body: FutureBuilder<List<Credential>>(
          future: futureCredentials,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}"); // Show error message
            } else if (snapshot.hasData) {
              final credentials = snapshot.data!;
              return ListView.builder(
                itemCount: credentials.length,
                itemBuilder: (context, index) {
                  final credential = credentials[index];
                  return ListTile(
                    title: Text(credential.toString()), // Customize as needed
                  );
                },
              );
            } else {
              return const Text("No credentials found.");
            }
          },
        ));
  }
}
