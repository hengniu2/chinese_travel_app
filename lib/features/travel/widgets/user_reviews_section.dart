import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';

/// 用户真实评价 — social proof section for conversion.
/// Horizontal scroll, compact cards, avatar + rating + comment + travel photos.
class UserReviewsSection extends StatelessWidget {
  const UserReviewsSection({super.key});

  static const _reviews = [
    _ReviewItem(
      username: '小美*',
      rating: 5,
      comment: '行程安排很贴心，酒店和航班都帮我们选好了，省心！',
      photoCount: 3,
    ),
    _ReviewItem(
      username: '旅行达人L',
      rating: 5,
      comment: '第一次用定制行程，体验超出预期，下次还来',
      photoCount: 4,
    ),
    _ReviewItem(
      username: '阳光*姐',
      rating: 5,
      comment: '客服响应快，行程修改也很灵活，推荐',
      photoCount: 2,
    ),
    _ReviewItem(
      username: '阿杰*',
      rating: 5,
      comment: '一家三口出行，行程安排得很合理，孩子玩得开心',
      photoCount: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_rounded, size: 18, color: TravelDesignTokens.primary),
              const SizedBox(width: 6),
              Text(
                '用户真实评价',
                style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 15),
              ),
              const SizedBox(width: 6),
              _RealBadge(),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 14),
              itemCount: _reviews.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _ReviewCard(item: _reviews[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RealBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Text(
        '真实体验',
        style: TravelTypography.hint(AppColors.success, fontSize: 10)
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ReviewItem {
  const _ReviewItem({
    required this.username,
    required this.rating,
    required this.comment,
    required this.photoCount,
  });
  final String username;
  final int rating;
  final String comment;
  final int photoCount;
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.item});

  final _ReviewItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: TravelDesignTokens.primary.withValues(alpha: 0.3),
                child: Text(
                  item.username.isNotEmpty ? item.username[0] : '?',
                  style: TravelTypography.content(const Color(0xFF1A1A1A), fontSize: 12),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.username,
                  style: TravelTypography.content(AppColors.textPrimary, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...List.generate(
                5,
                (i) => Icon(
                  i < item.rating ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 12,
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              item.comment,
              style: TravelTypography.hint(AppColors.textSecondary, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: item.photoCount.clamp(1, 5),
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (_, __) => _PhotoThumbnail(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TravelDesignTokens.primary.withValues(alpha: 0.5),
            TravelDesignTokens.primary.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Icon(
        Icons.photo_camera_rounded,
        size: 16,
        color: Colors.white.withValues(alpha: 0.9),
      ),
    );
  }
}
