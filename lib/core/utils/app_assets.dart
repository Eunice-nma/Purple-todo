import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  /// Load an SVG from `assets/svgs/`
  static SvgPicture svg(
    String name, {
    double? size,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      'assets/svg/$name.svg',
      width: size,
      height: size,
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Load an image (PNG, JPG, etc.) from `assets/images/`

  static Widget image(
    String name, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    double? blur, // 👈 optional blur
  }) {
    final img = Image.asset(
      'assets/images/$name',
      width: width,
      height: height,
      fit: fit,
    );

    if (blur != null && blur > 0) {
      return ClipRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 4),
          child: img,
        ),
      );
    }

    return img;
  }
}
