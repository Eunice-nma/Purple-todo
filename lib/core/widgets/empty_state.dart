import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

/// A simple widget for showing an empty state with an icon and message.  
/// Displays a centered icon and text when there is no content.  
/// Useful for tasks, lists, or screens with no data to show.  
class EmptyState extends StatelessWidget {
  const EmptyState(
    this.text, {
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit_note,
            size: 40,
            color: AppColors.greyBF,
          ),
          Text(text,
              style: AppTextStyles.subHeading16w7.copyWith(
                color: AppColors.grey7E,
              )),
        ],
      ),
    );
  }
}
