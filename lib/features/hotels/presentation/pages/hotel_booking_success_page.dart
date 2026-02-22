import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../providers/hotel_booking_provider.dart';

/// Step 4: Booking success — yellow celebration UI, cartoon success animation, confetti.
class HotelBookingSuccessPage extends ConsumerStatefulWidget {
  const HotelBookingSuccessPage({super.key});

  @override
  ConsumerState<HotelBookingSuccessPage> createState() =>
      _HotelBookingSuccessPageState();
}

class _HotelBookingSuccessPageState extends ConsumerState<HotelBookingSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceScale;
  late AnimationController _confettiController;
  late List<double> _confettiAngles;
  late List<double> _confettiSizes;

  static const _confettiCount = 24;
  static const _confettiSpread = 120.0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
    _bounceController.forward();

    final r = math.Random();
    _confettiAngles = List.generate(_confettiCount, (_) => r.nextDouble() * 2 * math.pi);
    _confettiSizes = List.generate(_confettiCount, (_) => 4.0 + r.nextDouble() * 6);
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booking = ref.watch(lastHotelBookingProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Yellow celebration gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFECB3),
                  Color(0xFFFFE082),
                ],
              ),
            ),
          ),
          // Confetti overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (_, __) => CustomPaint(
                painter: _SuccessConfettiPainter(
                  progress: _confettiController.value,
                  spread: _confettiSpread,
                  angles: _confettiAngles,
                  sizes: _confettiSizes,
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 48.h),
                  AnimatedBuilder(
                    animation: _bounceScale,
                    builder: (_, __) => Transform.scale(
                      scale: _bounceScale.value,
                      child: _CartoonSuccessBadge(),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    l10n?.hotelBookingSuccessTitle ?? '预订成功！',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n?.hotelBookingSuccessMessage ?? '您的预订已确认。',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (booking != null) ...[
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n?.bookingOrderNumber(booking.id) ??
                            '订单号：${booking.id}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: l10n?.bookingViewOrder ?? '查看订单',
                      onPressed: () {
                        final b = ref.read(lastHotelBookingProvider);
                        if (b != null) {
                          context.go('/orders');
                        } else {
                          context.go('/hotels');
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/hotels'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        side: const BorderSide(color: AppColors.primaryDark),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: Text(
                        l10n?.bookingBackToHome ?? '返回首页',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartoonSuccessBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 88.sp,
            color: AppColors.primary,
          ),
          Positioned(
            bottom: 22.h,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hotel_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessConfettiPainter extends CustomPainter {
  _SuccessConfettiPainter({
    required this.progress,
    required this.spread,
    required this.angles,
    required this.sizes,
  });

  final double progress;
  final double spread;
  final List<double> angles;
  final List<double> sizes;

  static const Color _yellow = AppColors.primary;
  static const Color _amber = AppColors.primaryLight;
  static const Color _gold = AppColors.accentGold;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.32);
    final opacity = (1 - progress * 1.2).clamp(0.0, 1.0);
    if (opacity <= 0) return;

    for (var i = 0; i < angles.length; i++) {
      final dist = progress * spread * (0.5 + (i % 4) * 0.25);
      final x = center.dx + math.cos(angles[i]) * dist;
      final y = center.dy + math.sin(angles[i]) * dist - progress * 40;
      final particleOpacity = opacity * (1 - progress * 0.6);
      final colors = [_yellow, _amber, _gold];
      final color = colors[i % 3].withValues(alpha: particleOpacity);
      canvas.drawCircle(Offset(x, y), sizes[i], Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
