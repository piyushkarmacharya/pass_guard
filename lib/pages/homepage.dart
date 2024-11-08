import 'package:flutter/material.dart';
import 'package:pass_guard/database/credentials_table.dart';
import 'package:pass_guard/database/user_table.dart';
import 'package:pass_guard/models/credential.dart';
import 'package:pass_guard/models/user.dart';

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
    Size screenSize = MediaQuery.of(context).size;
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
                                          credentialsTable.create(
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
              return Center(
                  child:
                      Text("Error: ${snapshot.error}")); // Show error message
            } else if (snapshot.hasData) {
              final credentials = snapshot.data!;
              return ListView.builder(
                itemCount: credentials.length,
                itemBuilder: (context, index) {
                  final credential = credentials[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
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
                                  Text(
                                    'Password : ${credential.password}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                                borderRadius:
                                                    BorderRadius.circular(16)),
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
                                            actionsPadding:
                                                const EdgeInsets.all(8),
                                            titlePadding:
                                                const EdgeInsets.fromLTRB(
                                                    24, 20, 20, 0),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    credentialsTable
                                                        .delete(credential.id);
                                                    fetchCredentials();
                                                  },
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red.shade900),
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
                },
              );
            } else {
              return const Text("No credentials found.");
            }
          },
        ));
  }
}
