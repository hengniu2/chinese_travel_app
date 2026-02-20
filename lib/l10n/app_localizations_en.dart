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

  @override
  String get authWelcomeBack => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Log in to discover more travel';

  @override
  String get authPhone => 'Phone';

  @override
  String get authPassword => 'Password';

  @override
  String get authLogin => 'Log in';

  @override
  String get authVerifyCodeLogin => 'Verify code login';

  @override
  String get authVerifyCodeLoginSubtitle =>
      'Unregistered numbers will create an account after verification';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authRegisterNow => 'Register now';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authRegisterSubtitle => 'Join us for green travel';

  @override
  String get authVerifyCode => 'Verify code';

  @override
  String get authSetPassword => 'Set password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authRegister => 'Register';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authGoToLogin => 'Log in';

  @override
  String get authResetPassword => 'Reset password';

  @override
  String get authResetPasswordSubtitle =>
      'Reset your password via phone verification';

  @override
  String get authNewPassword => 'New password';

  @override
  String get authConfirmNewPassword => 'Confirm new password';

  @override
  String get authConfirmReset => 'Confirm reset';

  @override
  String get authUsePasswordLogin => 'Use password login';

  @override
  String get authVerifyCodeSent => 'Verification code sent';

  @override
  String get authPasswordResetSuccess => 'Password reset. Please log in';

  @override
  String get authAgreementRequired =>
      'Please read and agree to the user agreement and privacy policy';

  @override
  String get authForgotPasswordPageTitle => 'Forgot password';

  @override
  String get sectionGuests => 'Guests';

  @override
  String get sectionTravelers => 'Travelers';

  @override
  String get sectionAgreement => 'Agreement';

  @override
  String get orderGuestHint => 'Enter name, ID number and phone for each guest';

  @override
  String get orderTravelerHint =>
      'Enter name, ID number and phone for each traveler';

  @override
  String orderGuestNameError(int n) {
    return 'Enter name for guest $n';
  }

  @override
  String orderTravelerNameError(int n) {
    return 'Enter name for traveler $n';
  }

  @override
  String orderGuestIdError(int n) {
    return 'Enter ID number for guest $n';
  }

  @override
  String orderTravelerIdError(int n) {
    return 'Enter ID number for traveler $n';
  }

  @override
  String orderGuestPhoneError(int n) {
    return 'Enter phone for guest $n';
  }

  @override
  String orderTravelerPhoneError(int n) {
    return 'Enter phone for traveler $n';
  }

  @override
  String get orderAgreementRequired =>
      'Please read and agree to the user agreement and privacy policy';

  @override
  String get hotelNoRooms => 'No rooms available';

  @override
  String get guestLabel => 'Guest';

  @override
  String get commonRetry => 'Retry';

  @override
  String get filterSelectCity => 'Select city';

  @override
  String get filterSelectPrice => 'Select price';

  @override
  String get filterSelectDays => 'Select days';

  @override
  String get filterSelectType => 'Select type';

  @override
  String tourDaysNights(int days, int nights) {
    return '${days}d ${nights}n';
  }

  @override
  String tourDepartFrom(String city) {
    return 'From $city';
  }

  @override
  String get priceFrom => ' from';

  @override
  String tourDayTitle(int day, String title) {
    return 'Day $day $title';
  }

  @override
  String get sectionItinerary => 'Itinerary';

  @override
  String get sectionHighlights => 'Highlights';

  @override
  String get sectionCost => 'Cost';

  @override
  String get sectionCostIncluded => 'Included';

  @override
  String get sectionCostExcluded => 'Excluded';

  @override
  String get sectionHotelInfo => 'Hotels';

  @override
  String get sectionPolicy => 'Policy';

  @override
  String get sectionReviews => 'Reviews';

  @override
  String get hotelSectionRooms => 'Room types';

  @override
  String get hotelSectionPolicy => 'Cancellation';

  @override
  String get hotelSectionFacilities => 'Facilities';

  @override
  String get hotelSectionReviews => 'Reviews';

  @override
  String get hotelScoreSuffix => '';

  @override
  String get roomAvailable => 'Available';

  @override
  String roomRemaining(int count) {
    return '$count left';
  }

  @override
  String get roomLimited => 'Limited';

  @override
  String get roomSoldOut => 'Sold out';

  @override
  String get chatInputHint => 'Type a message';

  @override
  String chatOrderCard(String id) {
    return 'Order $id';
  }

  @override
  String get travelerFormName => 'Name';

  @override
  String get travelerFormIdCard => 'ID number';

  @override
  String get travelerFormPhone => 'Phone';

  @override
  String get companionOrderTitle => 'Fill order';

  @override
  String get companionSubmitOrder => 'Submit order';

  @override
  String get companionOrderSuccess => 'Order submitted';

  @override
  String get companionAddTraveler => 'Add companion';

  @override
  String get companionRemarksHint =>
      'Optional, e.g. special requests, meeting point';

  @override
  String get companionSectionSkills => 'Skills';

  @override
  String get companionSectionDescription => 'Description';

  @override
  String get companionSectionPackages => 'Packages';

  @override
  String get companionSectionCalendar => 'Calendar';

  @override
  String get companionViewAll => 'View all';

  @override
  String get companionSectionReviews => 'Reviews';

  @override
  String get plannerTabTours => 'Tours';
}
