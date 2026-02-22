import 'package:flutter/material.dart';

import '../colors.dart';
import '../radius.dart';
import '../shadows.dart';
import '../spacing.dart';
import '../typography.dart';

/// Full-rounded search bar with shadow and leading icon.
/// Optional [suffixIcon] (e.g. clear button). Use [SearchBarYellowStateful] for built-in clear.
class SearchBarYellow extends StatelessWidget {
  const SearchBarYellow({
    super.key,
    this.controller,
    this.hintText = '搜索酒店、目的地',
    this.onChanged,
    this.onSubmitted,
    this.leadingIcon = Icons.search_rounded,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconData leadingIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final fill = fillColor ?? OtaColors.surface;
    final border = borderColor ?? OtaColors.border;

    return Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: OtaRadius.pillRadius,
        border: Border.all(color: border, width: 1),
        boxShadow: OtaShadows.level1,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: OtaTypography.body(OtaColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: OtaTypography.body(OtaColors.textTertiary),
          prefixIcon: Icon(
            leadingIcon,
            size: 22,
            color: OtaColors.textTertiary,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: OtaSpacing.xs,
            vertical: OtaSpacing.xxs + 2,
          ),
          isDense: true,
        ),
      ),
    );
  }
}

/// Clear button for use as [SearchBarYellow.suffixIcon].
class SearchBarYellowClearButton extends StatelessWidget {
  const SearchBarYellowClearButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.cancel_rounded, size: 20, color: OtaColors.textTertiary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    );
  }
}
