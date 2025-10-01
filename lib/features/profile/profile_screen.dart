import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';
import 'package:todo_sample_app/core/utils/responsive_extensions.dart';
import 'package:todo_sample_app/features/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.whitefe,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.hi,
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.lightPrimary,
                    radius: 32,
                  ),
                  Text(
                    'User',
                    style: AppTextStyles.body13w7,
                  ),
                ],
              ),
            ),
            40.hi,
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightPrimary),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Clear All Data',
                        style: AppTextStyles.subHeading16w7,
                      ),
                      Text(
                        'Start a new day',
                        style: AppTextStyles.lable12w5,
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await ref.read(todosProvider.notifier).clearAll();
                      await ref.read(groupProvider.notifier).clearAll();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("All data has been cleared",
                                style: AppTextStyles.body13w6),
                            backgroundColor: AppColors.whitefe,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.red,
                      size: 24,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
