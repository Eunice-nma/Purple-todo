import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

extension ResponsiveSizedBox on num {
  SizedBox get wi => SizedBox(width: w);
  SizedBox get hi => SizedBox(height: h);
}
