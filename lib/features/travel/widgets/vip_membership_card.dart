import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';

/// VIP membership upsell card — gold gradient, shine animation, crown icon.
class VipMembershipCard extends StatefulWidget {
  const VipMembershipCard({
    super.key,
    this.onUpgrade,
  });

  final VoidCallback? onUpgrade;

  @override
  State<VipMembershipCard> createState() => _VipMembershipCardState();
}

class _VipMembershipCardState extends State<VipMembershipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  static const _features = [
    '专属顾问',
    '优先出票',
    '行程免费修改',
    '高端定制折扣',
  ];

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _shineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4AF37),
              Color(0xFFF4D03F),
              Color(0xFFE8C547),
              Color(0xFFC9A227),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Shine overlay
          AnimatedBuilder(
            animation: _shineAnimation,
            builder: (context, child) {
              return Positioned.fill(
                child: IgnorePointer(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      final progress = _shineAnimation.value;
                      return LinearGradient(
                        begin: Alignment(-1.5 + progress * 2, 0),
                        end: Alignment(progress * 2, 0),
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.4),
                          Colors.white.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.overlay,
                    child: Container(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('👑', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'VIP 尊享会员',
                    style: TravelTypography.sectionTitle(
                      const Color(0xFF1A1A1A),
                      fontSize: 15,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: _features.map((f) => _FeatureChip(label: f)).toList(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: widget.onUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: AppColors.accentGold,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('升级为VIP', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TravelTypography.hint(const Color(0xFF1A1A1A), fontSize: 11)
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
