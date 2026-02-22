import '../domain/companion_detail.dart';

CompanionDetail getCompanionDetail(String id) {
  switch (id) {
    case '2':
      return _companion2;
    case '3':
      return _companion3;
    case '4':
      return _companion4;
    case '5':
      return _companion5;
    case '6':
      return _companion6;
    case '1':
    default:
      return _companion1;
  }
}

final CompanionDetail _companion1 = CompanionDetail(
  id: '1',
  name: '林小游',
  avatar: '',
  images: [
    'https://picsum.photos/600/400?random=lin1',
    'https://picsum.photos/600/400?random=lin2',
    'https://picsum.photos/600/400?random=lin3',
    'https://picsum.photos/600/400?random=lin4',
  ],
  age: 28,
  city: '杭州',
  bio: '资深本地陪游，熟悉西湖、灵隐、西溪等线路，擅长摄影与人文讲解，带您深度体验江南韵味。曾从事旅游策划工作五年，持有导游证，多次参与文化类纪录片拍摄。希望用镜头和讲解，让每一位客人带走独家的杭州记忆。',
  skillTags: ['摄影跟拍', '人文讲解', '路线规划', '美食推荐', '接机服务', '多语言'],
  serviceDesc: '· 全程陪同游览，根据您的节奏调整行程\n· 提供拍摄建议与取景指导\n· 可协助预订门票、餐厅\n· 服务时长按套餐约定，超时需另行协商',
  packages: [
    CompanionPackage(name: '半日陪游（4小时）', desc: '适合市区景点深度游', price: 298, unit: '/人'),
    CompanionPackage(name: '一日陪游（8小时）', desc: '含午餐建议与路线规划', price: 568, unit: '/人'),
    CompanionPackage(name: '两日定制', desc: '可含周边古镇或自然景区', price: 1088, unit: '/人'),
  ],
  reviews: [
    CompanionReview(userName: '旅行者A', avatar: '', rating: 5, content: '林老师非常专业，讲解细致，拍照角度也很棒，西湖一日游体验很好！', date: '2025-01-15'),
    CompanionReview(userName: '旅行者B', avatar: '', rating: 5, content: '沟通顺畅，行程安排合理，下次来杭州还会约。', date: '2025-01-08'),
  ],
  rating: 4.9,
  reviewCount: 128,
  isVerified: true,
  responseHint: '响应很快',
  experienceYears: 3,
  completedOrders: 356,
  isOnline: true,
  languages: ['中文', 'English'],
  responseTime: '5分钟内',
  acceptRate: '98%',
);

final CompanionDetail _companion2 = CompanionDetail(
  id: '2',
  name: '陈漫行',
  avatar: '',
  images: ['', '', ''],
  age: 32,
  city: '北京',
  bio: '北京土著，专注故宫、胡同与长城线路，历史与摄影双修，带您读懂皇城根下的烟火气。历史系出身，在故宫做过志愿讲解，对明清史和建筑细节如数家珍。',
  skillTags: ['历史文化', '故宫讲解', '胡同游', '摄影跟拍'],
  serviceDesc: '· 故宫/长城/胡同任选或组合，深度讲解\n· 提供最佳拍摄机位与时段建议\n· 可代订门票、推荐地道餐馆\n· 灵活时长，半日/一日/多日均可',
  packages: [
    CompanionPackage(name: '故宫半日', desc: '中轴线+珍宝馆重点讲解', price: 368, unit: '/人'),
    CompanionPackage(name: '故宫+胡同一日', desc: '上午故宫下午胡同漫步', price: 688, unit: '/人'),
    CompanionPackage(name: '长城一日', desc: '含往返交通建议与路线', price: 498, unit: '/人'),
  ],
  reviews: [
    CompanionReview(userName: '北方客', avatar: '', rating: 5, content: '陈老师讲故宫特别有料，不虚此行。', date: '2025-01-12'),
    CompanionReview(userName: '南来雁', avatar: '', rating: 5, content: '胡同游很有味道，拍照点位也找得好。', date: '2025-01-05'),
  ],
  rating: 4.8,
  reviewCount: 96,
  isVerified: true,
  responseHint: '接单率98%',
  experienceYears: 5,
  completedOrders: 520,
  isOnline: true,
);

