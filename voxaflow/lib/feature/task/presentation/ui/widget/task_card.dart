import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';

class TaskCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final Color tagBgColor;
  final String time;
  final String title;
  final String confidence;
  final IconData confidenceIcon;
  final Color confidenceColor;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.tag,
    required this.tagColor,
    required this.tagBgColor,
    required this.time,
    required this.title,
    required this.confidence,
    required this.confidenceIcon,
    required this.confidenceColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(findWidth(screenWidth, 20)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(findWidth(screenWidth, 24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: findWidth(screenWidth, 12),
                    vertical: findWidth(screenWidth, 6),
                  ),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(findWidth(screenWidth, 12)),
                  ),
                  child: CustomText(
                    text: tag,
                    fontSize: findFontSize(screenWidth, 12),
                    color: tagColor,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomText(
                  text: time,
                  fontSize: findFontSize(screenWidth, 12),
                  color: AppColors.textPlaceholder,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            SizedBox(height: findHeight(screenHeight, 16)),
            CustomText(
              text: title,
              fontSize: findFontSize(screenWidth, 16),
              color: AppColors.textHeadline,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.start,
              maxLine: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: findHeight(screenHeight, 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      confidenceIcon,
                      size: findWidth(screenWidth, 18),
                      color: confidenceColor,
                    ),
                    SizedBox(width: findWidth(screenWidth, 8)),
                    CustomText(
                      text: confidence,
                      fontSize: findFontSize(screenWidth, 13),
                      color: confidenceColor,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(findWidth(screenWidth, 8)),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: findWidth(screenWidth, 16),
                    color: AppColors.textDefault,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
