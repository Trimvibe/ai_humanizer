import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool enabled;

  const AnimatedTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgCol = isDark ? AppColors.backgroundSlate : const Color(0xFFF1F5F9);
    final borderCol = _isFocused ? AppColors.neonCyan : (isDark ? AppColors.glassBorder : Colors.black12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderCol,
          width: 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.neonCyan.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark ? AppColors.textPrimary : Colors.black,
            ),
        cursorColor: AppColors.neonCyan,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: _isFocused ? AppColors.neonCyan : AppColors.textSecondary,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
