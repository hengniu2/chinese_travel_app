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
