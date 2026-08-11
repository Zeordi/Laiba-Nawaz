



import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
class CustomButton extends StatelessWidget {
  final double width;
  final double horizontalPudding;
  final double verticalPudding;
  final Widget child;
  final double radius;
  final Color fillColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final bool isEnable;
  final bool isLoading;
  final double borderWidth;
  final BoxShape shape;
  final Color? loadingColor;
  final String? loadingText;
  final TextStyle? loadingTextStyle;
  final List<BoxShadow>? boxShadow;
  final List<Color>? gradientColor;

  const CustomButton({
    super.key,

    required this.width,
    required this.horizontalPudding,
    required this.verticalPudding,
    required this.child,
    required this.radius,
    this.boxShadow,
    this.gradientColor,
    required this.fillColor,
    required this.borderColor,
    this.onTap,
    this.isEnable = true,
    this.isLoading = false,
    this.borderWidth = 0.5,
    this.shape = BoxShape.rectangle,
    this.loadingColor,
    this.loadingText,
    this.loadingTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (isLoading || !isEnable) ? null : onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPudding,
          vertical: verticalPudding,
        ),
        decoration: BoxDecoration(
          color: gradientColor == null ? fillColor : null,
          gradient: gradientColor != null
              ? LinearGradient(
                colors: gradientColor!,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,

              ): null,
          borderRadius:
              shape == BoxShape.rectangle
                  ? BorderRadius.circular(radius)
                  : null,
          border: gradientColor != null ? null: Border.all(color: borderColor, width: borderWidth),
          shape: shape,
          boxShadow: boxShadow
        ),
        child:
            isLoading
                ? Center(
                  child:
                      loadingText != null
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                itemCount: 8,
                                color: loadingColor ?? _getLoadingColor(),
                                size: findWidth(screenWidth, 20),
                              ),
                              SizedBox(width: findWidth(screenWidth, 12)),
                              CustomText(
                                text: loadingText!,
                                fontSize: findFontSize(screenWidth, 14),
                                color:
                                    loadingTextStyle?.color ??
                                    (loadingColor ?? _getLoadingColor()),
                                fontWeight:
                                    loadingTextStyle?.fontWeight ??
                                    FontWeight.w500,
                                textAlign: TextAlign.center,
                                textFamily:
                                    loadingTextStyle?.fontFamily ??
                                    "Inter",
                              ),
                            ],
                          )
                          : SpinKitFadingCircle(
                            itemCount: 8,
                            color: loadingColor ?? _getLoadingColor(),
                            size: findWidth(screenWidth, 20),
                          ),
                )
                : child,
      ),
    );
  }

  Color _getLoadingColor() {
    final brightness = fillColor.computeLuminance();
    return brightness > 0.5 ? AppColors.black : AppColors.white;
  }
}