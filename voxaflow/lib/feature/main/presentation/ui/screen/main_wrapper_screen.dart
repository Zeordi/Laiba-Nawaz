import 'package:flutter/material.dart';
import 'package:voxflow/feature/submit_task/presentation/ui/screen/submit_task_screen.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/feature/home/presentation/ui/screen/home_screen.dart';
import 'package:voxflow/feature/profile/presentation/ui/screen/profile_screen.dart';
import 'package:voxflow/feature/task/presentation/ui/screen/task_screen.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const HomeScreen(),
    const TaskScreen(), // Tasks
    const SubmitTaskScreen(), // Record
    const ProfileScreen(showBackButton: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
             setState(() {
                _selectedIndex = index;
              });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textPlaceholder,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  _selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                  size: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                 _selectedIndex == 1 ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                  size: 24,
                ),
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                 _selectedIndex == 2 ? Icons.mic : Icons.mic_none,
                  size: 24,
                ),
              ),
              label: 'Record',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  _selectedIndex == 4 ? Icons.person_rounded : Icons.person_outline_rounded,
                  size: 24,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
