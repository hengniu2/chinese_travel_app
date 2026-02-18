// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dream Travel';

  @override
  String get tabHome => 'Home';

  @override
  String get tabJoinUs => 'Join Us';

  @override
  String get tabPlanner => 'Travel Planner';

  @override
  String get tabMessages => 'Messages';

  @override
  String get tabProfile => 'My';

  @override
  String get homeToursCardTitle => 'Featured Tours';

  @override
  String get homeToursCardSubtitle =>
      'Filter by city, price, days, departure & type';

  @override
  String get homeHotelsCardTitle => 'Hotels';

  @override
  String get homeHotelsCardSubtitle => 'Date, price, star rating & sort';

  @override
  String get homeOrdersCardTitle => 'My Orders';

  @override
  String get homeOrdersCardSubtitle => 'All, Unpaid, Upcoming, Done, Refund';

  @override
  String get toursTitle => 'Featured Tours';

  @override
  String get tourBookNow => 'Book Now';

  @override
  String get tourOrderTitle => 'Fill Order';

  @override
  String get tourSubmitPay => 'Submit & Pay';

  @override
  String get tourAddTraveler => 'Add Traveler';

  @override
  String get hotelsTitle => 'Hotels';

  @override
  String get hotelBook => 'Book';

  @override
  String get hotelOrderTitle => 'Fill Order';

  @override
  String get hotelAddGuest => 'Add Guest';

  @override
  String get hotelPricePerNight => '/night';

  @override
  String get ordersTitle => 'My Orders';

  @override
  String get orderDetailTitle => 'Order Detail';

  @override
  String get orderInfo => 'Order Info';

  @override
  String get orderAmount => 'Amount';

  @override
  String get orderTravelers => 'Travelers';

  @override
  String get orderPaymentStatus => 'Payment Status';

  @override
  String get orderPaid => 'Paid';

  @override
  String get orderUnpaid => 'Unpaid';

  @override
  String get orderRefund => 'Request Refund';

  @override
  String get orderContactService => 'Customer Service';

  @override
  String get orderContactServiceHint => 'Contact us for order issues';

  @override
  String get orderRefundSubmitted => 'Refund request submitted';

  @override
  String get orderContactOpening => 'Opening customer service';

  @override
  String get orderGoToPay => 'Pay';

  @override
  String get orderNoOrders => 'No orders yet';

  @override
  String get orderReturnToOrders => 'Back to Orders';

  @override
  String get ordersTabAll => 'All';

  @override
  String get ordersTabUnpaid => 'Unpaid';

  @override
  String get ordersTabUpcoming => 'Upcoming';

  @override
  String get ordersTabDone => 'Done';

  @override
  String get ordersTabRefund => 'Refund';

  @override
  String get orderNo => 'Order No.';

  @override
  String get orderType => 'Type';

  @override
  String get orderProduct => 'Product';

  @override
  String get orderSpec => 'Spec';

  @override
  String get orderTravelDate => 'Departure';

  @override
  String get orderCheckIn => 'Check-in';

  @override
  String get orderCreateTime => 'Order time';

  @override
  String get orderTypeTour => 'Tour';

  @override
  String get orderTypeHotel => 'Hotel';

  @override
  String get orderViewDetail => 'View detail';

  @override
  String get orderBookAgain => 'Book again';

  @override
  String get orderViewRefund => 'View refund';

  @override
  String get orderTravelDateLabel => 'Departure';

  @override
  String get orderCheckOut => 'Check-out';

  @override
  String get paymentTitle => 'Checkout';

  @override
  String get paymentAmountDue => 'Amount due ';

  @override
  String paymentOrderNo(String orderId) {
    return 'Order No. $orderId';
  }

  @override
  String get paymentSelectMethod => 'Select payment method';

  @override
  String get paymentAlipay => 'Alipay';

  @override
  String get paymentAlipayHint => 'Pay with Alipay';

  @override
  String get paymentWechat => 'WeChat Pay';

  @override
  String get paymentWechatHint => 'Pay with WeChat';

  @override
  String get paymentConfirm => 'Confirm Pay';

  @override
  String get paymentPaying => 'Paying...';

  @override
  String get paymentDoNotClose => 'Do not close this page';

  @override
  String get paymentSuccess => 'Payment successful';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get paymentRetry => 'Retry';

  @override
  String get paymentSelectMethodFirst => 'Please select a payment method';

  @override
  String get paymentFailedHint => 'Please retry or use another method';

  @override
  String get chatTitle => 'Messages';

  @override
  String get chatNoMessages => 'No messages yet';

  @override
  String get chatSaySomething => 'Say something...';

  @override
  String get chatSend => 'Send';

  @override
  String get forumTitle => 'Travel Community';

  @override
  String get forumNoContent => 'No content yet';

  @override
  String get articleTitle => 'Article';

  @override
  String articleComments(int count) {
    return 'Comments ($count)';
  }

  @override
  String get articleNoComments => 'No comments yet. Be the first!';

  @override
  String get articleExpandFull => 'Expand';

  @override
  String get articleCollapse => 'Collapse';

  @override
  String get articlePostComment => 'Post';

  @override
  String get profileTitle => 'My';

  @override
  String get profileLogin => 'Tap to log in';

  @override
  String get profileLoggedIn => 'Logged in';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileVerified => 'Verified';

  @override
  String get profileNotVerified => 'Not verified';

  @override
  String get profileMyOrders => 'My Orders';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileWallet => 'Wallet';

  @override
  String get profileCoupons => 'Coupons';

  @override
  String get profileMessages => 'Messages';

  @override
  String get profileSettings => 'Settings';

  @override
  String profileFeatureComing(String name) {
    return '$name coming soon';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageZh => '中文';

  @override
  String get languageEn => 'English';

  @override
  String get realNameVerifyTitle => 'Real-name Verification';

  @override
  String get realNameVerifyHint =>
      'Enter your real name and ID number for verification';

  @override
  String get realNameVerifyName => 'Name';

  @override
  String get realNameVerifyNameHint => 'Enter your real name';

  @override
  String get realNameVerifyIdCard => 'ID Number';

  @override
  String get realNameVerifyIdCardHint => 'Enter ID number';

  @override
  String get realNameVerifySubmit => 'Submit';

  @override
  String get realNameVerifySuccess => 'Verification submitted successfully';

  @override
  String get realNameVerifyNameRequired => 'Please enter your name';

  @override
  String get realNameVerifyIdCardInvalid => 'Please enter a valid ID number';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get tourOrderProductPerPerson => '/person from';

  @override
  String get hotelOrderProductPerNight => '/night';

  @override
  String get orderCardOrder => 'Order';

  @override
  String get filterPriceRange => 'Price range';

  @override
  String get filterStar => 'Star rating';

  @override
  String get filterSort => 'Sort';

  @override
  String get filterAll => 'All';

  @override
  String get checkInOut => 'Check-in/out';

  @override
  String get hotelEmpty => 'No hotels match your filters';

  @override
  String get tourEmpty => 'No tours match your filters';

  @override
  String get filterClear => 'Clear filters';
}
