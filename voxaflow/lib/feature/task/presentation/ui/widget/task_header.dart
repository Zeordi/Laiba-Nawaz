import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onFilterTap;
  final VoidCallback onSearchTap;

  const HomeHeader({
    super.key,
    required this.onFilterTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: findWidth(screenWidth, 8),
              height: findWidth(screenWidth, 8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: findWidth(screenWidth, 8)),
            CustomText(
              text: "Task Live Sync",
              fontSize: findFontSize(screenWidth, 18),
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        
        // Search and Filter
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(findWidth(screenWidth, 8)),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.filter_list,
              color: AppColors.textHeadline,
              size: findWidth(screenWidth, 24),
            ),
          ),
        ),
      ],
    );
  }
}
