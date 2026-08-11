import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

enum AdminTab { departments, users, profile }

class AdminBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.white,
      elevation: 10,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBroken.building,
              label: "DEPTS",
              index: 0,
              tab: AdminTab.departments,
            ),
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBroken.user_square,
              label: "USERS", // Was INSIGHTS/USERS
              index: 1,
              tab: AdminTab.users,
            ),
            _buildNavItem(
              context: context,
              icon: IconsaxPlusBroken.profile,
              label: "PROFILE",
              index: 2,
              tab: AdminTab.profile,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required AdminTab tab,
  }) {
    final isActive = selectedIndex == index;
    
    // For Users tab, we want bold icon if active
    final iconData = (tab == AdminTab.users && isActive) 
        ? IconsaxPlusBold.user_square 
        : icon;
        
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: isActive ? const Color(0xFF4F46E5) : Colors.grey[400]),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF4F46E5) : Colors.grey[400],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

