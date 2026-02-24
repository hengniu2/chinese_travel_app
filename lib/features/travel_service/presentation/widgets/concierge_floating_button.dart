import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../theme/luxury_travel_theme.dart';

/// Concierge FAB: circular gold outline, black icon, label "专属顾问".
/// On tap opens luxury bottom sheet (avatar, call, chat, VIP text).
class ConciergeFloatingButton extends StatelessWidget {
  const ConciergeFloatingButton({super.key});

  static const String _label = '专属顾问';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _openConciergeSheet(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LuxuryTravelTheme.cardBackground,
              border: Border.all(
                color: LuxuryTravelTheme.primaryGold,
                width: 2,
              ),
              boxShadow: LuxuryTravelTheme.softShadow,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              size: 26,
              color: LuxuryTravelTheme.darkText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _label,
            style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText).copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _openConciergeSheet(BuildContext context) {
    showAppBottomSheet<void>(
      context: context,
      builder: (ctx) => _ConciergeSheet(),
    );
  }
}

/// Luxury bottom sheet: concierge avatar, call, chat, VIP explanation.
class _ConciergeSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LuxuryTravelTheme.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24 + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          const SizedBox(height: 24),
          _buildAvatar(),
          const SizedBox(height: 16),
          Text(
            '专属旅行顾问',
            style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText).copyWith(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: LuxuryTravelTheme.spacingXs),
          Text(
            '一对一服务，全程贴心协助',
            style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.call_rounded,
                  label: '电话联系',
                  onTap: () {
                    // TODO: Launch tel
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '在线咨询',
                  onTap: () {
                    // TODO: Open chat
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _VipExplanation(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: LuxuryTravelTheme.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: LuxuryTravelTheme.primaryGoldPale,
        border: Border.all(
          color: LuxuryTravelTheme.primaryGold.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        size: 36,
        color: LuxuryTravelTheme.primaryGoldDark,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: LuxuryTravelTheme.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: LuxuryTravelTheme.primaryGold),
              const SizedBox(width: 10),
              Text(
                label,
                style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VipExplanation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: LuxuryTravelTheme.primaryGoldPale.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LuxuryTravelTheme.primaryGold.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        'VIP 会员享有专属顾问一对一服务，可随时通过电话或在线咨询获取行程建议、预订协助与应急支持。',
        style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textSecondary).copyWith(
          height: 1.55,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
