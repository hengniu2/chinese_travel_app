import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';

/// Placeholder for reusable package card. Structure only; no visual redesign.
class PackageCardPlaceholder extends StatelessWidget {
  const PackageCardPlaceholder({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final double? price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: AppTextStyles.titleSmall),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: price != null
            ? Text(
                '¥${price!.toStringAsFixed(0)}',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.price),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
