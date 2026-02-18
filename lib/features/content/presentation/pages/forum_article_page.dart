import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/forum_post_detail_mock.dart';
import '../../domain/forum_post_detail.dart';

/// 文章详情页（论坛结构）：标题、正文（可展开）、评论区、发表评论
class ForumArticlePage extends StatefulWidget {
  const ForumArticlePage({super.key, required this.id});

  final String id;

  @override
  State<ForumArticlePage> createState() => _ForumArticlePageState();
}

class _ForumArticlePageState extends State<ForumArticlePage> {
  late ForumPostDetail _detail;
  bool _bodyExpanded = false;
  final _commentController = TextEditingController();
  static const int _bodyMaxLinesCollapsed = 5;

  @override
  void initState() {
    super.initState();
    _detail = getForumPostDetail(widget.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  static String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inDays > 0) return '${diff.inDays}天前';
    if (diff.inHours > 0) return '${diff.inHours}小时前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分钟前';
    return '刚刚';
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    _commentController.clear();
    setState(() {
      _detail = ForumPostDetail(
        id: _detail.id,
        title: _detail.title,
        body: _detail.body,
        author: _detail.author,
        likeCount: _detail.likeCount,
        commentCount: _detail.commentCount + 1,
        comments: [
          ..._detail.comments,
          ForumComment(
            id: 'new_${DateTime.now().millisecondsSinceEpoch}',
            userName: '我',
            content: text,
            time: DateTime.now(),
          ),
        ],
        coverUrl: _detail.coverUrl,
        publishTime: _detail.publishTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.articleTitle ?? '文章'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_horiz_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  _buildAuthorBar(),
                  _buildBodySection(l10n),
                  _buildCommentsSection(l10n),
                ],
              ),
            ),
          ),
          _buildCommentInput(l10n),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        _detail.title,
        style: AppTextStyles.headlineMedium.copyWith(height: 1.35),
      ),
    );
  }

  Widget _buildAuthorBar() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              _detail.author.isNotEmpty ? _detail.author.substring(0, 1) : '?',
              style: TextStyle(fontSize: 14.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              _detail.author,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.favorite_border_rounded, size: 18.sp, color: AppColors.textTertiary),
          SizedBox(width: 4.w),
          Text('${_detail.likeCount}', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
          SizedBox(width: 12.w),
          Icon(Icons.chat_bubble_outline_rounded, size: 18.sp, color: AppColors.textTertiary),
          SizedBox(width: 4.w),
          Text('${_detail.commentCount}', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildBodySection(AppLocalizations? l10n) {
    final lineCount = '\n'.allMatches(_detail.body).length + 1;
    final needExpand = lineCount > _bodyMaxLinesCollapsed || _detail.body.length > 200;
    final showExpand = needExpand && !_bodyExpanded;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _detail.body,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            maxLines: showExpand ? _bodyMaxLinesCollapsed : null,
            overflow: showExpand ? TextOverflow.ellipsis : null,
          ),
          if (showExpand)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: GestureDetector(
                onTap: () => setState(() => _bodyExpanded = true),
                child: Text(
                  l10n?.articleExpandFull ?? '展开全文',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          if (needExpand && _bodyExpanded)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: GestureDetector(
                onTap: () => setState(() => _bodyExpanded = false),
                child: Text(
                  l10n?.articleCollapse ?? '收起',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(AppLocalizations? l10n) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n?.articleComments(_detail.comments.length) ?? '评论区 (${_detail.comments.length})', style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          if (_detail.comments.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  l10n?.articleNoComments ?? '暂无评论，快来抢沙发',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              ),
            )
          else
            ..._detail.comments.map((c) => _commentTile(c)),
        ],
      ),
    );
  }

  Widget _commentTile(ForumComment c) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.surface,
            child: Text(
              c.userName.isNotEmpty ? c.userName.substring(0, 1) : '?',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.userName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(width: 8.w),
                    Text(_formatTime(c.time), style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(c.content, style: AppTextStyles.bodyMedium.copyWith(height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(AppLocalizations? l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h + MediaQuery.of(context).padding.bottom),
      color: AppColors.backgroundCard,
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: l10n?.chatSaySomething ?? '说点什么...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                ),
                style: AppTextStyles.bodyMedium,
              ),
            ),
            SizedBox(width: 10.w),
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
              child: InkWell(
                onTap: _submitComment,
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Text(l10n?.articlePostComment ?? '发表', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
