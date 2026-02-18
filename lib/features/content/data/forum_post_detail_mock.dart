import '../domain/forum_post_detail.dart';

ForumPostDetail getForumPostDetail(String id) {
  if (_mockDetails.containsKey(id)) return _mockDetails[id]!;
  return _mockDetails['f1']!;
}

final Map<String, ForumPostDetail> _mockDetails = {
  'f1': ForumPostDetail(
    id: 'f1',
    title: '丽江古城三日慢游攻略，避开人潮这样玩',
    body: '''第一次来丽江，不想赶景点，所以做了三天慢游安排。

【Day1】下午抵达，入住古城南门附近。傍晚逛四方街、五一街，晚饭在古城里解决，推荐试试腊排骨火锅。晚上可以找一家清吧听歌。

【Day2】睡到自然醒，上午在古城里走走停停，木府值得进去看看。下午打车去束河古镇，人比大研少很多，适合拍照。傍晚回古城。

【Day3】早起去黑龙潭看雪山倒影（要赶早，否则逆光）。然后去忠义市场感受本地烟火气，买点水果。下午根据航班时间返程。

住宿建议选古城边缘，拖箱子方便。吃饭可以走远一点到新城，更便宜。''',
    author: '旅行达人小美',
    likeCount: 1280,
    commentCount: 89,
    publishTime: DateTime(2025, 2, 15),
    comments: [
      ForumComment(
        id: 'c1',
        userName: '路人甲',
        content: '收藏了，下月去正好用上！',
        time: DateTime(2025, 2, 16, 10, 20),
      ),
      ForumComment(
        id: 'c2',
        userName: '丽江土著',
        content: '腊排骨推荐有一家叫阿婆腊排骨，本地人也常去。',
        time: DateTime(2025, 2, 16, 14, 5),
      ),
      ForumComment(
        id: 'c3',
        userName: '背包客',
        content: '束河确实比大研安静，适合发呆。',
        time: DateTime(2025, 2, 17, 9, 0),
      ),
    ],
  ),
  'f2': ForumPostDetail(
    id: 'f2',
    title: '泸沽湖日出与星空拍摄机位分享',
    body: '''分享几个亲测好用的机位，适合拍日出和星空。

【日出】里格观景台、尼塞村湖边。建议提前查日出时间，提前半小时到。冬季湖面有晨雾更出片。

【星空】大落水村往女神山方向，光污染少。需要三脚架，快门线或延时2秒。''',
    author: '摄影师老张',
    likeCount: 2560,
    commentCount: 156,
    publishTime: DateTime(2025, 2, 14),
    comments: [
      ForumComment(
        id: 'c1',
        userName: '摄影小白',
        content: '求参数！',
        time: DateTime(2025, 2, 15, 18, 30),
      ),
    ],
  ),
};
