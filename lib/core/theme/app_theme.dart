import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_sample_app/core/theme/app_colors.dart';

final ThemeData appTheme = ThemeData(
  // Core colors
  primaryColor: AppColors.purple,
  scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
  fontFamily: GoogleFonts.poppins().fontFamily,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadePageTransitionsBuilder(),
      TargetPlatform.iOS: FadePageTransitionsBuilder(),
    },
  ),

  // App bar styling
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.white,
    elevation: 0,
  ),

  // Text Theme mapping
  // textTheme: const TextTheme(
  //   displayLarge: AppTextStyles.displayLarge,
  //   displayMedium: AppTextStyles.displayMedium,
  //   displaySmall: AppTextStyles.displaySmall,
  //   // headlineLarge: AppTextStyles.headlineLarge,
  //   // headlineMedium: AppTextStyles.headlineMedium,
  //   // headlineSmall: AppTextStyles.headlineSmall,
  //   // titleLarge: AppTextStyles.titleLarge,
  //   // titleMedium: AppTextStyles.titleMedium,
  //   // titleSmall: AppTextStyles.titleSmall,
  //   // bodyLarge: AppTextStyles.bodyLarge,
  //   // bodyMedium: AppTextStyles.bodyMedium,
  //   // bodySmall: AppTextStyles.bodySmall,
  //   // labelLarge: AppTextStyles.labelLarge,
  //   // labelMedium: AppTextStyles.labelMedium,
  //   // labelSmall: AppTextStyles.labelSmall,
  // ),
);

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
