import '../domain/companion_detail.dart';

CompanionDetail getCompanionDetail(String id) {
  return CompanionDetail(
    id: id,
    name: '林小游',
    avatar: '',
    images: ['', '', ''],
    age: 28,
    city: '杭州',
    bio: '资深本地陪游，熟悉西湖、灵隐、西溪等线路，擅长摄影与人文讲解，带您深度体验江南韵味。',
    skillTags: ['摄影跟拍', '人文讲解', '路线规划', '方言沟通', '美食推荐'],
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
  );
}
