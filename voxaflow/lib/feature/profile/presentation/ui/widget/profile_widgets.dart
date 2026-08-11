import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String role;
  
  const ProfileHeaderCard({
    super.key,
    this.name = "Sarah Jenkins",
    this.role = "Senior Customer Specialist",
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Blue Header Part with Avatar Stacked
          SizedBox(
            height: findWidth(screenWidth, 160), 
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Blue Background
                Container(
                  height: findWidth(screenWidth, 100),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
                // Avatar
                Positioned(
                  top: findWidth(screenWidth, 40), // Adjust to overlap
                  child: Stack(
                    children: [
                      Container(
                        width: findWidth(screenWidth, 110),
                        height: findWidth(screenWidth, 110),
                        padding: const EdgeInsets.all(4), // White border
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFC89569), // Avatar placeholder color
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/voxflow.png'),
                                fit: BoxFit.cover,
                            ),
                          ),
                          // child: Icon(Icons.person, size: findFontSize(screenWidth, 60), color: Colors.white.withOpacity(0.8)),
                          // In real app, use Image.asset or NetworkImage
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(findWidth(screenWidth, 8)),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: findFontSize(screenWidth, 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: findWidth(screenWidth, 10)),
          CustomText(
            text: name,
            color: AppColors.textHeadline,
            fontSize: findFontSize(screenWidth, 22),
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: findWidth(screenWidth, 4)),
          CustomText(
            text: role,
            color: AppColors.primary,
            fontSize: findFontSize(screenWidth, 14),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: findWidth(screenWidth, 24)),
        ],
      ),
    );
  }
}

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDropdown;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: const Color(0xFF5E6575),
          fontSize: findFontSize(screenWidth, 14),
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: findWidth(screenWidth, 8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: findWidth(screenWidth, 16),
            vertical: findWidth(screenWidth, 14),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), // Pill shape
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textPlaceholder, size: findFontSize(screenWidth, 20)),
              SizedBox(width: findWidth(screenWidth, 12)),
              Expanded(
                child: CustomText(
                  text: value,
                  color: AppColors.textDefault,
                  fontSize: findFontSize(screenWidth, 14),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isDropdown)
                 Icon(Icons.keyboard_arrow_down, color: AppColors.textPlaceholder, size: findFontSize(screenWidth, 24)),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileMenuOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color textColor;
  final VoidCallback onTap;

  const ProfileMenuOption({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.textColor = AppColors.textHeadline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(findWidth(screenWidth, 16)),
        color: Colors.transparent, // Let parent handle background
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(findWidth(screenWidth, 10)),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: findFontSize(screenWidth, 20)),
            ),
            SizedBox(width: findWidth(screenWidth, 16)),
            Expanded(
              child: CustomText(
                text: label,
                color: textColor,
                fontSize: findFontSize(screenWidth, 14),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (textColor != AppColors.error) // Don't show chevron for logout typically, or as per design
              Icon(Icons.chevron_right, color: AppColors.textPlaceholder, size: findFontSize(screenWidth, 24)),
          ],
        ),
      ),
    );
  }
}
