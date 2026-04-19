import 'package:flutter/material.dart';

import 'package:flutter_http_architecture/src/features/http_tester/presentation/screens/http_tester/http_tester_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => HttpTesterScreen()},
    );
  }
}
