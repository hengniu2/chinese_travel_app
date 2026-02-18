/// 论坛/帖子列表项
class ForumPost {
  const ForumPost({
    required this.id,
    required this.title,
    required this.author,
    required this.likeCount,
    required this.commentCount,
    this.coverUrl,
    this.authorAvatar,
    this.publishTime,
  });

  final String id;
  final String title;
  final String author;
  final int likeCount;
  final int commentCount;
  final String? coverUrl;
  final String? authorAvatar;
  final DateTime? publishTime;
}
