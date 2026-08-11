


import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart' show AppColors;
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';


class LoginHeader extends StatelessWidget {
  final String hederText;
  final String disc;
  const LoginHeader({super.key, 
    required this.hederText,
    required this.disc
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: findWidth(screenWidth, screenWidth - 40),
      child: Center(
        child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: findWidth(screenWidth, 7),
                    vertical: findHeight(screenHeight, 16)
                  ),
                  width: findWidth(screenWidth, 291),
                  child: Column(
                    children: [
                      SizedBox(
                        width: findWidth(screenWidth, screenWidth - 40),
                      
                        child: CustomText(
                          text: hederText,
                          fontSize: findFontSize(screenWidth, 32),
                          color: AppColors.textHeadline,
                          fontWeight: FontWeight.w800,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: findHeight(screenHeight, 10),
                      ),
                      SizedBox(
                        width: findWidth(screenWidth, screenWidth - 40),
                      
                        child: CustomText(
                          text: disc,
                          fontSize: findFontSize(screenWidth, 14),
                          color: AppColors.textDefault,
                          fontWeight: FontWeight.w400,
                          maxLine: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                    ],
                  ),
                ),
      ),
    );
  }

}