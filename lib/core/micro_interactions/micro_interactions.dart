/// Luxury micro-interaction system: 60fps, no bounce, no flash.
///
/// - Button press: 0.96 scale (AppTapScale, AppButton)
/// - Page transition: 250ms fade + slide (page_transitions, slidePageRoute)
/// - Cards: 4px lift on tap (AppCard)
/// - Bottom sheet: soft fade barrier + smooth rise (showAppBottomSheet)
/// - Curve: [LuxuryInteractions.luxuryCurve] (easeInOutCubic)
library;

export 'app_bottom_sheet.dart';
export 'fade_in.dart';
export 'luxury_constants.dart';
export 'page_route_builder.dart';
