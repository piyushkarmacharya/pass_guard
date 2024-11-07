import 'package:flutter/material.dart';
import 'package:pass_guard/pages/homepage.dart';
import 'package:pass_guard/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pass Guard",
      theme: ThemeData(
        primaryColor: Colors.blueGrey.shade700,
        scaffoldBackgroundColor: Colors.blueGrey.shade700,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueGrey,
            iconTheme: IconThemeData(
              color: Color(0xFFFFFFFF),
            ),
            titleTextStyle:
                TextStyle(color: Color(0xFFFFFFFF), fontFamily: "DMSans")),
      ),
      initialRoute: HomePage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
      },
    );
  }
}
