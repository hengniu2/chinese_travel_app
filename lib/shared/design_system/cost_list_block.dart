import 'package:flutter/material.dart';

import 'section_header.dart';
import 'travel_design_tokens.dart';

/// Block for cost breakdown: title + list of items (included / excluded / add-ons).
class CostListBlock extends StatelessWidget {
  const CostListBlock({
    super.key,
    required this.title,
    required this.items,
    this.icon,
  });

  final String title;
  final List<String> items;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          trailing: icon,
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TravelDesignTokens.body(const Color(0xFF22C55E)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TravelDesignTokens.body(null),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
