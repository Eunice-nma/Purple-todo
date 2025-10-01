import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/utils_exports.dart';
import 'package:todo_sample_app/features/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 1000), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Porple',
              style:
                  AppTextStyles.display32w7.copyWith(color: AppColors.whitefe),
            ),
            4.hi,
            Text(
              'Your Todos For Today!',
              style: AppTextStyles.body13w7.copyWith(color: AppColors.whitefe),
            ),
          ],
        ),
      ),
    );
  }
}
