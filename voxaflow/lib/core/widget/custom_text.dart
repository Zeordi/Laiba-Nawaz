


import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int maxLine;
  final String textFamily;
  final TextOverflow overflow;
  const CustomText({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    this.maxLine = 1,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
    this.textFamily = 'Inter',
  });
  @override
  Widget build(BuildContext context) {
   
   return Text(
    text,
    maxLines: maxLine,
    textAlign: textAlign,
    style: TextStyle(
      fontFamily: textFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      overflow: overflow,
    ),
   );
  }
}

class CustomRichTextWidget extends StatelessWidget {
  final List<InlineSpan> children;
  final TextStyle? baseStyle;
  final double? width;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomRichTextWidget({
    super.key,
    required this.children,
    this.baseStyle,
    this.width,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultBaseStyle = TextStyle(
      fontFamily: "Inter",
      fontSize: findFontSize(screenWidth, 14),
      fontWeight: FontWeight.w500,
      color: AppColors.textDefault,
    );

    return SizedBox(
      width: width,
      child: Text.rich(
        TextSpan(style: defaultBaseStyle.merge(baseStyle), children: children),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}