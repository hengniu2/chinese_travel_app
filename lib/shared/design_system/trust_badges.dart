import 'package:flutter/material.dart';

import '../../features/travel/models/travel_package.dart';
import 'app_colors.dart';
import 'travel_design_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Trust badges row: cancellation, secure payment, verified local partner
// ─────────────────────────────────────────────────────────────────────────────

class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({
    super.key,
    required this.labelCancellation,
    required this.labelSecurePayment,
    required this.labelVerifiedPartner,
    this.showCancellation = true,
    this.showSecurePayment = true,
    this.showVerifiedPartner = true,
    this.compact = false,
  });

  final String labelCancellation;
  final String labelSecurePayment;
  final String labelVerifiedPartner;
  final bool showCancellation;
  final bool showSecurePayment;
  final bool showVerifiedPartner;
  final bool compact;

  /// Build from package + l10n; pass l10n.trust* getters as labels.
  factory TrustBadgesRow.fromPackage({
    required TravelPackage package,
    required String labelCancellation,
    required String labelSecurePayment,
    required String labelVerifiedPartner,
    bool compact = false,
  }) {
    final hasCancellation =
        package.cancellationPolicy != null &&
        package.cancellationPolicy!.trim().isNotEmpty;
    return TrustBadgesRow(
      labelCancellation: labelCancellation,
      labelSecurePayment: labelSecurePayment,
      labelVerifiedPartner: labelVerifiedPartner,
      showCancellation: hasCancellation,
      showSecurePayment: true,
      showVerifiedPartner: package.verifiedLocalPartner,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];
    if (showCancellation) {
      badges.add(_TrustBadge(
        icon: Icons.cancel_schedule_send_rounded,
        label: labelCancellation,
        compact: compact,
      ));
    }
    if (showSecurePayment) {
      badges.add(_TrustBadge(
        icon: Icons.lock_rounded,
        label: labelSecurePayment,
        compact: compact,
      ));
    }
    if (showVerifiedPartner) {
      badges.add(_TrustBadge(
        icon: Icons.verified_rounded,
        label: labelVerifiedPartner,
        compact: compact,
      ));
    }
    if (badges.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: compact ? 8 : 12,
      runSpacing: compact ? 6 : 8,
      children: badges,
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({
    required this.icon,
    required this.label,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: TravelDesignTokens.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TravelDesignTokens.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 16 : 18, color: TravelDesignTokens.primary),
          SizedBox(width: compact ? 6 : 8),
          Text(
            label,
            style: TravelDesignTokens.caption(TravelDesignTokens.primary).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Real traveler review highlight (one featured review)
// ─────────────────────────────────────────────────────────────────────────────

class RealTravelerReviewHighlight extends StatelessWidget {
  const RealTravelerReviewHighlight({
    super.key,
    required this.review,
    required this.sectionTitle,
  });

  final PackageReview review;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: TravelDesignTokens.borderRadiusSmall,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                size: 18,
                color: TravelDesignTokens.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                sectionTitle,
                style: TravelDesignTokens.caption(TravelDesignTokens.primary).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.content,
            style: TravelDesignTokens.body(null).copyWith(
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                review.authorName,
                style: TravelDesignTokens.caption(AppColors.textPrimary).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (review.date != null) ...[
                Text(
                  ' · ${review.date}',
                  style: TravelDesignTokens.caption(AppColors.textTertiary),
                ),
              ],
              const Spacer(),
              Icon(Icons.star_rounded, size: 14, color: AppColors.accentGold),
              const SizedBox(width: 2),
              Text(
                review.rating.toStringAsFixed(1),
                style: TravelDesignTokens.caption(AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// "X people booked this in last 7 days"
// ─────────────────────────────────────────────────────────────────────────────

class BookingsLast7DaysIndicator extends StatelessWidget {
  const BookingsLast7DaysIndicator({
    super.key,
    required this.message,
    this.compact = false,
  });

  /// Pre-formatted message, e.g. l10n.trustBookingsLast7Days(count)
  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.people_outline_rounded,
          size: compact ? 16 : 18,
          color: AppColors.accentCool,
        ),
        SizedBox(width: compact ? 6 : 8),
        Flexible(
          child: Text(
            message,
            style: TravelDesignTokens.caption(AppColors.textSecondary).copyWith(
              fontWeight: FontWeight.w500,
              fontSize: compact ? 12 : 13,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Limited stock indicator (when remainingCapacity < threshold)
// ─────────────────────────────────────────────────────────────────────────────

class LimitedStockIndicator extends StatelessWidget {
  const LimitedStockIndicator({
    super.key,
    required this.message,
    this.compact = false,
  });

  /// Pre-formatted message, e.g. l10n.trustLimitedStock(remainingCount)
  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentWarm.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentWarm.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.low_priority_rounded,
            size: compact ? 16 : 18,
            color: AppColors.accentWarm,
          ),
          SizedBox(width: compact ? 6 : 8),
          Text(
            message,
            style: TravelDesignTokens.caption(AppColors.accentWarm).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: compact ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
