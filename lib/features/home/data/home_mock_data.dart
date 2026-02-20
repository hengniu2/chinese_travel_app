/// 首页 Mock 数据 - 禁止使用风景摄影 / Unsplash 随机图 / 真实场景照片
/// Header 仅允许：卡通插画 URL、AI 生成图 URL、或本地 asset（assets/images/header_cartoon.png）

// ─── Hero 顶部：仅卡通插画（Q版 / 春节旅行 / 暖色）────────────────────────────────────
/// Header 背景：填 AI 插画 URL 或本地 asset；留空则显示代码绘制的 Q 版插画占位（非照片）。
/// 生成方式：1) 调用 AI image API 生成后填入 URL  2) 提前生成并保存为 asset 后填入路径
const String kHomeHeaderBackgroundUrl = '';
const String kHomeHeaderCartoonUrl = 'assets/header_cartoon_spring_travel.png';
const String kHomeHeaderSceneUrl = '';

/// 标题第一行（可改为你们的品牌/活动文案）
const String kHomeHeaderTitleLine1 = '爱你老己的';
/// 标题第二行
const String kHomeHeaderTitleLine2 = '新春首站之旅';
/// 副标题
const String kHomeHeaderSubtitle = '和享梦游一起出发';

// ─── 推荐人物（种草官）- 头像 + 名字
class HomePersonItem {
  const HomePersonItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
  final String id;
  final String name;
  final String avatarUrl;
}

final List<HomePersonItem> kHomePeople = [
  HomePersonItem(
    id: '1',
    name: '成果',
    avatarUrl: 'https://picsum.photos/seed/person1/200/200',
  ),
  HomePersonItem(
    id: '2',
    name: '李倩',
    avatarUrl: 'https://picsum.photos/seed/person2/200/200',
  ),
  HomePersonItem(
    id: '3',
    name: '旅行菌',
    avatarUrl: 'https://picsum.photos/seed/person3/200/200',
  ),
];

// ─── 亲子活动推荐 - 图片 + 标签 + 标题
class HomeFamilyActivityItem {
  const HomeFamilyActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
  });
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
}

/// 亲子活动卡片：使用真实可加载图片，cover + 底部渐变遮罩 + 标题叠加。可换为 AI 插画 URL。
final List<HomeFamilyActivityItem> kHomeFamilyActivities = [
  HomeFamilyActivityItem(
    id: '1',
    title: '嗨妈英语',
    subtitle: '亲子启蒙',
    imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400',
    tag: '武汉市',
  ),
  HomeFamilyActivityItem(
    id: '2',
    title: '嗨妈亲子',
    subtitle: '户外体验',
    imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=400',
    tag: '武汉市',
  ),
  HomeFamilyActivityItem(
    id: '3',
    title: '儿童独立营',
    subtitle: '自然探索',
    imageUrl: 'https://images.unsplash.com/photo-1476703993599-0035a21b17a9?w=400',
    tag: '南宁',
  ),
];

// ─── 周边活动横滑 - 16:9 图 + 日期 + 城市 + 热门标签
class HomeAroundActivityItem {
  const HomeAroundActivityItem({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    this.hot = false,
  });
  final String id;
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final bool hot;
}

final List<HomeAroundActivityItem> kHomeAroundActivities = [
  HomeAroundActivityItem(
    id: '1',
    title: '真·户外体验',
    date: '02.12',
    location: '南宁',
    imageUrl: 'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?w=600',
    hot: true,
  ),
  HomeAroundActivityItem(
    id: '2',
    title: '孝昌美人谷赏',
    date: '02.13',
    location: '孝昌',
    imageUrl: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600',
    hot: false,
  ),
  HomeAroundActivityItem(
    id: '3',
    title: 'WP户外独立营',
    date: '02.14',
    location: '武汉',
    imageUrl: 'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=600',
    hot: false,
  ),
  HomeAroundActivityItem(
    id: '4',
    title: '春日露营节',
    date: '02.15',
    location: '丽江',
    imageUrl: 'https://images.unsplash.com/photo-1470240731273-782f2868c530?w=600',
    hot: true,
  ),
];
