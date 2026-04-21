import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_http_architecture/src/core/di/theme_notifier_provider.dart';
import 'package:flutter_http_architecture/src/core/theme/app_theme.dart';

import 'package:flutter_http_architecture/src/features/http_tester/presentation/screens/http_tester/http_tester_screen.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HttpTesterScreen(),
    );
  }
}
