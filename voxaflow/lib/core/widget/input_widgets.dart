import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voxflow/core/utility/find_size.dart';
/// Custom text field
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLine;

  const AppTextField({
    super.key,
    this.controller,
    this.maxLine,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.helperText,
    this.errorText,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      minLines: maxLine,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon:
            suffixIcon != null
                ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixIconTap)
                : null,
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final int? maxLines;
  final String? initialValue;

  // Customizable visual parameters
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final double borderRadius;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const TextInputField({
    super.key,
    this.controller,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.focusNode,
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = const Color(0xFF4285F4),
    this.fillColor = Colors.white,
    this.borderRadius = 12.0,
    this.contentPaddingHorizontal = 14.0,
    this.contentPaddingVertical = 14.0,
    this.textInputType = TextInputType.emailAddress,
    

    this.textStyle,
    this.hintStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
      style: textStyle ?? const TextStyle(fontSize: 16.0),
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffix: suffixIcon,
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText ?? 'example1@gmail.com',
        hintStyle: hintStyle ?? const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: contentPaddingHorizontal,
          vertical: contentPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!RegExp(
          r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$',
        ).hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}

class AppPasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  // For BLoC or parent-managed obscure state
  final bool isObscure;
  final VoidCallback? onToggleVisibility;

  // Visual customization
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final double borderRadius;
  final double contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool showPasswordToggle;
  final Widget? prefixIcon;

  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.focusNode,
    this.isObscure = true,
    this.onToggleVisibility,
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = const Color(0xFF4285F4),
    this.fillColor = Colors.white,
    this.borderRadius = 12.0,
    this.contentPadding = 14.0,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.showPasswordToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: isObscure,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      style: textStyle ?? const TextStyle(fontSize: 16.0),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText ?? 'Enter your password',
        hintStyle: hintStyle ?? const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.all(contentPadding),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
        ),
        suffixIcon:
            showPasswordToggle
                ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: onToggleVisibility,
                )
                : null,
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

/// Search text field
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText ?? 'Search...',
      prefixIcon: Icons.search,
      suffixIcon: controller?.text.isNotEmpty == true ? Icons.clear : null,
      onSuffixIconTap: () {
        controller?.clear();
        onClear?.call();
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}





class AppOtpField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  // Visual customization (matching AppPasswordField)
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final double borderRadius;
  final double contentPaddingHorizontal; // Adapted from contentPadding
  final double contentPaddingVertical; // Adapted from contentPadding
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  // Timer Customization
  final Color resendButtonColor;
  final Color resendTimerColor;
  final VoidCallback? onResend;
  final int initialTimerInSeconds;

  const AppOtpField({
    super.key,
    this.controller,
    this.hintText = 'Enter 6 digit OTP',
    this.onChanged,
    this.focusNode,
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = const Color(0xFF4285F4),
    this.fillColor = Colors.white,
    this.borderRadius = 12.0,
    // Using explicit horizontal/vertical padding to match AppEmailField structure
    this.contentPaddingHorizontal = 14.0,
    this.contentPaddingVertical = 14.0,
    this.textStyle,
    this.hintStyle,
    this.resendButtonColor = Colors.blue,
    this.resendTimerColor = Colors.grey,
    this.onResend,
    this.initialTimerInSeconds = 60,
  });

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField> {
  late int _currentTime;
  Timer? _timer;
  late FocusNode _internalFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialTimerInSeconds;
    _startTimer();

    // Use provided focus node or create internal one
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Only dispose if we created it internally
    if (widget.focusNode == null) {
      _internalFocusNode.removeListener(_onFocusChange);
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _currentTime = widget.initialTimerInSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        if (mounted) {
          setState(() {
            _currentTime--;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildTimerWidget(BuildContext context) {
    final bool isTimerActive = _currentTime > 0;
    final String timerText =
        isTimerActive
            ? 'Resend in ${_formatTime(_currentTime)}'
            : 'Resend Code';
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: isTimerActive 
        ? null 
        : () {
            if (widget.onResend != null) {
              widget.onResend!();
              _startTimer();
            } else {
              _startTimer();
            }
          },
      child: Text(
        timerText,
        style: TextStyle(
          fontSize: findFontSize(screenWidth, 14),
          fontWeight: FontWeight.w500,
          color:
              isTimerActive
                  ? widget.resendTimerColor
                  : widget.resendButtonColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isFocused ? widget.focusedBorderColor : widget.borderColor,
          width: _isFocused ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _internalFocusNode,
              onChanged: widget.onChanged,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: widget.textStyle ?? const TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                    widget.hintStyle ?? const TextStyle(color: Colors.black54),
                filled: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.contentPaddingHorizontal,
                  vertical: widget.contentPaddingVertical,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                counterText: "",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'OTP is required';
                } else if (value.length != 6) {
                  return 'Invalid OTP';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: findWidth(screenWidth, 20)),
            child: _buildTimerWidget(context),
          ),
        ],
      ),
    );
  }
}
