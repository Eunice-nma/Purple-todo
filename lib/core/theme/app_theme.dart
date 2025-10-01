import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_sample_app/core/theme/app_colors.dart';

final ThemeData appTheme = ThemeData(

  // Core colors
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.whitefe,
  splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
  highlightColor: AppColors.primaryColor.withValues(alpha: 0.3),
  fontFamily: GoogleFonts.poppins().fontFamily,

  // Page transition
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

  // IconButton splash/hover/highlight color
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      overlayColor:
          WidgetStatePropertyAll(AppColors.primaryColor.withValues(alpha: 0.2)),
    ),
  ),
);

// Fade trasition on screens
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
