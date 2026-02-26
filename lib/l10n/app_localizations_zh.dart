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
  String get tabTravelService => '出行服务';

  @override
  String get tabMessages => '消息';

  @override
  String get tabOrders => '订单';

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
  String get hotelListTitle => '酒店列表';

  @override
  String get hotelSearchPlaceholder => '酒店 / 关键词 / 品牌';

  @override
  String get hotelViewDetail => '查看详情';

  @override
  String get hotelViewRoomTypes => '查看房型';

  @override
  String get hotelNoRooms => '暂无可订房型';

  @override
  String get hotelBookingConfirmTitle => '确认订单';

  @override
  String get hotelPriceBreakdown => '费用明细';

  @override
  String get hotelRoomPrice => '房费';

  @override
  String get hotelServiceFee => '服务费';

  @override
  String get hotelContinueToGuest => '下一步：填写入住人';

  @override
  String get hotelBookingGuestTitle => '入住人信息';

  @override
  String get hotelGuestName => '姓名';

  @override
  String get hotelGuestPhone => '手机号';

  @override
  String get hotelGuestIdNumber => '身份证号';

  @override
  String get hotelSpecialRequest => '特殊要求';

  @override
  String get hotelSpecialRequestHint => '如：提前入住、加枕头等';

  @override
  String get hotelProceedToPayment => '去支付';

  @override
  String get hotelBookingPaymentTitle => '支付';

  @override
  String get hotelBookingSuccessTitle => '预订成功！';

  @override
  String get hotelBookingSuccessMessage => '您的预订已确认。';

  @override
  String get paymentCreditCard => '信用卡';

  @override
  String get paymentCreditCardHint => '使用信用卡或借记卡支付';

  @override
  String get hotelCompareTitle => '酒店对比';

  @override
  String get hotelCompareEmpty => '请先添加最多3家酒店进行对比';

  @override
  String get hotelCompareItem => '项目';

  @override
  String get hotelComparePrice => '价格';

  @override
  String get hotelCompareRating => '评分';

  @override
  String get hotelCompareDistance => '距离';

  @override
  String get hotelCompareFacilities => '设施';

  @override
  String get hotelCompareCancellation => '取消政策';

  @override
  String get hotelMapSheetTitle => '选择酒店';

  @override
  String get hotelBundleSectionTitle => '超值套餐推荐';

  @override
  String hotelBundleSavings(Object amount) {
    return '已为您节省 ¥$amount';
  }

  @override
  String get hotelBundleCta => '立即打包预订';

  @override
  String get hotelSmartBadge => '智能推荐';

  @override
  String get hotelSmartPicked => '为你精选';

  @override
  String get hotelGuessYouLike => '猜你喜欢';

  @override
  String get hotelMoreHotels => '更多酒店';

  @override
  String get hotelSimilarHotels => '相似酒店';

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
  String get orderNoOrdersDescription => '您的旅行订单将显示在这里';

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
  String get chatSearchHint => '搜索联系人、消息';

  @override
  String get chatNoSearchResults => '未找到相关对话';

  @override
  String get chatCopy => '复制';

  @override
  String get chatCopied => '已复制';

  @override
  String get chatQuickReplyOk => '好的';

  @override
  String get chatQuickReplyThanks => '谢谢';

  @override
  String get chatQuickReplyLater => '稍后联系';

  @override
  String get chatSubtitle => '智能客服 · 随时为您服务';

  @override
  String get chatGuessYouAsk => '猜你想问';

  @override
  String get chatConsultTrip => '行程咨询';

  @override
  String get chatOrderIssue => '订单问题';

  @override
  String get chatRefundChange => '退款改签';

  @override
  String get chatTickets => '景点门票';

  @override
  String get chatHumanService => '人工客服';

  @override
  String get chatYouCanAsk => '您可以问我：行程、订单、退改、天气…';

  @override
  String get chatStartConsult => '开始咨询';

  @override
  String get chatViewOrder => '查看订单';

  @override
  String get chatChangeTrip => '修改行程';

  @override
  String get chatRefundPolicy => '退改政策';

  @override
  String get chatSendLocation => '发送位置';

  @override
  String get chatViewDetail => '查看详情';

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
  String get profileWalletBalance => '余额';

  @override
  String get profileWalletSubtitle => '旅行钱包 · 安全便捷';

  @override
  String get profileWalletTopUp => '充值';

  @override
  String get profileWalletWithdraw => '提现';

  @override
  String get profileWalletDetails => '明细';

  @override
  String get profileWalletTransactions => '交易记录';

  @override
  String get profileWalletNoTransactions => '暂无交易记录';

  @override
  String get profileCoupons => '优惠券';

  @override
  String get profileMessages => '消息';

  @override
  String get profileSettings => '设置';

  @override
  String get profileSectionServices => '我的服务';

  @override
  String get profileSectionMore => '更多';

  @override
  String profileFeatureComing(String name) {
    return '$name 功能开发中';
  }

  @override
  String get profileGreetingMorning => '早上好';

  @override
  String get profileGreetingAfternoon => '下午好';

  @override
  String get profileGreetingEvening => '晚上好';

  @override
  String get profileGreetingReady => '准备好新的旅行了吗？';

  @override
  String get profileLoginNow => '立即登录';

  @override
  String get profileLevelExplorer => 'Lv.1 探险家';

  @override
  String get profileCouponExpiring => '即将过期';

  @override
  String get profileCouponTabAvailable => '可使用';

  @override
  String get profileCouponTabUsed => '已使用';

  @override
  String get profileCouponTabExpired => '已过期';

  @override
  String profileCouponCondition(String amount) {
    return '满$amount可用';
  }

  @override
  String profileCouponValidUntil(String date) {
    return '有效期至 $date';
  }

  @override
  String get profileCouponEmpty => '暂无优惠券';

  @override
  String get profileCouponUse => '去使用';

  @override
  String get couponClaimNow => '立即领取';

  @override
  String get couponSelect => '选择优惠券';

  @override
  String couponSavedAmount(String amount) {
    return '已为您节省 ¥$amount';
  }

  @override
  String get couponTypeThreshold => '满减券';

  @override
  String get couponTypeNoThreshold => '无门槛券';

  @override
  String get couponTypeDiscount => '折扣券';

  @override
  String get couponTypeFlash => '限时闪促';

  @override
  String get couponNoThreshold => '无门槛';

  @override
  String couponValidUntil(String date) {
    return '有效期至 $date';
  }

  @override
  String couponFlashRemaining(String time) {
    return '剩余 $time';
  }

  @override
  String couponApplyConfirm(String amount) {
    return '使用该优惠券可省 ¥$amount，确认使用？';
  }

  @override
  String get couponDiscount => '优惠';

  @override
  String get couponFinalAmount => '实付';

  @override
  String get profileFrequentTravelerEmpty => '暂无常用出行人';

  @override
  String get profileFrequentTravelerAdd => '添加出行人';

  @override
  String get profileAddressEmpty => '暂无收货地址';

  @override
  String get profileAddressAdd => '添加地址';

  @override
  String get profileFeedbackHint => '请描述您的建议或问题';

  @override
  String get profileFeedbackSubmit => '提交反馈';

  @override
  String get profileFeedbackSuccess => '感谢您的反馈！';

  @override
  String profileClearCacheSize(String size) {
    return '缓存大小：$size';
  }

  @override
  String get profileClearCacheDo => '清除缓存';

  @override
  String get profileClearCacheDone => '已清除';

  @override
  String get commonName => '姓名';

  @override
  String get commonPhone => '手机号';

  @override
  String get commonIdNumber => '证件号';

  @override
  String get commonAddress => '地址';

  @override
  String get commonDefault => '默认';

  @override
  String get profileTravelPlannerSubtitle => '智能规划你的行程';

  @override
  String get profileSectionTravel => '出行服务';

  @override
  String get profileSectionAssets => '我的资产';

  @override
  String get profileSectionMoreSettings => '更多与设置';

  @override
  String get profileEditProfile => '编辑资料';

  @override
  String get profileMembershipTourist => '游客';

  @override
  String get profileMembershipMember => '会员';

  @override
  String get profileMembershipGold => '黄金会员';

  @override
  String get profileSectionTravelServices => '出行服务';

  @override
  String get profileSectionMyAssets => '我的资产';

  @override
  String get profileSectionSocialGrowth => '社交与成长';

  @override
  String get profileSectionSmartTools => '智能工具';

  @override
  String get profileSectionSettingsSupport => '设置与帮助';

  @override
  String get profileTravelPlanner => '旅行规划师';

  @override
  String get profileTourPackages => '跟团游';

  @override
  String get profileHotels => '酒店';

  @override
  String get profileFlights => '机票';

  @override
  String get profileInsurance => '保险';

  @override
  String get profilePoints => '积分';

  @override
  String get profileInvoice => '开发票';

  @override
  String get profileRewards => '我的奖品';

  @override
  String get profileInviteFriends => '邀请好友';

  @override
  String get profileBecomePlanner => '成为规划师';

  @override
  String get profileReferralCenter => '引荐中心';

  @override
  String get profileItinerary => '行程管理';

  @override
  String get profileExpenseStats => '花费统计';

  @override
  String get profileDownloadedTickets => '已下载票据';

  @override
  String get profileEmergencyContact => '紧急联系人';

  @override
  String get profileHelpCenter => '帮助中心';

  @override
  String get profileFeedback => '意见反馈';

  @override
  String get profileAboutUs => '关于我们';

  @override
  String get profileClearCache => '清除缓存';

  @override
  String get profileMyFriends => '我的朋友';

  @override
  String get profileAllOrders => '全部订单';

  @override
  String get profileSectionMyTools => '我的工具';

  @override
  String get profileSectionCommonSettings => '常用设置';

  @override
  String get profileFrequentTravelers => '常用出行人';

  @override
  String get profileShippingAddress => '收货地址';

  @override
  String get profileIssueInvoice => '开发票';

  @override
  String get profileCourseOrders => '课程订单';

  @override
  String get profileFlightOrders => '机票订单';

  @override
  String get profileHotelOrders => '酒店订单';

  @override
  String get profileMyPrizes => '我的奖品';

  @override
  String get profileReferrer => '引荐人';

  @override
  String get profileTravelCollection => '出行收集';

  @override
  String get profileDataStats => '数据统计';

  @override
  String get profileBadgeNew => '新';

  @override
  String profileUserLabel(String id) {
    return '用户$id';
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
  String get emptyStateNoHotels => '暂时没有找到合适的酒店哦～';

  @override
  String get emptyStateNoRooms => '暂无可用房型，换个日期试试吧～';

  @override
  String get emptyStateNoInternet => '网络开小差了，再试试吧';

  @override
  String get emptyStateLoading => '加载中…';

  @override
  String get emptyStateError => '加载失败，再试试吧';

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
  String get authPhoneVerified => '验证成功，请使用密码登录';

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
  String get companionDiscoveryTitle => '找陪游';

  @override
  String get companionSearchPlaceholder => '城市、技能、关键词';

  @override
  String get companionCityHint => '选择城市';

  @override
  String get companionSortSmart => '智能排序';

  @override
  String get companionSortRating => '评分优先';

  @override
  String get companionSortPriceAsc => '价格从低到高';

  @override
  String get companionSortPriceDesc => '价格从高到低';

  @override
  String get companionSectionFeatured => '热门陪游';

  @override
  String get companionSectionAll => '全部陪游';

  @override
  String companionReviewsCount(Object count) {
    return '$count条评价';
  }

  @override
  String get companionPriceFrom => '起';

  @override
  String get companionEmpty => '暂无符合条件的陪游';

  @override
  String get companionFilterAll => '全部';

  @override
  String get companionBookNow => '立即预约';

  @override
  String companionServiceCount(Object count) {
    return '已服务 $count次';
  }

  @override
  String companionExperienceYears(Object years) {
    return '$years年陪游经验';
  }

  @override
  String companionResponseTime(Object time) {
    return '平均回复 $time';
  }

  @override
  String get companionVerified => '已认证';

  @override
  String get companionPricePerDay => '/ 天';

  @override
  String get plannerTabTours => '行程/跟团游';

  @override
  String get plannerLandingHeroTitle => '规划你的完美旅程';

  @override
  String get plannerLandingHeroSubtitle => '量身定制行程，几步即可开始。';

  @override
  String get plannerModePersonal => '个人定制';

  @override
  String get plannerModeTeam => '团队定制';

  @override
  String get plannerFormDestination => '目的地';

  @override
  String get plannerFormDestinationHint => '你想去哪里？';

  @override
  String get plannerFormDeparture => '出发城市';

  @override
  String get plannerFormDepartureHint => '你的出发地';

  @override
  String get plannerFormDateRange => '出行日期';

  @override
  String get plannerFormDateRangeHint => '选择日期';

  @override
  String get plannerFormTravelers => '出行人数';

  @override
  String get plannerFormTravelersHint => '人数';

  @override
  String get plannerFormBudget => '预算';

  @override
  String get plannerFormBudgetHint => '选填';

  @override
  String get plannerFormThemes => '旅行主题';

  @override
  String get plannerFormThemesHint => '如文化、自然、探险';

  @override
  String get plannerFormCta => '开始规划';

  @override
  String get plannerViewMore => '查看更多';

  @override
  String get plannerFeaturedTitle => '精选套餐';

  @override
  String get plannerFeaturedSeeAll => '查看全部';

  @override
  String get plannerWhyChooseUs => '为什么选我们';

  @override
  String get plannerWhySafety => '安全可靠';

  @override
  String get plannerWhySafetyDesc => '认证合作方，安心预订';

  @override
  String get plannerWhyFlexible => '灵活取消';

  @override
  String get plannerWhyFlexibleDesc => '出发前免费改期';

  @override
  String get plannerWhyLocal => '当地专家';

  @override
  String get plannerWhyLocalDesc => '目的地达人精选';

  @override
  String get plannerFeaturedEmpty => '暂无精选套餐';

  @override
  String get plannerFeaturedEmptyAction => '浏览全部行程';

  @override
  String get plannerGetPlan => '生成我的方案';

  @override
  String get plannerResultTitle => '你的方案';

  @override
  String get plannerResultRecommended => '为你推荐';

  @override
  String get plannerResultNoPackages => '暂无匹配的套餐，试试调整目的地、预算或日期。';

  @override
  String get plannerSavePlan => '保存方案';

  @override
  String get plannerEditPlan => '编辑方案';

  @override
  String get plannerSharePlan => '分享方案';

  @override
  String get plannerRequestConsultant => '预约顾问';

  @override
  String get plannerCustomItinerary => '生成定制行程';

  @override
  String get plannerPlanSaved => '方案已保存';

  @override
  String get plannerShareMessage => '看看我的旅行方案';

  @override
  String get plannerConsultantMessage => '顾问将尽快与您联系。';

  @override
  String plannerMatch(Object score) {
    return '匹配度：$score%';
  }

  @override
  String get discoverySearchHint => '搜索目的地、行程…';

  @override
  String get discoveryFilter => '筛选';

  @override
  String get discoveryCategoryAll => '全部';

  @override
  String get discoveryCategoryGroup => '跟团';

  @override
  String get discoveryCategorySmallGroup => '小团';

  @override
  String get discoveryCategoryFamily => '亲子';

  @override
  String get discoveryCategoryCustom => '定制';

  @override
  String get discoveryCategoryLocal => '周边';

  @override
  String get discoveryChipDeparture => '出发地';

  @override
  String get discoveryChipDays => '天数';

  @override
  String get discoveryChipBudget => '预算';

  @override
  String get discoveryChipTheme => '主题';

  @override
  String get discoveryChipSort => '排序';

  @override
  String get discoverySortRecommended => '推荐';

  @override
  String get discoverySortPriceAsc => '价格从低到高';

  @override
  String get discoverySortPriceDesc => '价格从高到低';

  @override
  String get discoverySortDurationAsc => '行程从短到长';

  @override
  String get discoverySortDurationDesc => '行程从长到短';

  @override
  String get discoverySortRating => '评分优先';

  @override
  String get discoveryEmptyTitle => '暂无匹配行程';

  @override
  String get discoveryEmptySubtitle => '试试调整筛选条件或关键词。';

  @override
  String get discoveryEmptyAction => '清除筛选';

  @override
  String get discoveryAdvancedFilters => '更多筛选';

  @override
  String get discoveryApplyFilters => '应用';

  @override
  String get discoveryClearFilters => '清除';

  @override
  String get discoveryLoadMore => '加载更多';

  @override
  String get discoveryFrom => '起';

  @override
  String get discoveryFilterReset => '重置';

  @override
  String get discoveryFilterPriceRange => '价格区间';

  @override
  String get discoveryFilterDuration => '行程天数';

  @override
  String get discoveryFilterThemes => '主题';

  @override
  String get discoveryFilterGroupSize => '团队规模';

  @override
  String get discoveryFilterDepartureCity => '出发城市';

  @override
  String get discoveryFilterAccommodation => '住宿等级';

  @override
  String get discoveryFilterTransportation => '交通方式';

  @override
  String get discoveryFilterDuration1to3 => '1-3天';

  @override
  String get discoveryFilterDuration4to7 => '4-7天';

  @override
  String get discoveryFilterDuration8to14 => '8-14天';

  @override
  String get discoveryFilterDuration15Plus => '15天以上';

  @override
  String get discoveryFilterGroupSolo => '单人';

  @override
  String get discoveryFilterGroup2to4 => '2-4人';

  @override
  String get discoveryFilterGroup5to9 => '5-9人';

  @override
  String get discoveryFilterGroup10Plus => '10人以上';

  @override
  String get discoveryFilterAccomEconomy => '经济';

  @override
  String get discoveryFilterAccomComfort => '舒适';

  @override
  String get discoveryFilterAccomPremium => '高端';

  @override
  String get discoveryFilterAccomLuxury => '奢华';

  @override
  String get discoveryFilterTransportFlight => '飞机';

  @override
  String get discoveryFilterTransportTrain => '火车/高铁';

  @override
  String get discoveryFilterTransportBus => '大巴';

  @override
  String get discoveryFilterTransportSelfDrive => '自驾';

  @override
  String get discoveryFilterDepartureHint => '如：上海、北京';

  @override
  String get detailShare => '分享';

  @override
  String get detailBook => '立即预订';

  @override
  String get detailTabOverview => '概览';

  @override
  String get detailTabItinerary => '行程';

  @override
  String get detailTabCost => '费用';

  @override
  String get detailTabNotice => '须知';

  @override
  String get detailTabReviews => '评价';

  @override
  String get detailFrom => '起';

  @override
  String get detailPerPerson => '/人';

  @override
  String detailDay(Object n) {
    return '第$n天';
  }

  @override
  String get detailMealsIncluded => '餐食';

  @override
  String get detailHotel => '住宿';

  @override
  String get detailIncluded => '费用包含';

  @override
  String get detailExcluded => '费用不含';

  @override
  String get detailOptionalUpgrades => '可选升级';

  @override
  String get detailNoticeVisa => '签证';

  @override
  String get detailNoticeInsurance => '保险';

  @override
  String get detailNoticeCancellation => '取消政策';

  @override
  String get detailNoticeImportant => '重要提示';

  @override
  String get detailReviewsSummary => '评分概览';

  @override
  String detailReviewsCount(Object count) {
    return '$count 条评价';
  }

  @override
  String get detailOverviewSubtitle => '行程简介';

  @override
  String get detailNoItinerary => '暂无行程说明。';

  @override
  String get detailNoReviews => '暂无评价。';

  @override
  String get detailExperienceMoments => '体验瞬间';

  @override
  String get detailEmotionalHighlight => '当日亮点';

  @override
  String get detailPhotographyHighlights => '摄影推荐';

  @override
  String get detailLocalCulture => '当地文化';

  @override
  String get detailMapPreview => '路线示意';

  @override
  String get detailViewOnMap => '在地图中查看';

  @override
  String get trustCancellationGuarantee => '免费取消';

  @override
  String get trustSecurePayment => '安全支付';

  @override
  String get trustVerifiedLocalPartner => '认证本地商家';

  @override
  String get trustRealTravelerReview => '真实游客评价';

  @override
  String trustBookingsLast7Days(Object count) {
    return '近7天有$count人预订';
  }

  @override
  String trustLimitedStock(Object count) {
    return '仅剩$count个名额';
  }

  @override
  String get trustLimitedStockTitle => '名额紧张';

  @override
  String bookingStepOf(Object current, Object total) {
    return '第$current步，共$total步';
  }

  @override
  String get bookingSelectDate => '选择日期';

  @override
  String get bookingTravelers => '出行人信息';

  @override
  String get bookingAddOns => '附加服务';

  @override
  String get bookingReview => '确认订单';

  @override
  String get bookingPayment => '支付';

  @override
  String get bookingConfirmation => '预订成功';

  @override
  String get bookingNext => '下一步';

  @override
  String get bookingDuration => '行程';

  @override
  String get bookingTravelersCount => '出行人数';

  @override
  String get bookingBasePrice => '基础价格';

  @override
  String get bookingEstimatedTotal => '预估总价';

  @override
  String get bookingLowestPrice => '最低';

  @override
  String get bookingUnavailable => '—';

  @override
  String get bookingContactInfo => '联系信息';

  @override
  String get bookingTravelerList => '出行人列表';

  @override
  String get bookingPassportInfo => '护照（如需要）';

  @override
  String get bookingSpecialRequests => '特殊说明';

  @override
  String get bookingAddTraveler => '添加出行人';

  @override
  String get bookingProceedToPayment => '去支付';

  @override
  String get bookingPayNow => '立即支付';

  @override
  String get bookingSecurePayment => '安全支付';

  @override
  String get bookingOrderSummary => '订单摘要';

  @override
  String get bookingSuccessTitle => '预订成功';

  @override
  String get bookingViewOrder => '查看订单';

  @override
  String get bookingBackToHome => '返回首页';

  @override
  String get bookingShareTrip => '分享行程';

  @override
  String bookingOrderNumber(Object orderId) {
    return '订单号：$orderId';
  }

  @override
  String get bookingCreditCard => '信用卡';

  @override
  String get bookingTripInfo => '行程信息';

  @override
  String get membershipCenterTitle => '会员中心';

  @override
  String get membershipTierBasic => '基础';

  @override
  String get membershipTierSilver => '银卡';

  @override
  String get membershipTierGold => '金卡';

  @override
  String get membershipTierVip => 'VIP';

  @override
  String get membershipTierNormal => '普通会员';

  @override
  String get membershipTierDiamond => '钻石会员';

  @override
  String get membershipFreeBreakfast => '免费早餐';

  @override
  String get membershipLateCheckout => '延迟退房';

  @override
  String get membershipExclusiveCoupons => '专属优惠券';

  @override
  String get vipBadgeLabel => 'VIP';

  @override
  String get vipDiscountLabel => 'VIP折扣';

  @override
  String get membershipPointsBalance => '积分余额';

  @override
  String get membershipProgressToNext => '升级进度';

  @override
  String get membershipBenefits => '权益';

  @override
  String get membershipDiscount => '折扣';

  @override
  String get membershipEarlyBooking => '提前预订';

  @override
  String get membershipExclusivePackages => '专属套餐';

  @override
  String get membershipPrioritySupport => '优先客服';

  @override
  String get membershipExclusivePackagesSection => '专属套餐';

  @override
  String get membershipUsePoints => '使用积分';

  @override
  String membershipPointsOff(Object amount, Object points) {
    return '$points 积分抵 ¥$amount';
  }

  @override
  String get membershipPointsRedeemHint => '积分可抵现（100积分=¥10）';
}
