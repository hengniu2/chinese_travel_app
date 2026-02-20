import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'享梦游'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get tabHome;

  /// No description provided for @tabJoinUs.
  ///
  /// In zh, this message translates to:
  /// **'加入我们'**
  String get tabJoinUs;

  /// No description provided for @tabPlanner.
  ///
  /// In zh, this message translates to:
  /// **'旅行规划师'**
  String get tabPlanner;

  /// No description provided for @tabMessages.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get tabMessages;

  /// No description provided for @tabProfile.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get tabProfile;

  /// No description provided for @homeToursCardTitle.
  ///
  /// In zh, this message translates to:
  /// **'精选旅行线路'**
  String get homeToursCardTitle;

  /// No description provided for @homeToursCardSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'按城市·价格·天数·出发时间·类型筛选'**
  String get homeToursCardSubtitle;

  /// No description provided for @homeHotelsCardTitle.
  ///
  /// In zh, this message translates to:
  /// **'酒店'**
  String get homeHotelsCardTitle;

  /// No description provided for @homeHotelsCardSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'日期·价格·星级·排序'**
  String get homeHotelsCardSubtitle;

  /// No description provided for @homeOrdersCardTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的订单'**
  String get homeOrdersCardTitle;

  /// No description provided for @homeOrdersCardSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'全部·待付款·待出行·已完成·退款'**
  String get homeOrdersCardSubtitle;

  /// No description provided for @toursTitle.
  ///
  /// In zh, this message translates to:
  /// **'精选旅行线路'**
  String get toursTitle;

  /// No description provided for @tourBookNow.
  ///
  /// In zh, this message translates to:
  /// **'立即预订'**
  String get tourBookNow;

  /// No description provided for @tourOrderTitle.
  ///
  /// In zh, this message translates to:
  /// **'填写订单'**
  String get tourOrderTitle;

  /// No description provided for @tourSubmitPay.
  ///
  /// In zh, this message translates to:
  /// **'提交并去支付'**
  String get tourSubmitPay;

  /// No description provided for @tourAddTraveler.
  ///
  /// In zh, this message translates to:
  /// **'添加出行人'**
  String get tourAddTraveler;

  /// No description provided for @hotelsTitle.
  ///
  /// In zh, this message translates to:
  /// **'酒店'**
  String get hotelsTitle;

  /// No description provided for @hotelBook.
  ///
  /// In zh, this message translates to:
  /// **'预订'**
  String get hotelBook;

  /// No description provided for @hotelOrderTitle.
  ///
  /// In zh, this message translates to:
  /// **'填写订单'**
  String get hotelOrderTitle;

  /// No description provided for @hotelAddGuest.
  ///
  /// In zh, this message translates to:
  /// **'添加入住人'**
  String get hotelAddGuest;

  /// No description provided for @hotelPricePerNight.
  ///
  /// In zh, this message translates to:
  /// **'/晚'**
  String get hotelPricePerNight;

  /// No description provided for @ordersTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的订单'**
  String get ordersTitle;

  /// No description provided for @orderDetailTitle.
  ///
  /// In zh, this message translates to:
  /// **'订单详情'**
  String get orderDetailTitle;

  /// No description provided for @orderInfo.
  ///
  /// In zh, this message translates to:
  /// **'订单信息'**
  String get orderInfo;

  /// No description provided for @orderAmount.
  ///
  /// In zh, this message translates to:
  /// **'订单金额'**
  String get orderAmount;

  /// No description provided for @orderTravelers.
  ///
  /// In zh, this message translates to:
  /// **'出行人信息'**
  String get orderTravelers;

  /// No description provided for @orderPaymentStatus.
  ///
  /// In zh, this message translates to:
  /// **'支付状态'**
  String get orderPaymentStatus;

  /// No description provided for @orderPaid.
  ///
  /// In zh, this message translates to:
  /// **'已支付'**
  String get orderPaid;

  /// No description provided for @orderUnpaid.
  ///
  /// In zh, this message translates to:
  /// **'待支付'**
  String get orderUnpaid;

  /// No description provided for @orderRefund.
  ///
  /// In zh, this message translates to:
  /// **'申请退款'**
  String get orderRefund;

  /// No description provided for @orderContactService.
  ///
  /// In zh, this message translates to:
  /// **'联系客服'**
  String get orderContactService;

  /// No description provided for @orderContactServiceHint.
  ///
  /// In zh, this message translates to:
  /// **'订单问题可咨询在线客服'**
  String get orderContactServiceHint;

  /// No description provided for @orderRefundSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'已提交退款申请'**
  String get orderRefundSubmitted;

  /// No description provided for @orderContactOpening.
  ///
  /// In zh, this message translates to:
  /// **'即将打开客服'**
  String get orderContactOpening;

  /// No description provided for @orderGoToPay.
  ///
  /// In zh, this message translates to:
  /// **'去支付'**
  String get orderGoToPay;

  /// No description provided for @orderNoOrders.
  ///
  /// In zh, this message translates to:
  /// **'暂无订单'**
  String get orderNoOrders;

  /// No description provided for @orderReturnToOrders.
  ///
  /// In zh, this message translates to:
  /// **'返回订单页'**
  String get orderReturnToOrders;

  /// No description provided for @ordersTabAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get ordersTabAll;

  /// No description provided for @ordersTabUnpaid.
  ///
  /// In zh, this message translates to:
  /// **'待付款'**
  String get ordersTabUnpaid;

  /// No description provided for @ordersTabUpcoming.
  ///
  /// In zh, this message translates to:
  /// **'待出行'**
  String get ordersTabUpcoming;

  /// No description provided for @ordersTabDone.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get ordersTabDone;

  /// No description provided for @ordersTabRefund.
  ///
  /// In zh, this message translates to:
  /// **'退款'**
  String get ordersTabRefund;

  /// No description provided for @orderNo.
  ///
  /// In zh, this message translates to:
  /// **'订单编号'**
  String get orderNo;

  /// No description provided for @orderType.
  ///
  /// In zh, this message translates to:
  /// **'订单类型'**
  String get orderType;

  /// No description provided for @orderProduct.
  ///
  /// In zh, this message translates to:
  /// **'商品'**
  String get orderProduct;

  /// No description provided for @orderSpec.
  ///
  /// In zh, this message translates to:
  /// **'规格'**
  String get orderSpec;

  /// No description provided for @orderTravelDate.
  ///
  /// In zh, this message translates to:
  /// **'出发日期'**
  String get orderTravelDate;

  /// No description provided for @orderCheckIn.
  ///
  /// In zh, this message translates to:
  /// **'入住'**
  String get orderCheckIn;

  /// No description provided for @orderCreateTime.
  ///
  /// In zh, this message translates to:
  /// **'下单时间'**
  String get orderCreateTime;

  /// No description provided for @orderTypeTour.
  ///
  /// In zh, this message translates to:
  /// **'旅行团'**
  String get orderTypeTour;

  /// No description provided for @orderTypeHotel.
  ///
  /// In zh, this message translates to:
  /// **'酒店'**
  String get orderTypeHotel;

  /// No description provided for @orderViewDetail.
  ///
  /// In zh, this message translates to:
  /// **'查看详情'**
  String get orderViewDetail;

  /// No description provided for @orderBookAgain.
  ///
  /// In zh, this message translates to:
  /// **'再次预订'**
  String get orderBookAgain;

  /// No description provided for @orderViewRefund.
  ///
  /// In zh, this message translates to:
  /// **'查看退款'**
  String get orderViewRefund;

  /// No description provided for @orderTravelDateLabel.
  ///
  /// In zh, this message translates to:
  /// **'出发日期'**
  String get orderTravelDateLabel;

  /// No description provided for @orderCheckOut.
  ///
  /// In zh, this message translates to:
  /// **'退房'**
  String get orderCheckOut;

  /// No description provided for @paymentTitle.
  ///
  /// In zh, this message translates to:
  /// **'收银台'**
  String get paymentTitle;

  /// No description provided for @paymentAmountDue.
  ///
  /// In zh, this message translates to:
  /// **'应付金额 '**
  String get paymentAmountDue;

  /// No description provided for @paymentOrderNo.
  ///
  /// In zh, this message translates to:
  /// **'订单号 {orderId}'**
  String paymentOrderNo(String orderId);

  /// No description provided for @paymentSelectMethod.
  ///
  /// In zh, this message translates to:
  /// **'选择支付方式'**
  String get paymentSelectMethod;

  /// No description provided for @paymentAlipay.
  ///
  /// In zh, this message translates to:
  /// **'支付宝'**
  String get paymentAlipay;

  /// No description provided for @paymentAlipayHint.
  ///
  /// In zh, this message translates to:
  /// **'使用支付宝完成支付'**
  String get paymentAlipayHint;

  /// No description provided for @paymentWechat.
  ///
  /// In zh, this message translates to:
  /// **'微信支付'**
  String get paymentWechat;

  /// No description provided for @paymentWechatHint.
  ///
  /// In zh, this message translates to:
  /// **'使用微信完成支付'**
  String get paymentWechatHint;

  /// No description provided for @paymentConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认支付'**
  String get paymentConfirm;

  /// No description provided for @paymentPaying.
  ///
  /// In zh, this message translates to:
  /// **'支付中...'**
  String get paymentPaying;

  /// No description provided for @paymentDoNotClose.
  ///
  /// In zh, this message translates to:
  /// **'请勿关闭页面'**
  String get paymentDoNotClose;

  /// No description provided for @paymentSuccess.
  ///
  /// In zh, this message translates to:
  /// **'支付成功'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In zh, this message translates to:
  /// **'支付失败'**
  String get paymentFailed;

  /// No description provided for @paymentRetry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get paymentRetry;

  /// No description provided for @paymentSelectMethodFirst.
  ///
  /// In zh, this message translates to:
  /// **'请选择支付方式'**
  String get paymentSelectMethodFirst;

  /// No description provided for @paymentFailedHint.
  ///
  /// In zh, this message translates to:
  /// **'请重试或更换支付方式'**
  String get paymentFailedHint;

  /// No description provided for @chatTitle.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get chatTitle;

  /// No description provided for @chatNoMessages.
  ///
  /// In zh, this message translates to:
  /// **'暂无消息'**
  String get chatNoMessages;

  /// No description provided for @chatSaySomething.
  ///
  /// In zh, this message translates to:
  /// **'说点什么...'**
  String get chatSaySomething;

  /// No description provided for @chatSend.
  ///
  /// In zh, this message translates to:
  /// **'发表'**
  String get chatSend;

  /// No description provided for @forumTitle.
  ///
  /// In zh, this message translates to:
  /// **'旅游社区'**
  String get forumTitle;

  /// No description provided for @forumNoContent.
  ///
  /// In zh, this message translates to:
  /// **'暂无内容'**
  String get forumNoContent;

  /// No description provided for @articleTitle.
  ///
  /// In zh, this message translates to:
  /// **'文章'**
  String get articleTitle;

  /// No description provided for @articleComments.
  ///
  /// In zh, this message translates to:
  /// **'评论区 ({count})'**
  String articleComments(int count);

  /// No description provided for @articleNoComments.
  ///
  /// In zh, this message translates to:
  /// **'暂无评论，快来抢沙发'**
  String get articleNoComments;

  /// No description provided for @articleExpandFull.
  ///
  /// In zh, this message translates to:
  /// **'展开全文'**
  String get articleExpandFull;

  /// No description provided for @articleCollapse.
  ///
  /// In zh, this message translates to:
  /// **'收起'**
  String get articleCollapse;

  /// No description provided for @articlePostComment.
  ///
  /// In zh, this message translates to:
  /// **'发表'**
  String get articlePostComment;

  /// No description provided for @profileTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get profileTitle;

  /// No description provided for @profileLogin.
  ///
  /// In zh, this message translates to:
  /// **'点击登录'**
  String get profileLogin;

  /// No description provided for @profileLoggedIn.
  ///
  /// In zh, this message translates to:
  /// **'已登录'**
  String get profileLoggedIn;

  /// No description provided for @profileLogout.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get profileLogout;

  /// No description provided for @profileVerified.
  ///
  /// In zh, this message translates to:
  /// **'已实名认证'**
  String get profileVerified;

  /// No description provided for @profileNotVerified.
  ///
  /// In zh, this message translates to:
  /// **'未实名认证'**
  String get profileNotVerified;

  /// No description provided for @profileMyOrders.
  ///
  /// In zh, this message translates to:
  /// **'我的订单'**
  String get profileMyOrders;

  /// No description provided for @profileFavorites.
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get profileFavorites;

  /// No description provided for @profileWallet.
  ///
  /// In zh, this message translates to:
  /// **'钱包'**
  String get profileWallet;

  /// No description provided for @profileCoupons.
  ///
  /// In zh, this message translates to:
  /// **'优惠券'**
  String get profileCoupons;

  /// No description provided for @profileMessages.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get profileMessages;

  /// No description provided for @profileSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get profileSettings;

  /// No description provided for @profileFeatureComing.
  ///
  /// In zh, this message translates to:
  /// **'{name} 功能开发中'**
  String profileFeatureComing(String name);

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get settingsLanguage;

  /// No description provided for @languageZh.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get languageZh;

  /// No description provided for @languageEn.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @realNameVerifyTitle.
  ///
  /// In zh, this message translates to:
  /// **'实名认证'**
  String get realNameVerifyTitle;

  /// No description provided for @realNameVerifyHint.
  ///
  /// In zh, this message translates to:
  /// **'请填写您的真实姓名与身份证号，用于实名认证'**
  String get realNameVerifyHint;

  /// No description provided for @realNameVerifyName.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get realNameVerifyName;

  /// No description provided for @realNameVerifyNameHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入真实姓名'**
  String get realNameVerifyNameHint;

  /// No description provided for @realNameVerifyIdCard.
  ///
  /// In zh, this message translates to:
  /// **'身份证'**
  String get realNameVerifyIdCard;

  /// No description provided for @realNameVerifyIdCardHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入身份证号'**
  String get realNameVerifyIdCardHint;

  /// No description provided for @realNameVerifySubmit.
  ///
  /// In zh, this message translates to:
  /// **'提交认证'**
  String get realNameVerifySubmit;

  /// No description provided for @realNameVerifySuccess.
  ///
  /// In zh, this message translates to:
  /// **'实名认证提交成功'**
  String get realNameVerifySuccess;

  /// No description provided for @realNameVerifyNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请填写姓名'**
  String get realNameVerifyNameRequired;

  /// No description provided for @realNameVerifyIdCardInvalid.
  ///
  /// In zh, this message translates to:
  /// **'请填写正确的身份证号'**
  String get realNameVerifyIdCardInvalid;

  /// No description provided for @commonConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get commonSave;

  /// No description provided for @commonSearch.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get commonSearch;

  /// No description provided for @commonLoading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get commonLoading;

  /// No description provided for @tourOrderProductPerPerson.
  ///
  /// In zh, this message translates to:
  /// **'/人起'**
  String get tourOrderProductPerPerson;

  /// No description provided for @hotelOrderProductPerNight.
  ///
  /// In zh, this message translates to:
  /// **'/晚'**
  String get hotelOrderProductPerNight;

  /// No description provided for @orderCardOrder.
  ///
  /// In zh, this message translates to:
  /// **'订单'**
  String get orderCardOrder;

  /// No description provided for @filterPriceRange.
  ///
  /// In zh, this message translates to:
  /// **'价格区间'**
  String get filterPriceRange;

  /// No description provided for @filterStar.
  ///
  /// In zh, this message translates to:
  /// **'星级筛选'**
  String get filterStar;

  /// No description provided for @filterSort.
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get filterSort;

  /// No description provided for @filterAll.
  ///
  /// In zh, this message translates to:
  /// **'不限'**
  String get filterAll;

  /// No description provided for @checkInOut.
  ///
  /// In zh, this message translates to:
  /// **'入住/退房'**
  String get checkInOut;

  /// No description provided for @hotelEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无符合条件的酒店'**
  String get hotelEmpty;

  /// No description provided for @tourEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无符合条件的线路'**
  String get tourEmpty;

  /// No description provided for @filterClear.
  ///
  /// In zh, this message translates to:
  /// **'清除筛选'**
  String get filterClear;

  /// No description provided for @authWelcomeBack.
  ///
  /// In zh, this message translates to:
  /// **'欢迎回来'**
  String get authWelcomeBack;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'登录享梦游，发现更多旅行'**
  String get authLoginSubtitle;

  /// No description provided for @authPhone.
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get authPhone;

  /// No description provided for @authPassword.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get authPassword;

  /// No description provided for @authLogin.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get authLogin;

  /// No description provided for @authVerifyCodeLogin.
  ///
  /// In zh, this message translates to:
  /// **'验证码登录'**
  String get authVerifyCodeLogin;

  /// No description provided for @authVerifyCodeLoginSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'未注册手机号验证后将自动创建账号'**
  String get authVerifyCodeLoginSubtitle;

  /// No description provided for @authForgotPassword.
  ///
  /// In zh, this message translates to:
  /// **'忘记密码？'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In zh, this message translates to:
  /// **'还没有账号？'**
  String get authNoAccount;

  /// No description provided for @authRegisterNow.
  ///
  /// In zh, this message translates to:
  /// **'立即注册'**
  String get authRegisterNow;

  /// No description provided for @authCreateAccount.
  ///
  /// In zh, this message translates to:
  /// **'创建账号'**
  String get authCreateAccount;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'注册享梦游，开启绿色旅行'**
  String get authRegisterSubtitle;

  /// No description provided for @authVerifyCode.
  ///
  /// In zh, this message translates to:
  /// **'验证码'**
  String get authVerifyCode;

  /// No description provided for @authSetPassword.
  ///
  /// In zh, this message translates to:
  /// **'设置密码'**
  String get authSetPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In zh, this message translates to:
  /// **'确认密码'**
  String get authConfirmPassword;

  /// No description provided for @authRegister.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get authRegister;

  /// No description provided for @authHasAccount.
  ///
  /// In zh, this message translates to:
  /// **'已有账号？'**
  String get authHasAccount;

  /// No description provided for @authGoToLogin.
  ///
  /// In zh, this message translates to:
  /// **'去登录'**
  String get authGoToLogin;

  /// No description provided for @authResetPassword.
  ///
  /// In zh, this message translates to:
  /// **'重置密码'**
  String get authResetPassword;

  /// No description provided for @authResetPasswordSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'通过手机验证码重置登录密码'**
  String get authResetPasswordSubtitle;

  /// No description provided for @authNewPassword.
  ///
  /// In zh, this message translates to:
  /// **'新密码'**
  String get authNewPassword;

  /// No description provided for @authConfirmNewPassword.
  ///
  /// In zh, this message translates to:
  /// **'确认新密码'**
  String get authConfirmNewPassword;

  /// No description provided for @authConfirmReset.
  ///
  /// In zh, this message translates to:
  /// **'确认重置'**
  String get authConfirmReset;

  /// No description provided for @authUsePasswordLogin.
  ///
  /// In zh, this message translates to:
  /// **'使用密码登录'**
  String get authUsePasswordLogin;

  /// No description provided for @authVerifyCodeSent.
  ///
  /// In zh, this message translates to:
  /// **'验证码已发送'**
  String get authVerifyCodeSent;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In zh, this message translates to:
  /// **'密码已重置，请登录'**
  String get authPasswordResetSuccess;

  /// No description provided for @authAgreementRequired.
  ///
  /// In zh, this message translates to:
  /// **'请先阅读并同意用户协议和隐私政策'**
  String get authAgreementRequired;

  /// No description provided for @authForgotPasswordPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'忘记密码'**
  String get authForgotPasswordPageTitle;

  /// No description provided for @sectionGuests.
  ///
  /// In zh, this message translates to:
  /// **'入住人信息'**
  String get sectionGuests;

  /// No description provided for @sectionTravelers.
  ///
  /// In zh, this message translates to:
  /// **'出行人信息'**
  String get sectionTravelers;

  /// No description provided for @sectionAgreement.
  ///
  /// In zh, this message translates to:
  /// **'同意协议'**
  String get sectionAgreement;

  /// No description provided for @orderGuestHint.
  ///
  /// In zh, this message translates to:
  /// **'请填写每位入住人的姓名、身份证、手机号，确保与证件一致'**
  String get orderGuestHint;

  /// No description provided for @orderTravelerHint.
  ///
  /// In zh, this message translates to:
  /// **'请填写每位出行人的姓名、身份证、手机号，确保与证件一致'**
  String get orderTravelerHint;

  /// No description provided for @orderGuestNameError.
  ///
  /// In zh, this message translates to:
  /// **'请填写第{n}位入住人姓名'**
  String orderGuestNameError(int n);

  /// No description provided for @orderTravelerNameError.
  ///
  /// In zh, this message translates to:
  /// **'请填写第{n}位出行人姓名'**
  String orderTravelerNameError(int n);

  /// No description provided for @orderGuestIdError.
  ///
  /// In zh, this message translates to:
  /// **'请填写第{n}位入住人身份证号'**
  String orderGuestIdError(int n);

  /// No description provided for @orderTravelerIdError.
  ///
  /// In zh, this message translates to:
  /// **'请填写第{n}位出行人身份证号'**
  String orderTravelerIdError(int n);

  /// No description provided for @orderGuestPhoneError.
  ///
  /// In zh, this message translates to:
  /// **'请填写第{n}位入住人手机号'**
  String orderGuestPhoneError(int n);

  /// No description provided for @orderTravelerPhoneError.
  ///
  /// In zh, this message translates to:
  /// **'请填写第{n}位出行人手机号'**
  String orderTravelerPhoneError(int n);

  /// No description provided for @orderAgreementRequired.
  ///
  /// In zh, this message translates to:
  /// **'请阅读并同意用户协议与隐私政策'**
  String get orderAgreementRequired;

  /// No description provided for @hotelNoRooms.
  ///
  /// In zh, this message translates to:
  /// **'暂无可订房型'**
  String get hotelNoRooms;

  /// No description provided for @guestLabel.
  ///
  /// In zh, this message translates to:
  /// **'入住人'**
  String get guestLabel;

  /// No description provided for @commonRetry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonRetry;

  /// No description provided for @filterSelectCity.
  ///
  /// In zh, this message translates to:
  /// **'选择城市'**
  String get filterSelectCity;

  /// No description provided for @filterSelectPrice.
  ///
  /// In zh, this message translates to:
  /// **'选择价格'**
  String get filterSelectPrice;

  /// No description provided for @filterSelectDays.
  ///
  /// In zh, this message translates to:
  /// **'选择天数'**
  String get filterSelectDays;

  /// No description provided for @filterSelectType.
  ///
  /// In zh, this message translates to:
  /// **'选择类型'**
  String get filterSelectType;

  /// No description provided for @tourDaysNights.
  ///
  /// In zh, this message translates to:
  /// **'{days}天{nights}晚'**
  String tourDaysNights(int days, int nights);

  /// No description provided for @tourDepartFrom.
  ///
  /// In zh, this message translates to:
  /// **'{city}出发'**
  String tourDepartFrom(String city);

  /// No description provided for @priceFrom.
  ///
  /// In zh, this message translates to:
  /// **'起'**
  String get priceFrom;

  /// No description provided for @tourDayTitle.
  ///
  /// In zh, this message translates to:
  /// **'第{day}天 {title}'**
  String tourDayTitle(int day, String title);

  /// No description provided for @sectionItinerary.
  ///
  /// In zh, this message translates to:
  /// **'行程时间轴'**
  String get sectionItinerary;

  /// No description provided for @sectionHighlights.
  ///
  /// In zh, this message translates to:
  /// **'行程亮点'**
  String get sectionHighlights;

  /// No description provided for @sectionCost.
  ///
  /// In zh, this message translates to:
  /// **'费用说明'**
  String get sectionCost;

  /// No description provided for @sectionCostIncluded.
  ///
  /// In zh, this message translates to:
  /// **'费用包含'**
  String get sectionCostIncluded;

  /// No description provided for @sectionCostExcluded.
  ///
  /// In zh, this message translates to:
  /// **'费用不含'**
  String get sectionCostExcluded;

  /// No description provided for @sectionHotelInfo.
  ///
  /// In zh, this message translates to:
  /// **'酒店信息'**
  String get sectionHotelInfo;

  /// No description provided for @sectionPolicy.
  ///
  /// In zh, this message translates to:
  /// **'退改政策'**
  String get sectionPolicy;

  /// No description provided for @sectionReviews.
  ///
  /// In zh, this message translates to:
  /// **'用户评价'**
  String get sectionReviews;

  /// No description provided for @hotelSectionRooms.
  ///
  /// In zh, this message translates to:
  /// **'房型列表'**
  String get hotelSectionRooms;

  /// No description provided for @hotelSectionPolicy.
  ///
  /// In zh, this message translates to:
  /// **'取消政策'**
  String get hotelSectionPolicy;

  /// No description provided for @hotelSectionFacilities.
  ///
  /// In zh, this message translates to:
  /// **'设施'**
  String get hotelSectionFacilities;

  /// No description provided for @hotelSectionReviews.
  ///
  /// In zh, this message translates to:
  /// **'评价'**
  String get hotelSectionReviews;

  /// No description provided for @hotelScoreSuffix.
  ///
  /// In zh, this message translates to:
  /// **'分'**
  String get hotelScoreSuffix;

  /// No description provided for @roomAvailable.
  ///
  /// In zh, this message translates to:
  /// **'可订'**
  String get roomAvailable;

  /// No description provided for @roomRemaining.
  ///
  /// In zh, this message translates to:
  /// **'仅剩{count}间'**
  String roomRemaining(int count);

  /// No description provided for @roomLimited.
  ///
  /// In zh, this message translates to:
  /// **'紧张'**
  String get roomLimited;

  /// No description provided for @roomSoldOut.
  ///
  /// In zh, this message translates to:
  /// **'售罄'**
  String get roomSoldOut;

  /// No description provided for @chatInputHint.
  ///
  /// In zh, this message translates to:
  /// **'输入消息'**
  String get chatInputHint;

  /// No description provided for @chatOrderCard.
  ///
  /// In zh, this message translates to:
  /// **'订单 {id}'**
  String chatOrderCard(String id);

  /// No description provided for @travelerFormName.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get travelerFormName;

  /// No description provided for @travelerFormIdCard.
  ///
  /// In zh, this message translates to:
  /// **'身份证'**
  String get travelerFormIdCard;

  /// No description provided for @travelerFormPhone.
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get travelerFormPhone;

  /// No description provided for @companionOrderTitle.
  ///
  /// In zh, this message translates to:
  /// **'填写订单'**
  String get companionOrderTitle;

  /// No description provided for @companionSubmitOrder.
  ///
  /// In zh, this message translates to:
  /// **'提交订单'**
  String get companionSubmitOrder;

  /// No description provided for @companionOrderSuccess.
  ///
  /// In zh, this message translates to:
  /// **'订单提交成功'**
  String get companionOrderSuccess;

  /// No description provided for @companionAddTraveler.
  ///
  /// In zh, this message translates to:
  /// **'添加随行人员'**
  String get companionAddTraveler;

  /// No description provided for @companionRemarksHint.
  ///
  /// In zh, this message translates to:
  /// **'选填，如特殊需求、集合地点等'**
  String get companionRemarksHint;

  /// No description provided for @companionSectionSkills.
  ///
  /// In zh, this message translates to:
  /// **'技能标签'**
  String get companionSectionSkills;

  /// No description provided for @companionSectionDescription.
  ///
  /// In zh, this message translates to:
  /// **'服务说明'**
  String get companionSectionDescription;

  /// No description provided for @companionSectionPackages.
  ///
  /// In zh, this message translates to:
  /// **'套餐'**
  String get companionSectionPackages;

  /// No description provided for @companionSectionCalendar.
  ///
  /// In zh, this message translates to:
  /// **'档期日历'**
  String get companionSectionCalendar;

  /// No description provided for @companionViewAll.
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get companionViewAll;

  /// No description provided for @companionSectionReviews.
  ///
  /// In zh, this message translates to:
  /// **'评价'**
  String get companionSectionReviews;

  /// No description provided for @plannerTabTours.
  ///
  /// In zh, this message translates to:
  /// **'行程/跟团游'**
  String get plannerTabTours;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
