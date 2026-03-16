import 'package:flutter/material.dart';

import 'package:flutter_http_architecture/src/screens/home/home_screen.dart';
import 'package:flutter_http_architecture/src/screens/login/login_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
