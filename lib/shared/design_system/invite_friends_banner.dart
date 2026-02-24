import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'travel_typography.dart';

/// Compact banner: 邀请好友得 ¥200 旅行基金 — gradient, gift icon, share button.
class InviteFriendsBanner extends StatelessWidget {
  const InviteFriendsBanner({
    super.key,
    this.onShare,
    this.onTap,
  });

  final VoidCallback? onShare;
  final VoidCallback? onTap;

  static const double _height = 44;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? onShare,
          borderRadius: BorderRadius.circular(_radius),
          child: Container(
            height: _height,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF43A047),
                  Color(0xFF66BB6A),
                  Color(0xFF81C784),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43A047).withValues(alpha: 0.35),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard_rounded,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '邀请好友得 ¥200 旅行基金',
                    style: TravelTypography.content(Colors.white, fontSize: 13)
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Material(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: onShare,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share_rounded, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '分享',
                            style: TravelTypography.label(Colors.white, fontSize: 12)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
