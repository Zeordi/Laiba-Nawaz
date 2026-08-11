import 'package:flutter/material.dart';
import 'package:voxflow/feature/admin/presentation/screen/admin_departments_screen.dart';
import 'package:voxflow/feature/admin/presentation/screen/admin_directory_screen.dart';
import 'package:voxflow/feature/admin/presentation/widget/admin_bottom_navigation.dart';
import 'package:voxflow/feature/profile/presentation/ui/screen/profile_screen.dart';

class AdminMainWrapper extends StatefulWidget {
  final int initialIndex;
  const AdminMainWrapper({super.key, this.initialIndex = 0});

  @override
  State<AdminMainWrapper> createState() => _AdminMainWrapperState();
}

class _AdminMainWrapperState extends State<AdminMainWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  List<Widget> get _pages => [
    const AdminDepartmentsScreen(),
    const AdminDirectoryScreen(),
    const ProfileScreen(showBackButton: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AdminBottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
