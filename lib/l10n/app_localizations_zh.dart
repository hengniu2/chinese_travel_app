// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '享梦游';

  @override
  String get tabHome => '首页';

  @override
  String get tabJoinUs => '加入我们';

  @override
  String get tabPlanner => '旅行规划师';

  @override
  String get tabMessages => '消息';

  @override
  String get tabProfile => '我的';

  @override
  String get homeToursCardTitle => '精选旅行线路';

  @override
  String get homeToursCardSubtitle => '按城市·价格·天数·出发时间·类型筛选';

  @override
  String get homeHotelsCardTitle => '酒店';

  @override
  String get homeHotelsCardSubtitle => '日期·价格·星级·排序';

  @override
  String get homeOrdersCardTitle => '我的订单';

  @override
  String get homeOrdersCardSubtitle => '全部·待付款·待出行·已完成·退款';

  @override
  String get toursTitle => '精选旅行线路';

  @override
  String get tourBookNow => '立即预订';

  @override
  String get tourOrderTitle => '填写订单';

  @override
  String get tourSubmitPay => '提交并去支付';

  @override
  String get tourAddTraveler => '添加出行人';

  @override
  String get hotelsTitle => '酒店';

  @override
  String get hotelBook => '预订';

  @override
  String get hotelOrderTitle => '填写订单';

  @override
  String get hotelAddGuest => '添加入住人';

  @override
  String get hotelPricePerNight => '/晚';

  @override
  String get ordersTitle => '我的订单';

  @override
  String get orderDetailTitle => '订单详情';

  @override
  String get orderInfo => '订单信息';

  @override
  String get orderAmount => '订单金额';

  @override
  String get orderTravelers => '出行人信息';

  @override
  String get orderPaymentStatus => '支付状态';

  @override
  String get orderPaid => '已支付';

  @override
  String get orderUnpaid => '待支付';

  @override
  String get orderRefund => '申请退款';

  @override
  String get orderContactService => '联系客服';

  @override
  String get orderContactServiceHint => '订单问题可咨询在线客服';

  @override
  String get orderRefundSubmitted => '已提交退款申请';

  @override
  String get orderContactOpening => '即将打开客服';

  @override
  String get orderGoToPay => '去支付';

  @override
  String get orderNoOrders => '暂无订单';

  @override
  String get orderReturnToOrders => '返回订单页';

  @override
  String get ordersTabAll => '全部';

  @override
  String get ordersTabUnpaid => '待付款';

  @override
  String get ordersTabUpcoming => '待出行';

  @override
  String get ordersTabDone => '已完成';

  @override
  String get ordersTabRefund => '退款';

  @override
  String get orderNo => '订单编号';

  @override
  String get orderType => '订单类型';

  @override
  String get orderProduct => '商品';

  @override
  String get orderSpec => '规格';

  @override
  String get orderTravelDate => '出发日期';

  @override
  String get orderCheckIn => '入住';

  @override
  String get orderCreateTime => '下单时间';

  @override
  String get orderTypeTour => '旅行团';

  @override
  String get orderTypeHotel => '酒店';

  @override
  String get orderViewDetail => '查看详情';

  @override
  String get orderBookAgain => '再次预订';

  @override
  String get orderViewRefund => '查看退款';

  @override
  String get orderTravelDateLabel => '出发日期';

  @override
  String get orderCheckOut => '退房';

  @override
  String get paymentTitle => '收银台';

  @override
  String get paymentAmountDue => '应付金额 ';

  @override
  String paymentOrderNo(String orderId) {
    return '订单号 $orderId';
  }

  @override
  String get paymentSelectMethod => '选择支付方式';

  @override
  String get paymentAlipay => '支付宝';

  @override
  String get paymentAlipayHint => '使用支付宝完成支付';

  @override
  String get paymentWechat => '微信支付';

  @override
  String get paymentWechatHint => '使用微信完成支付';

  @override
  String get paymentConfirm => '确认支付';

  @override
  String get paymentPaying => '支付中...';

  @override
  String get paymentDoNotClose => '请勿关闭页面';

  @override
  String get paymentSuccess => '支付成功';

  @override
  String get paymentFailed => '支付失败';

  @override
  String get paymentRetry => '重试';

  @override
  String get paymentSelectMethodFirst => '请选择支付方式';

  @override
  String get paymentFailedHint => '请重试或更换支付方式';

  @override
  String get chatTitle => '消息';

  @override
  String get chatNoMessages => '暂无消息';

  @override
  String get chatSaySomething => '说点什么...';

  @override
  String get chatSend => '发表';

  @override
  String get forumTitle => '旅游社区';

  @override
  String get forumNoContent => '暂无内容';

  @override
  String get articleTitle => '文章';

  @override
  String articleComments(int count) {
    return '评论区 ($count)';
  }

  @override
  String get articleNoComments => '暂无评论，快来抢沙发';

  @override
  String get articleExpandFull => '展开全文';

  @override
  String get articleCollapse => '收起';

  @override
  String get articlePostComment => '发表';

  @override
  String get profileTitle => '我的';

  @override
  String get profileLogin => '点击登录';

  @override
  String get profileLoggedIn => '已登录';

  @override
  String get profileLogout => '退出登录';

  @override
  String get profileVerified => '已实名认证';

  @override
  String get profileNotVerified => '未实名认证';

  @override
  String get profileMyOrders => '我的订单';

  @override
  String get profileFavorites => '收藏';

  @override
  String get profileWallet => '钱包';

  @override
  String get profileCoupons => '优惠券';

  @override
  String get profileMessages => '消息';

  @override
  String get profileSettings => '设置';

  @override
  String profileFeatureComing(String name) {
    return '$name 功能开发中';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get languageZh => '中文';

  @override
  String get languageEn => 'English';

  @override
  String get realNameVerifyTitle => '实名认证';

  @override
  String get realNameVerifyHint => '请填写您的真实姓名与身份证号，用于实名认证';

  @override
  String get realNameVerifyName => '姓名';

  @override
  String get realNameVerifyNameHint => '请输入真实姓名';

  @override
  String get realNameVerifyIdCard => '身份证';

  @override
  String get realNameVerifyIdCardHint => '请输入身份证号';

  @override
  String get realNameVerifySubmit => '提交认证';

  @override
  String get realNameVerifySuccess => '实名认证提交成功';

  @override
  String get realNameVerifyNameRequired => '请填写姓名';

  @override
  String get realNameVerifyIdCardInvalid => '请填写正确的身份证号';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonCancel => '取消';

  @override
  String get commonSave => '保存';

  @override
  String get commonSearch => '搜索';

  @override
  String get commonLoading => '加载中...';

  @override
  String get tourOrderProductPerPerson => '/人起';

  @override
  String get hotelOrderProductPerNight => '/晚';

  @override
  String get orderCardOrder => '订单';

  @override
  String get filterPriceRange => '价格区间';

  @override
  String get filterStar => '星级筛选';

  @override
  String get filterSort => '排序';

  @override
  String get filterAll => '不限';

  @override
  String get checkInOut => '入住/退房';

  @override
  String get hotelEmpty => '暂无符合条件的酒店';

  @override
  String get tourEmpty => '暂无符合条件的线路';

  @override
  String get filterClear => '清除筛选';

  @override
  String get authWelcomeBack => '欢迎回来';

  @override
  String get authLoginSubtitle => '登录享梦游，发现更多旅行';

  @override
  String get authPhone => '手机号';

  @override
  String get authPassword => '密码';

  @override
  String get authLogin => '登录';

  @override
  String get authVerifyCodeLogin => '验证码登录';

  @override
  String get authVerifyCodeLoginSubtitle => '未注册手机号验证后将自动创建账号';

  @override
  String get authForgotPassword => '忘记密码？';

  @override
  String get authNoAccount => '还没有账号？';

  @override
  String get authRegisterNow => '立即注册';

  @override
  String get authCreateAccount => '创建账号';

  @override
  String get authRegisterSubtitle => '注册享梦游，开启绿色旅行';

  @override
  String get authVerifyCode => '验证码';

  @override
  String get authSetPassword => '设置密码';

  @override
  String get authConfirmPassword => '确认密码';

  @override
  String get authRegister => '注册';

  @override
  String get authHasAccount => '已有账号？';

  @override
  String get authGoToLogin => '去登录';

  @override
  String get authResetPassword => '重置密码';

  @override
  String get authResetPasswordSubtitle => '通过手机验证码重置登录密码';

  @override
  String get authNewPassword => '新密码';

  @override
  String get authConfirmNewPassword => '确认新密码';

  @override
  String get authConfirmReset => '确认重置';

  @override
  String get authUsePasswordLogin => '使用密码登录';

  @override
  String get authVerifyCodeSent => '验证码已发送';

  @override
  String get authPasswordResetSuccess => '密码已重置，请登录';

  @override
  String get authAgreementRequired => '请先阅读并同意用户协议和隐私政策';

  @override
  String get authForgotPasswordPageTitle => '忘记密码';

  @override
  String get sectionGuests => '入住人信息';

  @override
  String get sectionTravelers => '出行人信息';

  @override
  String get sectionAgreement => '同意协议';

  @override
  String get orderGuestHint => '请填写每位入住人的姓名、身份证、手机号，确保与证件一致';

  @override
  String get orderTravelerHint => '请填写每位出行人的姓名、身份证、手机号，确保与证件一致';

  @override
  String orderGuestNameError(int n) {
    return '请填写第$n位入住人姓名';
  }

  @override
  String orderTravelerNameError(int n) {
    return '请填写第$n位出行人姓名';
  }

  @override
  String orderGuestIdError(int n) {
    return '请填写第$n位入住人身份证号';
  }

  @override
  String orderTravelerIdError(int n) {
    return '请填写第$n位出行人身份证号';
  }

  @override
  String orderGuestPhoneError(int n) {
    return '请填写第$n位入住人手机号';
  }

  @override
  String orderTravelerPhoneError(int n) {
    return '请填写第$n位出行人手机号';
  }

  @override
  String get orderAgreementRequired => '请阅读并同意用户协议与隐私政策';

  @override
  String get hotelNoRooms => '暂无可订房型';

  @override
  String get guestLabel => '入住人';

  @override
  String get commonRetry => '重试';

  @override
  String get filterSelectCity => '选择城市';

  @override
  String get filterSelectPrice => '选择价格';

  @override
  String get filterSelectDays => '选择天数';

  @override
  String get filterSelectType => '选择类型';

  @override
  String tourDaysNights(int days, int nights) {
    return '$days天$nights晚';
  }

  @override
  String tourDepartFrom(String city) {
    return '$city出发';
  }

  @override
  String get priceFrom => '起';

  @override
  String tourDayTitle(int day, String title) {
    return '第$day天 $title';
  }

  @override
  String get sectionItinerary => '行程时间轴';

  @override
  String get sectionHighlights => '行程亮点';

  @override
  String get sectionCost => '费用说明';

  @override
  String get sectionCostIncluded => '费用包含';

  @override
  String get sectionCostExcluded => '费用不含';

  @override
  String get sectionHotelInfo => '酒店信息';

  @override
  String get sectionPolicy => '退改政策';

  @override
  String get sectionReviews => '用户评价';

  @override
  String get hotelSectionRooms => '房型列表';

  @override
  String get hotelSectionPolicy => '取消政策';

  @override
  String get hotelSectionFacilities => '设施';

  @override
  String get hotelSectionReviews => '评价';

  @override
  String get hotelScoreSuffix => '分';

  @override
  String get roomAvailable => '可订';

  @override
  String roomRemaining(int count) {
    return '仅剩$count间';
  }

  @override
  String get roomLimited => '紧张';

  @override
  String get roomSoldOut => '售罄';

  @override
  String get chatInputHint => '输入消息';

  @override
  String chatOrderCard(String id) {
    return '订单 $id';
  }

  @override
  String get travelerFormName => '姓名';

  @override
  String get travelerFormIdCard => '身份证';

  @override
  String get travelerFormPhone => '手机号';

  @override
  String get companionOrderTitle => '填写订单';

  @override
  String get companionSubmitOrder => '提交订单';

  @override
  String get companionOrderSuccess => '订单提交成功';

  @override
  String get companionAddTraveler => '添加随行人员';

  @override
  String get companionRemarksHint => '选填，如特殊需求、集合地点等';

  @override
  String get companionSectionSkills => '技能标签';

  @override
  String get companionSectionDescription => '服务说明';

  @override
  String get companionSectionPackages => '套餐';

  @override
  String get companionSectionCalendar => '档期日历';

  @override
  String get companionViewAll => '查看全部';

  @override
  String get companionSectionReviews => '评价';

  @override
  String get plannerTabTours => '行程/跟团游';
}
