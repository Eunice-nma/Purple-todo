import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_sample_app/core/services/notification_service.dart';
import 'package:todo_sample_app/core/theme/app_theme.dart';
import 'package:todo_sample_app/features/splash/splash_screen.dart';

Future<void> main() async {
  // Ensure widget binding before initializing services
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: appTheme,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
