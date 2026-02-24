import 'package:flutter/material.dart';

import 'luxury_constants.dart';

/// Soft fade barrier + smooth rise (250ms). Use instead of showModalBottomSheet.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  Color? barrierColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: builder,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor ?? Colors.transparent,
    barrierColor: barrierColor ??
        Color.fromRGBO(0, 0, 0, LuxuryInteractions.bottomSheetBarrierOpacity),
    sheetAnimationStyle: AnimationStyle(
      duration: LuxuryInteractions.duration,
      reverseDuration: LuxuryInteractions.durationReverse,
    ),
    elevation: elevation,
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
    clipBehavior: clipBehavior ?? Clip.antiAlias,
  );
}
