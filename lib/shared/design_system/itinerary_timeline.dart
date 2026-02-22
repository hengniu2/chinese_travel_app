import 'package:flutter/material.dart';

import 'travel_design_tokens.dart';

/// Timeline for itinerary days: dot + line + content. 16dp card padding, 24dp between sections.
class ItineraryTimeline extends StatelessWidget {
  const ItineraryTimeline({
    super.key,
    required this.items,
    this.itemBuilder,
  });

  final List<ItineraryTimelineItem> items;
  final Widget Function(BuildContext context, ItineraryTimelineItem item)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: TravelDesignTokens.sectionGap),
      itemBuilder: (context, index) {
        final item = items[index];
        final content = itemBuilder != null
            ? itemBuilder!(context, item)
            : _defaultItemBuilder(context, item);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDotLine(index),
            const SizedBox(width: 12),
            Expanded(child: content),
          ],
        );
      },
    );
  }

  Widget _buildDotLine(int index) {
    final isLast = index == items.length - 1;
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: TravelDesignTokens.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: TravelDesignTokens.shadowLevel1,
            ),
          ),
          if (!isLast)
            Container(
              width: 2,
              height: 24,
              margin: const EdgeInsets.only(top: 4),
              color: const Color(0xFFE5E7EB),
            ),
        ],
      ),
    );
  }

  Widget _defaultItemBuilder(BuildContext context, ItineraryTimelineItem item) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusSmall,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TravelDesignTokens.titleL(null),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              item.subtitle!,
              style: TravelDesignTokens.body(null),
            ),
          ],
        ],
      ),
    );
  }
}

class ItineraryTimelineItem {
  const ItineraryTimelineItem({
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
}
