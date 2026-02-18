import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/forum_post.dart';

/// 论坛帖子卡片：标题、封面、作者、点赞、评论数
class ForumPostCard extends StatelessWidget {
  const ForumPostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  final ForumPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: AppRadius.cardRadius,
            boxShadow: [
              ...AppShadow.card,
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCover(),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: AppTextStyles.headlineSmall.copyWith(height: 1.35),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10.r,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            post.author.isNotEmpty ? post.author.substring(0, 1) : '?',
                            style: TextStyle(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            post.author,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(Icons.favorite_border_rounded, size: 16.sp, color: AppColors.textTertiary),
                        SizedBox(width: 4.w),
                        Text('${post.likeCount}', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                        SizedBox(width: 16.w),
                        Icon(Icons.chat_bubble_outline_rounded, size: 16.sp, color: AppColors.textTertiary),
                        SizedBox(width: 4.w),
                        Text('${post.commentCount}', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      height: 140.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight2, AppColors.primaryLight],
        ),
      ),
      child: post.coverUrl != null && post.coverUrl!.isNotEmpty
          ? Image.network(
              post.coverUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _coverPlaceholder(),
            )
          : _coverPlaceholder(),
    );
  }

  Widget _coverPlaceholder() {
    return Center(
      child: Icon(Icons.article_outlined, size: 48.sp, color: AppColors.primary.withValues(alpha: 0.5)),
    );
  }
}
