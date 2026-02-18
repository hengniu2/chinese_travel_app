/// 帖子评论
class ForumComment {
  const ForumComment({
    required this.id,
    required this.userName,
    required this.content,
    required this.time,
  });

  final String id;
  final String userName;
  final String content;
  final DateTime time;
}

/// 帖子详情（文章页）
class ForumPostDetail {
  const ForumPostDetail({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.likeCount,
    required this.commentCount,
    required this.comments,
    this.coverUrl,
    this.publishTime,
  });

  final String id;
  final String title;
  final String body;
  final String author;
  final int likeCount;
  final int commentCount;
  final List<ForumComment> comments;
  final String? coverUrl;
  final DateTime? publishTime;
}
