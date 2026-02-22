import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_gradients.dart';
import '../../../shared/design_system/app_tap_scale.dart';
import '../theme/hotel_theme.dart';

/// Hotel list page header: gradient, title, city, search.
class HotelHeader extends StatelessWidget {
  const HotelHeader({
    super.key,
    required this.title,
    this.cityName,
    this.searchPlaceholder,
    this.searchKeyword,
    this.onCityTap,
    this.onSearchTap,
    this.onSearchChanged,
    this.searchController,
  });

  final String title;
  final String? cityName;
  final String? searchPlaceholder;
  final String? searchKeyword;
  final VoidCallback? onCityTap;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  static const double _headerRadius = 24;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppGradients.hotelHeaderWarm,
          stops: AppGradients.hotelHeaderWarmStops,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(_headerRadius),
          bottomRight: Radius.circular(_headerRadius),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            HotelTheme.grid2.w,
            HotelTheme.grid1.h,
            HotelTheme.grid2.w,
            HotelTheme.grid3.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Semantics(
                    label: '返回',
                    button: true,
                    child: AppTapScale(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Padding(
                        padding: EdgeInsets.all(HotelTheme.grid1.w),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
              SizedBox(height: HotelTheme.grid2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (onCityTap != null)
                    _GlassChip(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 18.sp, color: Colors.white),
                          SizedBox(width: HotelTheme.grid1.w),
                          Text(
                            cityName ?? '选择城市',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20.sp, color: Colors.white70),
                        ],
                      ),
                      onTap: onCityTap,
                    ),
                  if (onCityTap != null) SizedBox(width: HotelTheme.grid2.w),
                  Expanded(
                    child: onSearchChanged != null
                        ? _GlassChip(
                            padding: EdgeInsets.symmetric(
                                horizontal: HotelTheme.grid2.w, vertical: 10.h),
                            child: TextField(
                              onChanged: onSearchChanged,
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText:
                                    searchPlaceholder ?? '酒店 / 关键词 / 品牌',
                                hintStyle: AppTextStyles.bodyMedium
                                    .copyWith(color: Colors.white70),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(Icons.search_rounded,
                                    size: 20.sp, color: Colors.white70),
                                prefixIconConstraints: BoxConstraints(
                                    minWidth: 36.w, minHeight: 24.h),
                              ),
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        : _GlassChip(
                            padding: EdgeInsets.symmetric(
                                horizontal: HotelTheme.grid2.w, vertical: 10.h),
                            onTap: onSearchTap ?? () {},
                            child: Row(
                              children: [
                                Icon(Icons.search_rounded,
                                    size: 20.sp, color: Colors.white70),
                                SizedBox(width: HotelTheme.grid2.w),
                                Expanded(
                                  child: Text(
                                    searchKeyword?.isNotEmpty == true
                                        ? searchKeyword!
                                        : (searchPlaceholder ??
                                            '酒店 / 关键词 / 品牌'),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color:
                                          searchKeyword?.isNotEmpty == true
                                              ? Colors.white
                                              : Colors.white70,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(9999),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(9999),
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(
                      horizontal: HotelTheme.grid2.w,
                      vertical: HotelTheme.grid1.h),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
