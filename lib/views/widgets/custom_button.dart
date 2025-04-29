import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

enum CustomButtonType {
  filled,
  outline,
  text,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CustomButtonType.filled:
        return _buildElevatedButton();
      case CustomButtonType.outline:
        return _buildOutlinedButton();
      case CustomButtonType.text:
        return _buildTextButton();
    }
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      width: width,
      height: AppConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppConstants.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    final buttonColor = color ?? AppConstants.primaryColor;
    return SizedBox(
      width: width,
      height: AppConstants.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(color: buttonColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppConstants.primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == CustomButtonType.filled 
                ? Colors.white 
                : AppConstants.primaryColor
          ),
        ),
      );
    }

    final buttonTextColor = type == CustomButtonType.filled
        ? Colors.white
        : textColor ?? (color ?? AppConstants.primaryColor);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: buttonTextColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: buttonTextColor),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(color: buttonTextColor),
    );
  }
}