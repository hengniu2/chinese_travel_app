import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/membership_models.dart';
import '../../../providers/membership_provider.dart';

/// VIP Center: 3 tiers (普通/黄金/钻石), golden gradient style, benefits table.
class MembershipCenterPage extends ConsumerWidget {
  const MembershipCenterPage({super.key});

  static String _tierName(MembershipTier t, AppLocalizations l10n) {
    switch (t) {
      case MembershipTier.normal:
        return l10n.membershipTierNormal;
      case MembershipTier.gold:
        return l10n.membershipTierGold;
      case MembershipTier.diamond:
        return l10n.membershipTierDiamond;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userMembershipProfileProvider);
    final progress = progressToNextTier(profile);
    final nextTier = TierConfig.nextTier(profile.tier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _goldGradientStart,
              _goldGradientStart.withValues(alpha: 0.85),
              TravelDesignTokens.background,
            ],
            stops: const [0.0, 0.35, 0.6],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 0,
                pinned: true,
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.textPrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  l10n.membershipCenterTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TravelDesignTokens.screenHorizontal,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _VipTierCard(
                        tier: profile.tier,
                        tierName: _tierName(profile.tier, l10n),
                        points: profile.points,
                        progress: progress,
                        nextTierName: nextTier != null ? _tierName(nextTier.tier, l10n) : null,
                        expiry: profile.tierExpiryDate,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(title: l10n.membershipBenefits),
                      const SizedBox(height: 12),
                      _VipBenefitsTable(l10n: l10n),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const Color _goldGradientStart = Color(0xFFFFD54F);
const Color _goldGradientEnd = Color(0xFFF9A825);
const Color _diamondAccent = Color(0xFFB0BEC5);

class _VipTierCard extends StatelessWidget {
  const _VipTierCard({
    required this.tier,
    required this.tierName,
    required this.points,
    required this.progress,
    this.nextTierName,
    this.expiry,
    required this.l10n,
  });

  final MembershipTier tier;
  final String tierName;
  final int points;
  final double progress;
  final String? nextTierName;
  final DateTime? expiry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isVip = tier == MembershipTier.gold || tier == MembershipTier.diamond;
    final gradientColors = isVip
        ? [const Color(0xFFFFE082), const Color(0xFFFFD54F), const Color(0xFFF9A825)]
        : [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)];
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: [
          BoxShadow(
            color: _goldGradientEnd.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: TravelDesignTokens.borderRadiusSmall,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  tierName,
                  style: TravelDesignTokens.titleL(isVip ? const Color(0xFF5D4037) : AppColors.textPrimary).copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.membershipPointsBalance,
            style: TravelDesignTokens.caption(const Color(0xFF5D4037)),
          ),
          const SizedBox(height: 4),
          Text(
            '$points',
            style: TravelDesignTokens.titleXL(null).copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3E2723),
            ),
          ),
          if (expiry != null) ...[
            const SizedBox(height: 8),
            Text(
              '有效期至 ${_formatDate(expiry!)}',
              style: TravelDesignTokens.caption(const Color(0xFF5D4037)),
            ),
          ],
          if (nextTierName != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.membershipProgressToNext,
                  style: TravelDesignTokens.caption(const Color(0xFF5D4037)),
                ),
                Text(
                  nextTierName!,
                  style: TravelDesignTokens.caption(const Color(0xFF3E2723)).copyWith(
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
                backgroundColor: Colors.white.withValues(alpha: 0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5D4037)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _VipBenefitsTable extends StatelessWidget {
  const _VipBenefitsTable({required this.l10n});

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
              _cell(l10n.membershipTierNormal, isHeader: true),
              _cell(l10n.membershipTierGold, isHeader: true),
              _cell(l10n.membershipTierDiamond, isHeader: true),
            ],
          ),
          _benefitRow(
            l10n.membershipDiscount,
            tiers.map((t) => t.discountRate > 0 ? '${(t.discountRate * 100).toInt()}%' : '—').toList(),
          ),
          _benefitRow(
            l10n.membershipFreeBreakfast,
            tiers.map((t) => t.freeBreakfast ? '✓' : '—').toList(),
          ),
          _benefitRow(
            l10n.membershipLateCheckout,
            tiers.map((t) => t.lateCheckout ? '✓' : '—').toList(),
          ),
          _benefitRow(
            l10n.membershipExclusiveCoupons,
            tiers.map((t) => t.exclusiveCoupons ? '✓' : '—').toList(),
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
      ],
    );
  }

  Widget _cell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        text,
        style: (isHeader ? TravelDesignTokens.body(null) : TravelDesignTokens.caption(null)).copyWith(
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

