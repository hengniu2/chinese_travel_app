import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';

/// 当前 locale 的 Provider（可切换中英）
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale(AppConstants.defaultLocale);
});
