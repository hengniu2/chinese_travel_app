import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import 'case_showcase_section.dart';

/// Premium section: personalized horizontal list with "为你推荐" smart badge.
class AiSmartRecommendationSection extends StatelessWidget {
  const AiSmartRecommendationSection({
    super.key,
    required this.items,
    this.onItemTap,
  });

  final List<CaseCardItem> items;
  final void Function(int index)? onItemTap;

  static const double _cardWidth = 180;
  static const double _imageHeight = 110;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 6),
                    Text(
                      '为你推荐',
                      style: TravelTypography.label(const Color(0xFF1B5E20), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: _imageHeight + 118,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return CaseCard(
                  item: items[index],
                  width: _cardWidth,
                  imageHeight: _imageHeight,
                  onTap: () => onItemTap?.call(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Limited time deals banner with countdown and yellow-red gradient.
class LimitedTimeDealsBanner extends StatefulWidget {
  const LimitedTimeDealsBanner({
    super.key,
    this.endTime,
    this.title = '限时特惠',
    this.subtitle = '精选线路 · 先到先得',
    this.onTap,
  });

  /// If null, uses a default countdown (e.g. end of today).
  final DateTime? endTime;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  State<LimitedTimeDealsBanner> createState() => _LimitedTimeDealsBannerState();
}

class _LimitedTimeDealsBannerState extends State<LimitedTimeDealsBanner> {
  static const Color _yellow = Color(0xFFFFEB3B);
  static const Color _orange = Color(0xFFFF9800);
  static const Color _red = Color(0xFFF44336);

  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final end = widget.endTime ?? _defaultEndTime();
    final now = DateTime.now();
    _remaining = end.isBefore(now) ? Duration.zero : end.difference(now);
    if (mounted) setState(() {});
  }

  DateTime _defaultEndTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_yellow, _orange, _red],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _red.withValues(alpha: 0.25),
                  offset: const Offset(0, 6),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TravelTypography.title(const Color(0xFF1A1A1A), fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TravelTypography.hint(Colors.black.withValues(alpha: 0.7), fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _CountdownBox(value: _twoDigits(h), label: '时'),
                          const SizedBox(width: 6),
                          _CountdownBox(value: _twoDigits(m), label: '分'),
                          const SizedBox(width: 6),
                          _CountdownBox(value: _twoDigits(s), label: '秒'),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 28,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownBox extends StatelessWidget {
  const _CountdownBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TravelTypography.title(const Color(0xFF1A1A1A), fontSize: 18).copyWith(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TravelTypography.label(Colors.black.withValues(alpha: 0.6), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// Floating AI assistant button: bottom right, pulse animation, opens chat.
class FloatingAiAssistantButton extends StatefulWidget {
  const FloatingAiAssistantButton({
    super.key,
    this.chatRoute = '/messages',
  });

  final String chatRoute;

  @override
  State<FloatingAiAssistantButton> createState() => _FloatingAiAssistantButtonState();
}

class _FloatingAiAssistantButtonState extends State<FloatingAiAssistantButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      right: 20,
      bottom: 24 + bottomPadding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.25),
              ),
            ),
          ),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.4),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(widget.chatRoute),
              customBorder: const CircleBorder(),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C4DFF).withValues(alpha: 0.45),
                      offset: const Offset(0, 4),
                      blurRadius: 14,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.smart_toy_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
