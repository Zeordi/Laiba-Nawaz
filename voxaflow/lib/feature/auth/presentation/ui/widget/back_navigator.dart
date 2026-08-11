import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_button.dart';
import 'package:voxflow/core/widget/custom_text.dart';

class BackNavigator extends StatelessWidget {
  const BackNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: findWidth(screenWidth, 96.37),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            onTap: () {
              context.pop();
            },
            width: findWidth(screenWidth, 40),
            horizontalPudding: findWidth(screenWidth, 10),
            verticalPudding: findWidth(screenWidth, 10),
            radius: 0,
            fillColor: AppColors.white,
            borderColor: AppColors.textLight,
            shape: BoxShape.circle,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                size: findFontSize(screenWidth, 20.1),
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            // width: findWidth(screenWidth, 38),
            child: CustomText(
              text: "Back",
              fontSize: findFontSize(screenWidth, 16),
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.left,
              textFamily: "Inter",
            ),
          ),
        ],
      ),
    );
  }
}