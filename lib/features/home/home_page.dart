import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

import 'package:todo_sample_app/features/todo/presentation/screens/todo_screen.dart';
import 'package:todo_sample_app/features/groups/presentation/screens/group_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TodoScreen(),
    GroupScreen(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 100, // Adjust the height as needed
        child: BottomNavigationBar(
          backgroundColor: AppColors.whitefe,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.purple,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: AppTextStyles.body13w5,
          selectedLabelStyle: AppTextStyles.body13w6,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: 'Todos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
