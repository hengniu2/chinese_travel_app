import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/membership_models.dart';
import '../../../providers/membership_provider.dart';

/// Membership Center: current tier card, progress to next, points, benefits table, exclusive packages.
class MembershipCenterPage extends ConsumerWidget {
  const MembershipCenterPage({super.key});

  static String _tierName(MembershipTier t, AppLocalizations l10n) {
    switch (t) {
      case MembershipTier.basic:
        return l10n.membershipTierBasic;
      case MembershipTier.silver:
        return l10n.membershipTierSilver;
      case MembershipTier.gold:
        return l10n.membershipTierGold;
      case MembershipTier.vip:
        return l10n.membershipTierVip;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userMembershipProfileProvider);
    final progress = progressToNextTier(profile);
    final nextTier = TierConfig.nextTier(profile.tier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TravelDesignTokens.background,
      appBar: AppBar(
        title: Text(l10n.membershipCenterTitle),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: TravelDesignTokens.screenHorizontal,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TierCard(
              tier: profile.tier,
              tierName: _tierName(profile.tier, l10n),
              points: profile.points,
              progress: progress,
              nextTierName: nextTier != null ? _tierName(nextTier.tier, l10n) : null,
              l10n: l10n,
            ),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.membershipBenefits),
            const SizedBox(height: 12),
            _BenefitsTable(l10n: l10n),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.membershipExclusivePackagesSection),
            const SizedBox(height: 12),
            _ExclusivePackagesPlaceholder(l10n: l10n),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.tier,
    required this.tierName,
    required this.points,
    required this.progress,
    this.nextTierName,
    required this.l10n,
  });

  final MembershipTier tier;
  final String tierName;
  final int points;
  final double progress;
  final String? nextTierName;
  final AppLocalizations l10n;

  static Color _tierColor(MembershipTier t) {
    switch (t) {
      case MembershipTier.basic:
        return AppColors.textTertiary;
      case MembershipTier.silver:
        return const Color(0xFF9CA3AF);
      case MembershipTier.gold:
        return const Color(0xFFD97706);
      case MembershipTier.vip:
        return const Color(0xFF7C3AED);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(tier);
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.25),
                  borderRadius: TravelDesignTokens.borderRadiusSmall,
                ),
                child: Text(
                  tierName,
                  style: TravelDesignTokens.titleL(color).copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.membershipPointsBalance,
            style: TravelDesignTokens.caption(AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '$points',
            style: TravelDesignTokens.titleXL(null).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (nextTierName != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.membershipProgressToNext,
                  style: TravelDesignTokens.caption(AppColors.textSecondary),
                ),
                Text(
                  nextTierName!,
                  style: TravelDesignTokens.caption(color).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BenefitsTable extends StatelessWidget {
  const _BenefitsTable({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tiers = TierConfig.all;
    return Container(
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.8),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(color: AppColors.divider),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            children: [
              _cell(l10n.membershipBenefits, isHeader: true),
              _cell(l10n.membershipTierBasic, isHeader: true),
              _cell(l10n.membershipTierSilver, isHeader: true),
              _cell(l10n.membershipTierGold, isHeader: true),
              _cell(l10n.membershipTierVip, isHeader: true),
            ],
          ),
          _benefitRow(
            l10n.membershipDiscount,
            tiers.map((t) => t.discountRate > 0 ? '${(t.discountRate * 100).toInt()}%' : '—').toList(),
          ),
          _benefitRow(
            l10n.membershipEarlyBooking,
            tiers.map((t) => t.earlyBookingDays > 0 ? '${t.earlyBookingDays}d' : '—').toList(),
          ),
          _benefitRow(
            l10n.membershipExclusivePackages,
            tiers.map((t) => t.exclusivePackages ? '✓' : '—').toList(),
          ),
          _benefitRow(
            l10n.membershipPrioritySupport,
            tiers.map((t) => t.prioritySupport ? '✓' : '—').toList(),
          ),
        ],
      ),
    );
  }

  TableRow _benefitRow(String label, List<String> values) {
    return TableRow(
      children: [
        _cell(label),
        _cell(values[0]),
        _cell(values[1]),
        _cell(values[2]),
        _cell(values[3]),
      ],
    );
  }

  Widget _cell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        text,
        style: (isHeader ? TravelDesignTokens.body(null) : TravelDesignTokens.caption(null))
            .copyWith(
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _ExclusivePackagesPlaceholder extends StatelessWidget {
  const _ExclusivePackagesPlaceholder({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock_rounded,
            size: 40,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            'Gold & VIP members get access to exclusive packages.',
            style: TravelDesignTokens.body(AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.push('/planner/discovery'),
            child: const Text('Browse tours'),
          ),
        ],
      ),
    );
  }
}
