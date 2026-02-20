import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/forum_post.dart';
import '../../data/forum_list_mock.dart';
import '../widgets/forum_post_card.dart';

/// 论坛列表页：标题、封面、作者、点赞、评论数
class ForumListPage extends StatefulWidget {
  const ForumListPage({super.key});

  @override
  State<ForumListPage> createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  List<ForumPost>? _posts;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _posts = getForumList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n?.forumTitle ?? '旅游社区'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: AppGradientBackground(
        colors: AppGradientBackground.pageGradient,
        stops: AppGradientBackground.pageGradientStops,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        child: _loading
          ? ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              cacheExtent: 200,
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (_, __) => const AppSkeletonForumCard(),
            )
          : _posts!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum_outlined, size: 64.sp, color: AppColors.textTertiary),
                      SizedBox(height: 16.h),
                      Text(
                        l10n?.forumNoContent ?? '暂无内容',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  cacheExtent: 200,
                  itemCount: _posts!.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (context, index) {
                    final post = _posts![index];
                    return ForumPostCard(
                      post: post,
                      onTap: () => context.push('/article/${post.id}'),
                    );
                  },
                ),
      ),
    );
  }
}
