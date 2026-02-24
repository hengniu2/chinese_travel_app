import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

/// 人物/种草官详情 - 头像、简介、占位内容
class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key, this.id});

  final String? id;

  HomePersonItem? _findPerson(String? id) {
    if (id == null) return null;
    final baseId = id!.split('_').first;
    try {
      return kHomePeople.firstWhere((p) => p.id == baseId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final person = _findPerson(id);

    return Scaffold(
      backgroundColor: AppColors.surfaceWarmWhite,
      appBar: AppBar(
        title: Text(person?.name ?? '种草官'),
        backgroundColor: AppColors.surfaceWarmWhite,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero image or placeholder when empty
            AspectRatio(
              aspectRatio: 16 / 9,
              child: person != null && person.avatarUrl.isNotEmpty
                  ? AppNetworkImage(
                      imageUrl: person.avatarUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (person != null) ...[
                    Text(
                      person.name,
                      style: AppTextStyles.headlineLarge,
                    ),
                    if (person.subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        person.subtitle!,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                    if (person.readCount != null || person.likeCount != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (person.readCount != null)
                            Text(
                              '${person.readCount} 阅读',
                              style: AppTextStyles.caption,
                            ),
                          if (person.readCount != null && person.likeCount != null)
                            const SizedBox(width: 16),
                          if (person.likeCount != null)
                            Text(
                              '${person.likeCount} 点赞',
                              style: AppTextStyles.caption,
                            ),
                        ],
                      ),
                    ],
                  ] else
                    Text(
                      '详情',
                      style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textSecondary),
                    ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '更多旅行故事即将上线，敬请期待。',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 80,
          color: AppColors.textTertiary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
