import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 渐变背景组件（中国旅行风 - 主色渐变）
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops,
  });

  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;

  /// 主色到深绿渐变（顶部栏/活动区）
  static List<Color> get primaryGradient => [
        AppColors.primary,
        AppColors.primaryDark,
      ];

  /// 浅绿到白（柔和背景）
  static List<Color> get lightGradient => [
        AppColors.primaryLight,
        AppColors.backgroundCard,
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? primaryGradient,
          begin: begin,
          end: end,
          stops: stops,
        ),
      ),
      child: child,
    );
  }
}