final CompanionDetail _companion3 = CompanionDetail(
  id: '3',
  name: '苏江南',
  avatar: '',
  images: ['', '', ''],
  age: 26,
  city: '苏州',
  bio: '园林与昆曲爱好者，熟悉拙政园、虎丘、周庄等，可带您品茶听曲、寻味苏帮菜。',
  skillTags: ['园林讲解', '昆曲文化', '美食推荐', '古镇导览'],
  serviceDesc: '· 园林深度讲解（建筑、典故、造园手法）\n· 可选昆曲/评弹体验与订票\n· 苏帮菜与小吃路线推荐\n· 半日/一日/古镇一日可选',
  packages: [
    CompanionPackage(name: '园林半日', desc: '拙政园或留园深度讲解', price: 268, unit: '/人'),
    CompanionPackage(name: '园林+平江路一日', desc: '园林+老街+茶社体验', price: 488, unit: '/人'),
    CompanionPackage(name: '周庄一日', desc: '水乡古镇导览与美食', price: 398, unit: '/人'),
  ],
  reviews: [
    CompanionReview(userName: '园林迷', avatar: '', rating: 5, content: '讲解专业，对园林和昆曲都很有研究。', date: '2025-01-10'),
  ],
);

final CompanionDetail _companion4 = CompanionDetail(
  id: '4',
  name: '王西安',
  avatar: '',
  images: ['', '', ''],
  age: 30,
  city: '西安',
  bio: '西安本地人，兵马俑、城墙、回民街熟门熟路，历史与美食兼顾，夜景跟拍拿手。',
  skillTags: ['兵马俑讲解', '美食推荐', '夜景跟拍', '方言沟通'],
  serviceDesc: '· 兵马俑/华清池/城墙等线路专业讲解\n· 回民街与陕菜馆推荐\n· 城墙与大唐不夜城夜景跟拍\n· 可协助订票与交通',
  packages: [
    CompanionPackage(name: '兵马俑一日', desc: '含交通建议与深度讲解', price: 328, unit: '/人'),
    CompanionPackage(name: '城墙+回民街半日', desc: '城墙骑行+美食导览', price: 268, unit: '/人'),
    CompanionPackage(name: '夜景跟拍（3小时）', desc: '大唐不夜城/钟楼取景', price: 398, unit: '/人'),
  ],
  reviews: [
    CompanionReview(userName: '历史控', avatar: '', rating: 5, content: '兵马俑讲得很细，不跟团也能听明白。', date: '2025-01-08'),
  ],
);

final CompanionDetail _companion5 = CompanionDetail(
  id: '5',
  name: '李蓉城',
  avatar: '',
  images: ['', '', ''],
  age: 27,
  city: '成都',
  bio: '成都生活多年，熊猫基地、宽窄巷子、火锅串串一条龙，川剧变脸与茶馆体验可安排。',
  skillTags: ['美食推荐', '熊猫基地', '川剧文化', '路线规划'],
  serviceDesc: '· 熊猫基地+市区景点组合\n· 火锅/串串/小吃路线与排队技巧\n· 川剧变脸与茶馆体验推荐\n· 灵活定制一日游',
  packages: [
    CompanionPackage(name: '熊猫基地半日', desc: '早班入园+讲解', price: 248, unit: '/人'),
    CompanionPackage(name: '市区美食一日', desc: '宽窄+锦里+火锅体验', price: 368, unit: '/人'),
    CompanionPackage(name: '都江堰一日', desc: '含交通与讲解', price: 428, unit: '/人'),
  ],
  reviews: [
    CompanionReview(userName: '吃货一枚', avatar: '', rating: 5, content: '跟着吃了一天，每家都靠谱。', date: '2025-01-03'),
  ],
);

final CompanionDetail _companion6 = CompanionDetail(
  id: '6',
  name: '张小沪',
  avatar: '',
  images: ['', '', ''],
  age: 29,
  city: '上海',
  bio: '上海本地人，外滩、豫园、武康路、迪士尼周边都熟，摄影与美食路线均可定制。',
  skillTags: ['外滩夜景', '弄堂文化', '摄影跟拍', '美食推荐'],
  serviceDesc: '· 外滩/豫园/法租界等经典与网红路线\n· 夜景与街拍机位指导\n· 本帮菜与小吃推荐\n· 半日/一日/两日灵活',
  packages: [
    CompanionPackage(name: '外滩+豫园半日', desc: '经典地标+拍照', price: 298, unit: '/人'),
    CompanionPackage(name: '法租界一日', desc: '武康路、安福路、田子坊', price: 358, unit: '/人'),
    CompanionPackage(name: '夜景跟拍（3小时）', desc: '外滩+陆家嘴取景', price: 428, unit: '/人'),
  ],
  reviews: [
    CompanionReview(userName: '魔都游', avatar: '', rating: 5, content: '拍照点位绝了，夜景大片。', date: '2025-01-01'),
  ],
);
