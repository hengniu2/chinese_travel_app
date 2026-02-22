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

  /// No description provided for @hotelListTitle.
  ///
  /// In zh, this message translates to:
  /// **'酒店列表'**
  String get hotelListTitle;

  /// No description provided for @hotelSearchPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'酒店 / 关键词 / 品牌'**
  String get hotelSearchPlaceholder;

  /// No description provided for @hotelViewDetail.
  ///
  /// In zh, this message translates to:
  /// **'查看详情'**
  String get hotelViewDetail;

  /// No description provided for @hotelViewRoomTypes.
  ///
  /// In zh, this message translates to:
  /// **'查看房型'**
  String get hotelViewRoomTypes;

  /// No description provided for @hotelNoRooms.
  ///
  /// In zh, this message translates to:
  /// **'暂无可订房型'**
  String get hotelNoRooms;

  /// No description provided for @hotelBookingConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认订单'**
  String get hotelBookingConfirmTitle;

  /// No description provided for @hotelPriceBreakdown.
  ///
  /// In zh, this message translates to:
  /// **'费用明细'**
  String get hotelPriceBreakdown;

  /// No description provided for @hotelRoomPrice.
  ///
  /// In zh, this message translates to:
  /// **'房费'**
  String get hotelRoomPrice;

  /// No description provided for @hotelServiceFee.
  ///
  /// In zh, this message translates to:
  /// **'服务费'**
  String get hotelServiceFee;

  /// No description provided for @hotelContinueToGuest.
  ///
  /// In zh, this message translates to:
  /// **'下一步：填写入住人'**
  String get hotelContinueToGuest;

  /// No description provided for @hotelBookingGuestTitle.
  ///
  /// In zh, this message translates to:
  /// **'入住人信息'**
  String get hotelBookingGuestTitle;

  /// No description provided for @hotelGuestName.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get hotelGuestName;

  /// No description provided for @hotelGuestPhone.
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get hotelGuestPhone;

  /// No description provided for @hotelGuestIdNumber.
  ///
  /// In zh, this message translates to:
  /// **'身份证号'**
  String get hotelGuestIdNumber;

  /// No description provided for @hotelSpecialRequest.
  ///
  /// In zh, this message translates to:
  /// **'特殊要求'**
  String get hotelSpecialRequest;

  /// No description provided for @hotelSpecialRequestHint.
  ///
  /// In zh, this message translates to:
  /// **'如：提前入住、加枕头等'**
  String get hotelSpecialRequestHint;

  /// No description provided for @hotelProceedToPayment.
  ///
  /// In zh, this message translates to:
  /// **'去支付'**
  String get hotelProceedToPayment;

  /// No description provided for @hotelBookingPaymentTitle.
  ///
  /// In zh, this message translates to:
  /// **'支付'**
  String get hotelBookingPaymentTitle;

  /// No description provided for @hotelBookingSuccessTitle.
  ///
  /// In zh, this message translates to:
  /// **'预订成功！'**
  String get hotelBookingSuccessTitle;

  /// No description provided for @hotelBookingSuccessMessage.
  ///
  /// In zh, this message translates to:
  /// **'您的预订已确认。'**
  String get hotelBookingSuccessMessage;

  /// No description provided for @paymentCreditCard.
  ///
  /// In zh, this message translates to:
  /// **'信用卡'**
  String get paymentCreditCard;

  /// No description provided for @paymentCreditCardHint.
  ///
  /// In zh, this message translates to:
  /// **'使用信用卡或借记卡支付'**
  String get paymentCreditCardHint;

  /// No description provided for @hotelCompareTitle.
  ///
  /// In zh, this message translates to:
  /// **'酒店对比'**
  String get hotelCompareTitle;

  /// No description provided for @hotelCompareEmpty.
  ///
  /// In zh, this message translates to:
  /// **'请先添加最多3家酒店进行对比'**
  String get hotelCompareEmpty;

  /// No description provided for @hotelCompareItem.
  ///
  /// In zh, this message translates to:
  /// **'项目'**
  String get hotelCompareItem;

  /// No description provided for @hotelComparePrice.
  ///
  /// In zh, this message translates to:
  /// **'价格'**
  String get hotelComparePrice;

  /// No description provided for @hotelCompareRating.
  ///
  /// In zh, this message translates to:
  /// **'评分'**
  String get hotelCompareRating;

  /// No description provided for @hotelCompareDistance.
  ///
  /// In zh, this message translates to:
  /// **'距离'**
  String get hotelCompareDistance;

  /// No description provided for @hotelCompareFacilities.
  ///
  /// In zh, this message translates to:
  /// **'设施'**
  String get hotelCompareFacilities;

  /// No description provided for @hotelCompareCancellation.
  ///
  /// In zh, this message translates to:
  /// **'取消政策'**
  String get hotelCompareCancellation;

  /// No description provided for @hotelMapSheetTitle.
  ///
  /// In zh, this message translates to:
  /// **'选择酒店'**
  String get hotelMapSheetTitle;

  /// No description provided for @hotelBundleSectionTitle.
  ///
  /// In zh, this message translates to:
  /// **'超值套餐推荐'**
  String get hotelBundleSectionTitle;

  /// No description provided for @hotelBundleSavings.
  ///
  /// In zh, this message translates to:
  /// **'已为您节省 ¥{amount}'**
  String hotelBundleSavings(Object amount);

  /// No description provided for @hotelBundleCta.
  ///
  /// In zh, this message translates to:
  /// **'立即打包预订'**
  String get hotelBundleCta;

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

  /// No description provided for @orderNoOrdersDescription.
  ///
  /// In zh, this message translates to:
  /// **'您的旅行订单将显示在这里'**
  String get orderNoOrdersDescription;

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

  /// No description provided for @chatSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索联系人、消息'**
  String get chatSearchHint;

  /// No description provided for @chatNoSearchResults.
  ///
  /// In zh, this message translates to:
  /// **'未找到相关对话'**
  String get chatNoSearchResults;

  /// No description provided for @chatCopy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get chatCopy;

  /// No description provided for @chatCopied.
  ///
  /// In zh, this message translates to:
  /// **'已复制'**
  String get chatCopied;

  /// No description provided for @chatQuickReplyOk.
  ///
  /// In zh, this message translates to:
  /// **'好的'**
  String get chatQuickReplyOk;

  /// No description provided for @chatQuickReplyThanks.
  ///
  /// In zh, this message translates to:
  /// **'谢谢'**
  String get chatQuickReplyThanks;

  /// No description provided for @chatQuickReplyLater.
  ///
  /// In zh, this message translates to:
  /// **'稍后联系'**
  String get chatQuickReplyLater;

  /// No description provided for @chatSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'智能客服 · 随时为您服务'**
  String get chatSubtitle;

  /// No description provided for @chatGuessYouAsk.
  ///
  /// In zh, this message translates to:
  /// **'猜你想问'**
  String get chatGuessYouAsk;

  /// No description provided for @chatConsultTrip.
  ///
  /// In zh, this message translates to:
  /// **'行程咨询'**
  String get chatConsultTrip;

  /// No description provided for @chatOrderIssue.
  ///
  /// In zh, this message translates to:
  /// **'订单问题'**
  String get chatOrderIssue;

  /// No description provided for @chatRefundChange.
  ///
  /// In zh, this message translates to:
  /// **'退款改签'**
  String get chatRefundChange;

  /// No description provided for @chatTickets.
  ///
  /// In zh, this message translates to:
  /// **'景点门票'**
  String get chatTickets;

  /// No description provided for @chatHumanService.
  ///
  /// In zh, this message translates to:
  /// **'人工客服'**
  String get chatHumanService;

  /// No description provided for @chatYouCanAsk.
  ///
  /// In zh, this message translates to:
  /// **'您可以问我：行程、订单、退改、天气…'**
  String get chatYouCanAsk;

  /// No description provided for @chatStartConsult.
  ///
  /// In zh, this message translates to:
  /// **'开始咨询'**
  String get chatStartConsult;

  /// No description provided for @chatViewOrder.
  ///
  /// In zh, this message translates to:
  /// **'查看订单'**
  String get chatViewOrder;

  /// No description provided for @chatChangeTrip.
  ///
  /// In zh, this message translates to:
  /// **'修改行程'**
  String get chatChangeTrip;

  /// No description provided for @chatRefundPolicy.
  ///
  /// In zh, this message translates to:
  /// **'退改政策'**
  String get chatRefundPolicy;

  /// No description provided for @chatSendLocation.
  ///
  /// In zh, this message translates to:
  /// **'发送位置'**
  String get chatSendLocation;

  /// No description provided for @chatViewDetail.
  ///
  /// In zh, this message translates to:
  /// **'查看详情'**
  String get chatViewDetail;

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

  /// No description provided for @profileSectionServices.
  ///
  /// In zh, this message translates to:
  /// **'我的服务'**
  String get profileSectionServices;

  /// No description provided for @profileSectionMore.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get profileSectionMore;

  /// No description provided for @profileFeatureComing.
  ///
  /// In zh, this message translates to:
  /// **'{name} 功能开发中'**
  String profileFeatureComing(String name);

  /// No description provided for @profileGreetingMorning.
  ///
  /// In zh, this message translates to:
  /// **'早上好'**
  String get profileGreetingMorning;

  /// No description provided for @profileGreetingAfternoon.
  ///
  /// In zh, this message translates to:
  /// **'下午好'**
  String get profileGreetingAfternoon;

  /// No description provided for @profileGreetingEvening.
  ///
  /// In zh, this message translates to:
  /// **'晚上好'**
  String get profileGreetingEvening;

  /// No description provided for @profileGreetingReady.
  ///
  /// In zh, this message translates to:
  /// **'准备好新的旅行了吗？'**
  String get profileGreetingReady;

  /// No description provided for @profileLoginNow.
  ///
  /// In zh, this message translates to:
  /// **'立即登录'**
  String get profileLoginNow;

  /// No description provided for @profileLevelExplorer.
  ///
  /// In zh, this message translates to:
  /// **'Lv.1 探险家'**
  String get profileLevelExplorer;

  /// No description provided for @profileCouponExpiring.
  ///
  /// In zh, this message translates to:
  /// **'即将过期'**
  String get profileCouponExpiring;

  /// No description provided for @profileCouponTabAvailable.
  ///
  /// In zh, this message translates to:
  /// **'可使用'**
  String get profileCouponTabAvailable;

  /// No description provided for @profileCouponTabUsed.
  ///
  /// In zh, this message translates to:
  /// **'已使用'**
  String get profileCouponTabUsed;

  /// No description provided for @profileCouponTabExpired.
  ///
  /// In zh, this message translates to:
  /// **'已过期'**
  String get profileCouponTabExpired;

  /// No description provided for @profileCouponCondition.
  ///
  /// In zh, this message translates to:
  /// **'满{amount}可用'**
  String profileCouponCondition(String amount);

  /// No description provided for @profileCouponValidUntil.
  ///
  /// In zh, this message translates to:
  /// **'有效期至 {date}'**
  String profileCouponValidUntil(String date);

  /// No description provided for @profileCouponEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无优惠券'**
  String get profileCouponEmpty;

  /// No description provided for @profileCouponUse.
  ///
  /// In zh, this message translates to:
  /// **'去使用'**
  String get profileCouponUse;

  /// No description provided for @couponClaimNow.
  ///
  /// In zh, this message translates to:
  /// **'立即领取'**
  String get couponClaimNow;

  /// No description provided for @couponSelect.
  ///
  /// In zh, this message translates to:
  /// **'选择优惠券'**
  String get couponSelect;

  /// No description provided for @couponSavedAmount.
  ///
  /// In zh, this message translates to:
  /// **'已为您节省 ¥{amount}'**
  String couponSavedAmount(String amount);

  /// No description provided for @couponTypeThreshold.
  ///
  /// In zh, this message translates to:
  /// **'满减券'**
  String get couponTypeThreshold;

  /// No description provided for @couponTypeNoThreshold.
  ///
  /// In zh, this message translates to:
  /// **'无门槛券'**
  String get couponTypeNoThreshold;

  /// No description provided for @couponTypeDiscount.
  ///
  /// In zh, this message translates to:
  /// **'折扣券'**
  String get couponTypeDiscount;

  /// No description provided for @couponTypeFlash.
  ///
  /// In zh, this message translates to:
  /// **'限时闪促'**
  String get couponTypeFlash;

  /// No description provided for @couponNoThreshold.
  ///
  /// In zh, this message translates to:
  /// **'无门槛'**
  String get couponNoThreshold;

  /// No description provided for @couponValidUntil.
  ///
  /// In zh, this message translates to:
  /// **'有效期至 {date}'**
  String couponValidUntil(String date);

  /// No description provided for @couponFlashRemaining.
  ///
  /// In zh, this message translates to:
  /// **'剩余 {time}'**
  String couponFlashRemaining(String time);

  /// No description provided for @couponApplyConfirm.
  ///
  /// In zh, this message translates to:
  /// **'使用该优惠券可省 ¥{amount}，确认使用？'**
  String couponApplyConfirm(String amount);

  /// No description provided for @couponDiscount.
  ///
  /// In zh, this message translates to:
  /// **'优惠'**
  String get couponDiscount;

  /// No description provided for @couponFinalAmount.
  ///
  /// In zh, this message translates to:
  /// **'实付'**
  String get couponFinalAmount;

  /// No description provided for @profileFrequentTravelerEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无常用出行人'**
  String get profileFrequentTravelerEmpty;

  /// No description provided for @profileFrequentTravelerAdd.
  ///
  /// In zh, this message translates to:
  /// **'添加出行人'**
  String get profileFrequentTravelerAdd;

  /// No description provided for @profileAddressEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无收货地址'**
  String get profileAddressEmpty;

  /// No description provided for @profileAddressAdd.
  ///
  /// In zh, this message translates to:
  /// **'添加地址'**
  String get profileAddressAdd;

  /// No description provided for @profileFeedbackHint.
  ///
  /// In zh, this message translates to:
  /// **'请描述您的建议或问题'**
  String get profileFeedbackHint;

  /// No description provided for @profileFeedbackSubmit.
  ///
  /// In zh, this message translates to:
  /// **'提交反馈'**
  String get profileFeedbackSubmit;

  /// No description provided for @profileFeedbackSuccess.
  ///
  /// In zh, this message translates to:
  /// **'感谢您的反馈！'**
  String get profileFeedbackSuccess;

  /// No description provided for @profileClearCacheSize.
  ///
  /// In zh, this message translates to:
  /// **'缓存大小：{size}'**
  String profileClearCacheSize(String size);

  /// No description provided for @profileClearCacheDo.
  ///
  /// In zh, this message translates to:
  /// **'清除缓存'**
  String get profileClearCacheDo;

  /// No description provided for @profileClearCacheDone.
  ///
  /// In zh, this message translates to:
  /// **'已清除'**
  String get profileClearCacheDone;

  /// No description provided for @commonName.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get commonName;

  /// No description provided for @commonPhone.
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get commonPhone;

  /// No description provided for @commonIdNumber.
  ///
  /// In zh, this message translates to:
  /// **'证件号'**
  String get commonIdNumber;

  /// No description provided for @commonAddress.
  ///
  /// In zh, this message translates to:
  /// **'地址'**
  String get commonAddress;

  /// No description provided for @commonDefault.
  ///
  /// In zh, this message translates to:
  /// **'默认'**
  String get commonDefault;

  /// No description provided for @profileTravelPlannerSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'智能规划你的行程'**
  String get profileTravelPlannerSubtitle;

  /// No description provided for @profileSectionTravel.
  ///
  /// In zh, this message translates to:
  /// **'出行服务'**
  String get profileSectionTravel;

  /// No description provided for @profileSectionAssets.
  ///
  /// In zh, this message translates to:
  /// **'我的资产'**
  String get profileSectionAssets;

  /// No description provided for @profileSectionMoreSettings.
  ///
  /// In zh, this message translates to:
  /// **'更多与设置'**
  String get profileSectionMoreSettings;

  /// No description provided for @profileEditProfile.
  ///
  /// In zh, this message translates to:
  /// **'编辑资料'**
  String get profileEditProfile;

  /// No description provided for @profileMembershipTourist.
  ///
  /// In zh, this message translates to:
  /// **'游客'**
  String get profileMembershipTourist;

  /// No description provided for @profileMembershipMember.
  ///
  /// In zh, this message translates to:
  /// **'会员'**
  String get profileMembershipMember;

  /// No description provided for @profileMembershipGold.
  ///
  /// In zh, this message translates to:
  /// **'黄金会员'**
  String get profileMembershipGold;

  /// No description provided for @profileSectionTravelServices.
  ///
  /// In zh, this message translates to:
  /// **'出行服务'**
  String get profileSectionTravelServices;

  /// No description provided for @profileSectionMyAssets.
  ///
  /// In zh, this message translates to:
  /// **'我的资产'**
  String get profileSectionMyAssets;

  /// No description provided for @profileSectionSocialGrowth.
  ///
  /// In zh, this message translates to:
  /// **'社交与成长'**
  String get profileSectionSocialGrowth;

  /// No description provided for @profileSectionSmartTools.
  ///
  /// In zh, this message translates to:
  /// **'智能工具'**
  String get profileSectionSmartTools;

  /// No description provided for @profileSectionSettingsSupport.
  ///
  /// In zh, this message translates to:
  /// **'设置与帮助'**
  String get profileSectionSettingsSupport;

  /// No description provided for @profileTravelPlanner.
  ///
  /// In zh, this message translates to:
  /// **'旅行规划师'**
  String get profileTravelPlanner;

  /// No description provided for @profileTourPackages.
  ///
  /// In zh, this message translates to:
  /// **'跟团游'**
  String get profileTourPackages;

  /// No description provided for @profileHotels.
  ///
  /// In zh, this message translates to:
  /// **'酒店'**
  String get profileHotels;

  /// No description provided for @profileFlights.
  ///
  /// In zh, this message translates to:
  /// **'机票'**
  String get profileFlights;

  /// No description provided for @profileInsurance.
  ///
  /// In zh, this message translates to:
  /// **'保险'**
  String get profileInsurance;

  /// No description provided for @profilePoints.
  ///
  /// In zh, this message translates to:
  /// **'积分'**
  String get profilePoints;

  /// No description provided for @profileInvoice.
  ///
  /// In zh, this message translates to:
  /// **'开发票'**
  String get profileInvoice;

  /// No description provided for @profileRewards.
  ///
  /// In zh, this message translates to:
  /// **'我的奖品'**
  String get profileRewards;

  /// No description provided for @profileInviteFriends.
  ///
  /// In zh, this message translates to:
  /// **'邀请好友'**
  String get profileInviteFriends;

  /// No description provided for @profileBecomePlanner.
  ///
  /// In zh, this message translates to:
  /// **'成为规划师'**
  String get profileBecomePlanner;

  /// No description provided for @profileReferralCenter.
  ///
  /// In zh, this message translates to:
  /// **'引荐中心'**
  String get profileReferralCenter;

  /// No description provided for @profileItinerary.
  ///
  /// In zh, this message translates to:
  /// **'行程管理'**
  String get profileItinerary;

  /// No description provided for @profileExpenseStats.
  ///
  /// In zh, this message translates to:
  /// **'花费统计'**
  String get profileExpenseStats;

  /// No description provided for @profileDownloadedTickets.
  ///
  /// In zh, this message translates to:
  /// **'已下载票据'**
  String get profileDownloadedTickets;

  /// No description provided for @profileEmergencyContact.
  ///
  /// In zh, this message translates to:
  /// **'紧急联系人'**
  String get profileEmergencyContact;

  /// No description provided for @profileHelpCenter.
  ///
  /// In zh, this message translates to:
  /// **'帮助中心'**
  String get profileHelpCenter;

  /// No description provided for @profileFeedback.
  ///
  /// In zh, this message translates to:
  /// **'意见反馈'**
  String get profileFeedback;

  /// No description provided for @profileAboutUs.
  ///
  /// In zh, this message translates to:
  /// **'关于我们'**
  String get profileAboutUs;

  /// No description provided for @profileClearCache.
  ///
  /// In zh, this message translates to:
  /// **'清除缓存'**
  String get profileClearCache;

  /// No description provided for @profileMyFriends.
  ///
  /// In zh, this message translates to:
  /// **'我的朋友'**
  String get profileMyFriends;

  /// No description provided for @profileAllOrders.
  ///
  /// In zh, this message translates to:
  /// **'全部订单'**
  String get profileAllOrders;

  /// No description provided for @profileSectionMyTools.
  ///
  /// In zh, this message translates to:
  /// **'我的工具'**
  String get profileSectionMyTools;

  /// No description provided for @profileSectionCommonSettings.
  ///
  /// In zh, this message translates to:
  /// **'常用设置'**
  String get profileSectionCommonSettings;

  /// No description provided for @profileFrequentTravelers.
  ///
  /// In zh, this message translates to:
  /// **'常用出行人'**
  String get profileFrequentTravelers;

  /// No description provided for @profileShippingAddress.
  ///
  /// In zh, this message translates to:
  /// **'收货地址'**
  String get profileShippingAddress;

  /// No description provided for @profileIssueInvoice.
  ///
  /// In zh, this message translates to:
  /// **'开发票'**
  String get profileIssueInvoice;

  /// No description provided for @profileCourseOrders.
  ///
  /// In zh, this message translates to:
  /// **'课程订单'**
  String get profileCourseOrders;

  /// No description provided for @profileFlightOrders.
  ///
  /// In zh, this message translates to:
  /// **'机票订单'**
  String get profileFlightOrders;

  /// No description provided for @profileHotelOrders.
  ///
  /// In zh, this message translates to:
  /// **'酒店订单'**
  String get profileHotelOrders;

  /// No description provided for @profileMyPrizes.
  ///
  /// In zh, this message translates to:
  /// **'我的奖品'**
  String get profileMyPrizes;

  /// No description provided for @profileReferrer.
  ///
  /// In zh, this message translates to:
  /// **'引荐人'**
  String get profileReferrer;

  /// No description provided for @profileTravelCollection.
  ///
  /// In zh, this message translates to:
  /// **'出行收集'**
  String get profileTravelCollection;

  /// No description provided for @profileDataStats.
  ///
  /// In zh, this message translates to:
  /// **'数据统计'**
  String get profileDataStats;

  /// No description provided for @profileBadgeNew.
  ///
  /// In zh, this message translates to:
  /// **'新'**
  String get profileBadgeNew;

  /// No description provided for @profileUserLabel.
  ///
  /// In zh, this message translates to:
  /// **'用户{id}'**
  String profileUserLabel(String id);

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

  /// No description provided for @emptyStateNoHotels.
  ///
  /// In zh, this message translates to:
  /// **'暂时没有找到合适的酒店哦～'**
  String get emptyStateNoHotels;

  /// No description provided for @emptyStateNoRooms.
  ///
  /// In zh, this message translates to:
  /// **'暂无可用房型，换个日期试试吧～'**
  String get emptyStateNoRooms;

  /// No description provided for @emptyStateNoInternet.
  ///
  /// In zh, this message translates to:
  /// **'网络开小差了，再试试吧'**
  String get emptyStateNoInternet;

  /// No description provided for @emptyStateLoading.
  ///
  /// In zh, this message translates to:
  /// **'加载中…'**
  String get emptyStateLoading;

  /// No description provided for @emptyStateError.
  ///
  /// In zh, this message translates to:
  /// **'加载失败，再试试吧'**
  String get emptyStateError;

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

  /// No description provided for @companionDiscoveryTitle.
  ///
  /// In zh, this message translates to:
  /// **'找陪游'**
  String get companionDiscoveryTitle;

  /// No description provided for @companionSearchPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'城市、技能、关键词'**
  String get companionSearchPlaceholder;

  /// No description provided for @companionCityHint.
  ///
  /// In zh, this message translates to:
  /// **'选择城市'**
  String get companionCityHint;

  /// No description provided for @companionSortSmart.
  ///
  /// In zh, this message translates to:
  /// **'智能排序'**
  String get companionSortSmart;

  /// No description provided for @companionSortRating.
  ///
  /// In zh, this message translates to:
  /// **'评分优先'**
  String get companionSortRating;

  /// No description provided for @companionSortPriceAsc.
  ///
  /// In zh, this message translates to:
  /// **'价格从低到高'**
  String get companionSortPriceAsc;

  /// No description provided for @companionSortPriceDesc.
  ///
  /// In zh, this message translates to:
  /// **'价格从高到低'**
  String get companionSortPriceDesc;

  /// No description provided for @companionSectionFeatured.
  ///
  /// In zh, this message translates to:
  /// **'热门陪游'**
  String get companionSectionFeatured;

  /// No description provided for @companionSectionAll.
  ///
  /// In zh, this message translates to:
  /// **'全部陪游'**
  String get companionSectionAll;

  /// No description provided for @companionReviewsCount.
  ///
  /// In zh, this message translates to:
  /// **'{count}条评价'**
  String companionReviewsCount(Object count);

  /// No description provided for @companionPriceFrom.
  ///
  /// In zh, this message translates to:
  /// **'起'**
  String get companionPriceFrom;

  /// No description provided for @companionEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无符合条件的陪游'**
  String get companionEmpty;

  /// No description provided for @companionFilterAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get companionFilterAll;

  /// No description provided for @companionBookNow.
  ///
  /// In zh, this message translates to:
  /// **'立即预约'**
  String get companionBookNow;

  /// No description provided for @companionServiceCount.
  ///
  /// In zh, this message translates to:
  /// **'已服务 {count}次'**
  String companionServiceCount(Object count);

  /// No description provided for @companionExperienceYears.
  ///
  /// In zh, this message translates to:
  /// **'{years}年陪游经验'**
  String companionExperienceYears(Object years);

  /// No description provided for @companionResponseTime.
  ///
  /// In zh, this message translates to:
  /// **'平均回复 {time}'**
  String companionResponseTime(Object time);

  /// No description provided for @companionVerified.
  ///
  /// In zh, this message translates to:
  /// **'已认证'**
  String get companionVerified;

  /// No description provided for @companionPricePerDay.
  ///
  /// In zh, this message translates to:
  /// **'/ 天'**
  String get companionPricePerDay;

  /// No description provided for @plannerTabTours.
  ///
  /// In zh, this message translates to:
  /// **'行程/跟团游'**
  String get plannerTabTours;

  /// No description provided for @plannerLandingHeroTitle.
  ///
  /// In zh, this message translates to:
  /// **'规划你的完美旅程'**
  String get plannerLandingHeroTitle;

  /// No description provided for @plannerLandingHeroSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'量身定制行程，几步即可开始。'**
  String get plannerLandingHeroSubtitle;

  /// No description provided for @plannerModePersonal.
  ///
  /// In zh, this message translates to:
  /// **'个人定制'**
  String get plannerModePersonal;

  /// No description provided for @plannerModeTeam.
  ///
  /// In zh, this message translates to:
  /// **'团队定制'**
  String get plannerModeTeam;

  /// No description provided for @plannerFormDestination.
  ///
  /// In zh, this message translates to:
  /// **'目的地'**
  String get plannerFormDestination;

  /// No description provided for @plannerFormDestinationHint.
  ///
  /// In zh, this message translates to:
  /// **'你想去哪里？'**
  String get plannerFormDestinationHint;

  /// No description provided for @plannerFormDeparture.
  ///
  /// In zh, this message translates to:
  /// **'出发城市'**
  String get plannerFormDeparture;

  /// No description provided for @plannerFormDepartureHint.
  ///
  /// In zh, this message translates to:
  /// **'你的出发地'**
  String get plannerFormDepartureHint;

  /// No description provided for @plannerFormDateRange.
  ///
  /// In zh, this message translates to:
  /// **'出行日期'**
  String get plannerFormDateRange;

  /// No description provided for @plannerFormDateRangeHint.
  ///
  /// In zh, this message translates to:
  /// **'选择日期'**
  String get plannerFormDateRangeHint;

  /// No description provided for @plannerFormTravelers.
  ///
  /// In zh, this message translates to:
  /// **'出行人数'**
  String get plannerFormTravelers;

  /// No description provided for @plannerFormTravelersHint.
  ///
  /// In zh, this message translates to:
  /// **'人数'**
  String get plannerFormTravelersHint;

  /// No description provided for @plannerFormBudget.
  ///
  /// In zh, this message translates to:
  /// **'预算'**
  String get plannerFormBudget;

  /// No description provided for @plannerFormBudgetHint.
  ///
  /// In zh, this message translates to:
  /// **'选填'**
  String get plannerFormBudgetHint;

  /// No description provided for @plannerFormThemes.
  ///
  /// In zh, this message translates to:
  /// **'旅行主题'**
  String get plannerFormThemes;

  /// No description provided for @plannerFormThemesHint.
  ///
  /// In zh, this message translates to:
  /// **'如文化、自然、探险'**
  String get plannerFormThemesHint;

  /// No description provided for @plannerFormCta.
  ///
  /// In zh, this message translates to:
  /// **'开始规划'**
  String get plannerFormCta;

  /// No description provided for @plannerFeaturedTitle.
  ///
  /// In zh, this message translates to:
  /// **'精选套餐'**
  String get plannerFeaturedTitle;

  /// No description provided for @plannerFeaturedSeeAll.
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get plannerFeaturedSeeAll;

  /// No description provided for @plannerWhyChooseUs.
  ///
  /// In zh, this message translates to:
  /// **'为什么选我们'**
  String get plannerWhyChooseUs;

  /// No description provided for @plannerWhySafety.
  ///
  /// In zh, this message translates to:
  /// **'安全可靠'**
  String get plannerWhySafety;

  /// No description provided for @plannerWhySafetyDesc.
  ///
  /// In zh, this message translates to:
  /// **'认证合作方，安心预订'**
  String get plannerWhySafetyDesc;

  /// No description provided for @plannerWhyFlexible.
  ///
  /// In zh, this message translates to:
  /// **'灵活取消'**
  String get plannerWhyFlexible;

  /// No description provided for @plannerWhyFlexibleDesc.
  ///
  /// In zh, this message translates to:
  /// **'出发前免费改期'**
  String get plannerWhyFlexibleDesc;

  /// No description provided for @plannerWhyLocal.
  ///
  /// In zh, this message translates to:
  /// **'当地专家'**
  String get plannerWhyLocal;

  /// No description provided for @plannerWhyLocalDesc.
  ///
  /// In zh, this message translates to:
  /// **'目的地达人精选'**
  String get plannerWhyLocalDesc;

  /// No description provided for @plannerFeaturedEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无精选套餐'**
  String get plannerFeaturedEmpty;

  /// No description provided for @plannerFeaturedEmptyAction.
  ///
  /// In zh, this message translates to:
  /// **'浏览全部行程'**
  String get plannerFeaturedEmptyAction;

  /// No description provided for @plannerGetPlan.
  ///
  /// In zh, this message translates to:
  /// **'生成我的方案'**
  String get plannerGetPlan;

  /// No description provided for @plannerResultTitle.
  ///
  /// In zh, this message translates to:
  /// **'你的方案'**
  String get plannerResultTitle;

  /// No description provided for @plannerResultRecommended.
  ///
  /// In zh, this message translates to:
  /// **'为你推荐'**
  String get plannerResultRecommended;

  /// No description provided for @plannerResultNoPackages.
  ///
  /// In zh, this message translates to:
  /// **'暂无匹配的套餐，试试调整目的地、预算或日期。'**
  String get plannerResultNoPackages;

  /// No description provided for @plannerSavePlan.
  ///
  /// In zh, this message translates to:
  /// **'保存方案'**
  String get plannerSavePlan;

  /// No description provided for @plannerEditPlan.
  ///
  /// In zh, this message translates to:
  /// **'编辑方案'**
  String get plannerEditPlan;

  /// No description provided for @plannerSharePlan.
  ///
  /// In zh, this message translates to:
  /// **'分享方案'**
  String get plannerSharePlan;

  /// No description provided for @plannerRequestConsultant.
  ///
  /// In zh, this message translates to:
  /// **'预约顾问'**
  String get plannerRequestConsultant;

  /// No description provided for @plannerCustomItinerary.
  ///
  /// In zh, this message translates to:
  /// **'生成定制行程'**
  String get plannerCustomItinerary;

  /// No description provided for @plannerPlanSaved.
  ///
  /// In zh, this message translates to:
  /// **'方案已保存'**
  String get plannerPlanSaved;

  /// No description provided for @plannerShareMessage.
  ///
  /// In zh, this message translates to:
  /// **'看看我的旅行方案'**
  String get plannerShareMessage;

  /// No description provided for @plannerConsultantMessage.
  ///
  /// In zh, this message translates to:
  /// **'顾问将尽快与您联系。'**
  String get plannerConsultantMessage;

  /// No description provided for @plannerMatch.
  ///
  /// In zh, this message translates to:
  /// **'匹配度：{score}%'**
  String plannerMatch(Object score);

  /// No description provided for @discoverySearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索目的地、行程…'**
  String get discoverySearchHint;

  /// No description provided for @discoveryFilter.
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get discoveryFilter;

  /// No description provided for @discoveryCategoryAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get discoveryCategoryAll;

  /// No description provided for @discoveryCategoryGroup.
  ///
  /// In zh, this message translates to:
  /// **'跟团'**
  String get discoveryCategoryGroup;

  /// No description provided for @discoveryCategorySmallGroup.
  ///
  /// In zh, this message translates to:
  /// **'小团'**
  String get discoveryCategorySmallGroup;

  /// No description provided for @discoveryCategoryFamily.
  ///
  /// In zh, this message translates to:
  /// **'亲子'**
  String get discoveryCategoryFamily;

  /// No description provided for @discoveryCategoryCustom.
  ///
  /// In zh, this message translates to:
  /// **'定制'**
  String get discoveryCategoryCustom;

  /// No description provided for @discoveryCategoryLocal.
  ///
  /// In zh, this message translates to:
  /// **'周边'**
  String get discoveryCategoryLocal;

  /// No description provided for @discoveryChipDeparture.
  ///
  /// In zh, this message translates to:
  /// **'出发地'**
  String get discoveryChipDeparture;

  /// No description provided for @discoveryChipDays.
  ///
  /// In zh, this message translates to:
  /// **'天数'**
  String get discoveryChipDays;

  /// No description provided for @discoveryChipBudget.
  ///
  /// In zh, this message translates to:
  /// **'预算'**
  String get discoveryChipBudget;

  /// No description provided for @discoveryChipTheme.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get discoveryChipTheme;

  /// No description provided for @discoveryChipSort.
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get discoveryChipSort;

  /// No description provided for @discoverySortRecommended.
  ///
  /// In zh, this message translates to:
  /// **'推荐'**
  String get discoverySortRecommended;

  /// No description provided for @discoverySortPriceAsc.
  ///
  /// In zh, this message translates to:
  /// **'价格从低到高'**
  String get discoverySortPriceAsc;

  /// No description provided for @discoverySortPriceDesc.
  ///
  /// In zh, this message translates to:
  /// **'价格从高到低'**
  String get discoverySortPriceDesc;

  /// No description provided for @discoverySortDurationAsc.
  ///
  /// In zh, this message translates to:
  /// **'行程从短到长'**
  String get discoverySortDurationAsc;

  /// No description provided for @discoverySortDurationDesc.
  ///
  /// In zh, this message translates to:
  /// **'行程从长到短'**
  String get discoverySortDurationDesc;

  /// No description provided for @discoverySortRating.
  ///
  /// In zh, this message translates to:
  /// **'评分优先'**
  String get discoverySortRating;

  /// No description provided for @discoveryEmptyTitle.
  ///
  /// In zh, this message translates to:
  /// **'暂无匹配行程'**
  String get discoveryEmptyTitle;

  /// No description provided for @discoveryEmptySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'试试调整筛选条件或关键词。'**
  String get discoveryEmptySubtitle;

  /// No description provided for @discoveryEmptyAction.
  ///
  /// In zh, this message translates to:
  /// **'清除筛选'**
  String get discoveryEmptyAction;

  /// No description provided for @discoveryAdvancedFilters.
  ///
  /// In zh, this message translates to:
  /// **'更多筛选'**
  String get discoveryAdvancedFilters;

  /// No description provided for @discoveryApplyFilters.
  ///
  /// In zh, this message translates to:
  /// **'应用'**
  String get discoveryApplyFilters;

  /// No description provided for @discoveryClearFilters.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get discoveryClearFilters;

  /// No description provided for @discoveryLoadMore.
  ///
  /// In zh, this message translates to:
  /// **'加载更多'**
  String get discoveryLoadMore;

  /// No description provided for @discoveryFrom.
  ///
  /// In zh, this message translates to:
  /// **'起'**
  String get discoveryFrom;

  /// No description provided for @discoveryFilterReset.
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get discoveryFilterReset;

  /// No description provided for @discoveryFilterPriceRange.
  ///
  /// In zh, this message translates to:
  /// **'价格区间'**
  String get discoveryFilterPriceRange;

  /// No description provided for @discoveryFilterDuration.
  ///
  /// In zh, this message translates to:
  /// **'行程天数'**
  String get discoveryFilterDuration;

  /// No description provided for @discoveryFilterThemes.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get discoveryFilterThemes;

  /// No description provided for @discoveryFilterGroupSize.
  ///
  /// In zh, this message translates to:
  /// **'团队规模'**
  String get discoveryFilterGroupSize;

  /// No description provided for @discoveryFilterDepartureCity.
  ///
  /// In zh, this message translates to:
  /// **'出发城市'**
  String get discoveryFilterDepartureCity;

  /// No description provided for @discoveryFilterAccommodation.
  ///
  /// In zh, this message translates to:
  /// **'住宿等级'**
  String get discoveryFilterAccommodation;

  /// No description provided for @discoveryFilterTransportation.
  ///
  /// In zh, this message translates to:
  /// **'交通方式'**
  String get discoveryFilterTransportation;

  /// No description provided for @discoveryFilterDuration1to3.
  ///
  /// In zh, this message translates to:
  /// **'1-3天'**
  String get discoveryFilterDuration1to3;

  /// No description provided for @discoveryFilterDuration4to7.
  ///
  /// In zh, this message translates to:
  /// **'4-7天'**
  String get discoveryFilterDuration4to7;

  /// No description provided for @discoveryFilterDuration8to14.
  ///
  /// In zh, this message translates to:
  /// **'8-14天'**
  String get discoveryFilterDuration8to14;

  /// No description provided for @discoveryFilterDuration15Plus.
  ///
  /// In zh, this message translates to:
  /// **'15天以上'**
  String get discoveryFilterDuration15Plus;

  /// No description provided for @discoveryFilterGroupSolo.
  ///
  /// In zh, this message translates to:
  /// **'单人'**
  String get discoveryFilterGroupSolo;

  /// No description provided for @discoveryFilterGroup2to4.
  ///
  /// In zh, this message translates to:
  /// **'2-4人'**
  String get discoveryFilterGroup2to4;

  /// No description provided for @discoveryFilterGroup5to9.
  ///
  /// In zh, this message translates to:
  /// **'5-9人'**
  String get discoveryFilterGroup5to9;

  /// No description provided for @discoveryFilterGroup10Plus.
  ///
  /// In zh, this message translates to:
  /// **'10人以上'**
  String get discoveryFilterGroup10Plus;

  /// No description provided for @discoveryFilterAccomEconomy.
  ///
  /// In zh, this message translates to:
  /// **'经济'**
  String get discoveryFilterAccomEconomy;

  /// No description provided for @discoveryFilterAccomComfort.
  ///
  /// In zh, this message translates to:
  /// **'舒适'**
  String get discoveryFilterAccomComfort;

  /// No description provided for @discoveryFilterAccomPremium.
  ///
  /// In zh, this message translates to:
  /// **'高端'**
  String get discoveryFilterAccomPremium;

  /// No description provided for @discoveryFilterAccomLuxury.
  ///
  /// In zh, this message translates to:
  /// **'奢华'**
  String get discoveryFilterAccomLuxury;

  /// No description provided for @discoveryFilterTransportFlight.
  ///
  /// In zh, this message translates to:
  /// **'飞机'**
  String get discoveryFilterTransportFlight;

  /// No description provided for @discoveryFilterTransportTrain.
  ///
  /// In zh, this message translates to:
  /// **'火车/高铁'**
  String get discoveryFilterTransportTrain;

  /// No description provided for @discoveryFilterTransportBus.
  ///
  /// In zh, this message translates to:
  /// **'大巴'**
  String get discoveryFilterTransportBus;

  /// No description provided for @discoveryFilterTransportSelfDrive.
  ///
  /// In zh, this message translates to:
  /// **'自驾'**
  String get discoveryFilterTransportSelfDrive;

  /// No description provided for @discoveryFilterDepartureHint.
  ///
  /// In zh, this message translates to:
  /// **'如：上海、北京'**
  String get discoveryFilterDepartureHint;

  /// No description provided for @detailShare.
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get detailShare;

  /// No description provided for @detailBook.
  ///
  /// In zh, this message translates to:
  /// **'立即预订'**
  String get detailBook;

  /// No description provided for @detailTabOverview.
  ///
  /// In zh, this message translates to:
  /// **'概览'**
  String get detailTabOverview;

  /// No description provided for @detailTabItinerary.
  ///
  /// In zh, this message translates to:
  /// **'行程'**
  String get detailTabItinerary;

  /// No description provided for @detailTabCost.
  ///
  /// In zh, this message translates to:
  /// **'费用'**
  String get detailTabCost;

  /// No description provided for @detailTabNotice.
  ///
  /// In zh, this message translates to:
  /// **'须知'**
  String get detailTabNotice;

  /// No description provided for @detailTabReviews.
  ///
  /// In zh, this message translates to:
  /// **'评价'**
  String get detailTabReviews;

  /// No description provided for @detailFrom.
  ///
  /// In zh, this message translates to:
  /// **'起'**
  String get detailFrom;

  /// No description provided for @detailPerPerson.
  ///
  /// In zh, this message translates to:
  /// **'/人'**
  String get detailPerPerson;

  /// No description provided for @detailDay.
  ///
  /// In zh, this message translates to:
  /// **'第{n}天'**
  String detailDay(Object n);

  /// No description provided for @detailMealsIncluded.
  ///
  /// In zh, this message translates to:
  /// **'餐食'**
  String get detailMealsIncluded;

  /// No description provided for @detailHotel.
  ///
  /// In zh, this message translates to:
  /// **'住宿'**
  String get detailHotel;

  /// No description provided for @detailIncluded.
  ///
  /// In zh, this message translates to:
  /// **'费用包含'**
  String get detailIncluded;

  /// No description provided for @detailExcluded.
  ///
  /// In zh, this message translates to:
  /// **'费用不含'**
  String get detailExcluded;

  /// No description provided for @detailOptionalUpgrades.
  ///
  /// In zh, this message translates to:
  /// **'可选升级'**
  String get detailOptionalUpgrades;

  /// No description provided for @detailNoticeVisa.
  ///
  /// In zh, this message translates to:
  /// **'签证'**
  String get detailNoticeVisa;

  /// No description provided for @detailNoticeInsurance.
  ///
  /// In zh, this message translates to:
  /// **'保险'**
  String get detailNoticeInsurance;

  /// No description provided for @detailNoticeCancellation.
  ///
  /// In zh, this message translates to:
  /// **'取消政策'**
  String get detailNoticeCancellation;

  /// No description provided for @detailNoticeImportant.
  ///
  /// In zh, this message translates to:
  /// **'重要提示'**
  String get detailNoticeImportant;

  /// No description provided for @detailReviewsSummary.
  ///
  /// In zh, this message translates to:
  /// **'评分概览'**
  String get detailReviewsSummary;

  /// No description provided for @detailReviewsCount.
  ///
  /// In zh, this message translates to:
  /// **'{count} 条评价'**
  String detailReviewsCount(Object count);

  /// No description provided for @detailOverviewSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'行程简介'**
  String get detailOverviewSubtitle;

  /// No description provided for @detailNoItinerary.
  ///
  /// In zh, this message translates to:
  /// **'暂无行程说明。'**
  String get detailNoItinerary;

  /// No description provided for @detailNoReviews.
  ///
  /// In zh, this message translates to:
  /// **'暂无评价。'**
  String get detailNoReviews;

  /// No description provided for @detailExperienceMoments.
  ///
  /// In zh, this message translates to:
  /// **'体验瞬间'**
  String get detailExperienceMoments;

  /// No description provided for @detailEmotionalHighlight.
  ///
  /// In zh, this message translates to:
  /// **'当日亮点'**
  String get detailEmotionalHighlight;

  /// No description provided for @detailPhotographyHighlights.
  ///
  /// In zh, this message translates to:
  /// **'摄影推荐'**
  String get detailPhotographyHighlights;

  /// No description provided for @detailLocalCulture.
  ///
  /// In zh, this message translates to:
  /// **'当地文化'**
  String get detailLocalCulture;

  /// No description provided for @detailMapPreview.
  ///
  /// In zh, this message translates to:
  /// **'路线示意'**
  String get detailMapPreview;

  /// No description provided for @detailViewOnMap.
  ///
  /// In zh, this message translates to:
  /// **'在地图中查看'**
  String get detailViewOnMap;

  /// No description provided for @trustCancellationGuarantee.
  ///
  /// In zh, this message translates to:
  /// **'免费取消'**
  String get trustCancellationGuarantee;

  /// No description provided for @trustSecurePayment.
  ///
  /// In zh, this message translates to:
  /// **'安全支付'**
  String get trustSecurePayment;

  /// No description provided for @trustVerifiedLocalPartner.
  ///
  /// In zh, this message translates to:
  /// **'认证本地商家'**
  String get trustVerifiedLocalPartner;

  /// No description provided for @trustRealTravelerReview.
  ///
  /// In zh, this message translates to:
  /// **'真实游客评价'**
  String get trustRealTravelerReview;

  /// No description provided for @trustBookingsLast7Days.
  ///
  /// In zh, this message translates to:
  /// **'近7天有{count}人预订'**
  String trustBookingsLast7Days(Object count);

  /// No description provided for @trustLimitedStock.
  ///
  /// In zh, this message translates to:
  /// **'仅剩{count}个名额'**
  String trustLimitedStock(Object count);

  /// No description provided for @trustLimitedStockTitle.
  ///
  /// In zh, this message translates to:
  /// **'名额紧张'**
  String get trustLimitedStockTitle;

  /// No description provided for @bookingStepOf.
  ///
  /// In zh, this message translates to:
  /// **'第{current}步，共{total}步'**
  String bookingStepOf(Object current, Object total);

  /// No description provided for @bookingSelectDate.
  ///
  /// In zh, this message translates to:
  /// **'选择日期'**
  String get bookingSelectDate;

  /// No description provided for @bookingTravelers.
  ///
  /// In zh, this message translates to:
  /// **'出行人信息'**
  String get bookingTravelers;

  /// No description provided for @bookingAddOns.
  ///
  /// In zh, this message translates to:
  /// **'附加服务'**
  String get bookingAddOns;

  /// No description provided for @bookingReview.
  ///
  /// In zh, this message translates to:
  /// **'确认订单'**
  String get bookingReview;

  /// No description provided for @bookingPayment.
  ///
  /// In zh, this message translates to:
  /// **'支付'**
  String get bookingPayment;

  /// No description provided for @bookingConfirmation.
  ///
  /// In zh, this message translates to:
  /// **'预订成功'**
  String get bookingConfirmation;

  /// No description provided for @bookingNext.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get bookingNext;

  /// No description provided for @bookingDuration.
  ///
  /// In zh, this message translates to:
  /// **'行程'**
  String get bookingDuration;

  /// No description provided for @bookingTravelersCount.
  ///
  /// In zh, this message translates to:
  /// **'出行人数'**
  String get bookingTravelersCount;

  /// No description provided for @bookingBasePrice.
  ///
  /// In zh, this message translates to:
  /// **'基础价格'**
  String get bookingBasePrice;

  /// No description provided for @bookingEstimatedTotal.
  ///
  /// In zh, this message translates to:
  /// **'预估总价'**
  String get bookingEstimatedTotal;

  /// No description provided for @bookingLowestPrice.
  ///
  /// In zh, this message translates to:
  /// **'最低'**
  String get bookingLowestPrice;

  /// No description provided for @bookingUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'—'**
  String get bookingUnavailable;

  /// No description provided for @bookingContactInfo.
  ///
  /// In zh, this message translates to:
  /// **'联系信息'**
  String get bookingContactInfo;

  /// No description provided for @bookingTravelerList.
  ///
  /// In zh, this message translates to:
  /// **'出行人列表'**
  String get bookingTravelerList;

  /// No description provided for @bookingPassportInfo.
  ///
  /// In zh, this message translates to:
  /// **'护照（如需要）'**
  String get bookingPassportInfo;

  /// No description provided for @bookingSpecialRequests.
  ///
  /// In zh, this message translates to:
  /// **'特殊说明'**
  String get bookingSpecialRequests;

  /// No description provided for @bookingAddTraveler.
  ///
  /// In zh, this message translates to:
  /// **'添加出行人'**
  String get bookingAddTraveler;

  /// No description provided for @bookingProceedToPayment.
  ///
  /// In zh, this message translates to:
  /// **'去支付'**
  String get bookingProceedToPayment;

  /// No description provided for @bookingPayNow.
  ///
  /// In zh, this message translates to:
  /// **'立即支付'**
  String get bookingPayNow;

  /// No description provided for @bookingSecurePayment.
  ///
  /// In zh, this message translates to:
  /// **'安全支付'**
  String get bookingSecurePayment;

  /// No description provided for @bookingOrderSummary.
  ///
  /// In zh, this message translates to:
  /// **'订单摘要'**
  String get bookingOrderSummary;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In zh, this message translates to:
  /// **'预订成功'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingViewOrder.
  ///
  /// In zh, this message translates to:
  /// **'查看订单'**
  String get bookingViewOrder;

  /// No description provided for @bookingBackToHome.
  ///
  /// In zh, this message translates to:
  /// **'返回首页'**
  String get bookingBackToHome;

  /// No description provided for @bookingShareTrip.
  ///
  /// In zh, this message translates to:
  /// **'分享行程'**
  String get bookingShareTrip;

  /// No description provided for @bookingOrderNumber.
  ///
  /// In zh, this message translates to:
  /// **'订单号：{orderId}'**
  String bookingOrderNumber(Object orderId);

  /// No description provided for @bookingCreditCard.
  ///
  /// In zh, this message translates to:
  /// **'信用卡'**
  String get bookingCreditCard;

  /// No description provided for @bookingTripInfo.
  ///
  /// In zh, this message translates to:
  /// **'行程信息'**
  String get bookingTripInfo;

  /// No description provided for @membershipCenterTitle.
  ///
  /// In zh, this message translates to:
  /// **'会员中心'**
  String get membershipCenterTitle;

  /// No description provided for @membershipTierBasic.
  ///
  /// In zh, this message translates to:
  /// **'基础'**
  String get membershipTierBasic;

  /// No description provided for @membershipTierSilver.
  ///
  /// In zh, this message translates to:
  /// **'银卡'**
  String get membershipTierSilver;

  /// No description provided for @membershipTierGold.
  ///
  /// In zh, this message translates to:
  /// **'金卡'**
  String get membershipTierGold;

  /// No description provided for @membershipTierVip.
  ///
  /// In zh, this message translates to:
  /// **'VIP'**
  String get membershipTierVip;

  /// No description provided for @membershipPointsBalance.
  ///
  /// In zh, this message translates to:
  /// **'积分余额'**
  String get membershipPointsBalance;

  /// No description provided for @membershipProgressToNext.
  ///
  /// In zh, this message translates to:
  /// **'升级进度'**
  String get membershipProgressToNext;

  /// No description provided for @membershipBenefits.
  ///
  /// In zh, this message translates to:
  /// **'权益'**
  String get membershipBenefits;

  /// No description provided for @membershipDiscount.
  ///
  /// In zh, this message translates to:
  /// **'折扣'**
  String get membershipDiscount;

  /// No description provided for @membershipEarlyBooking.
  ///
  /// In zh, this message translates to:
  /// **'提前预订'**
  String get membershipEarlyBooking;

  /// No description provided for @membershipExclusivePackages.
  ///
  /// In zh, this message translates to:
  /// **'专属套餐'**
  String get membershipExclusivePackages;

  /// No description provided for @membershipPrioritySupport.
  ///
  /// In zh, this message translates to:
  /// **'优先客服'**
  String get membershipPrioritySupport;

  /// No description provided for @membershipExclusivePackagesSection.
  ///
  /// In zh, this message translates to:
  /// **'专属套餐'**
  String get membershipExclusivePackagesSection;

  /// No description provided for @membershipUsePoints.
  ///
  /// In zh, this message translates to:
  /// **'使用积分'**
  String get membershipUsePoints;

  /// No description provided for @membershipPointsOff.
  ///
  /// In zh, this message translates to:
  /// **'{points} 积分抵 ¥{amount}'**
  String membershipPointsOff(Object amount, Object points);

  /// No description provided for @membershipPointsRedeemHint.
  ///
  /// In zh, this message translates to:
  /// **'积分可抵现（100积分=¥10）'**
  String get membershipPointsRedeemHint;
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
