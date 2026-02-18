import '../domain/forum_post.dart';

List<ForumPost> getForumList() {
  return _mockPosts;
}

final List<ForumPost> _mockPosts = [
  const ForumPost(
    id: 'f1',
    title: '丽江古城三日慢游攻略，避开人潮这样玩',
    author: '旅行达人小美',
    likeCount: 1280,
    commentCount: 89,
    publishTime: null,
  ),
  const ForumPost(
    id: 'f2',
    title: '泸沽湖日出与星空拍摄机位分享',
    author: '摄影师老张',
    likeCount: 2560,
    commentCount: 156,
    publishTime: null,
  ),
  const ForumPost(
    id: 'f3',
    title: '带爸妈去云南，适合老人的路线推荐',
    author: '孝心旅行',
    likeCount: 892,
    commentCount: 203,
    publishTime: null,
  ),
  const ForumPost(
    id: 'f4',
    title: '西双版纳亲子游：植物园+野象谷两日',
    author: '萌娃在路上',
    likeCount: 634,
    commentCount: 72,
    publishTime: null,
  ),
  const ForumPost(
    id: 'f5',
    title: '独行喀什：南疆人文与美食记录',
    author: '一人一包',
    likeCount: 1120,
    commentCount: 98,
    publishTime: null,
  ),
  const ForumPost(
    id: 'f6',
    title: '三亚免税店购物+海滩度假攻略',
    author: '买买提',
    likeCount: 445,
    commentCount: 67,
    publishTime: null,
  ),
];
