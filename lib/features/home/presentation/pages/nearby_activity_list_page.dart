import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

/// 周边活动列表 - 海报式卡片、与首页视觉统一
class NearbyActivityListPage extends StatelessWidget {
  const NearbyActivityListPage({super.key});

  static const _kHeaderHeight = 120.0;
  static const _kPosterRadius = 14.0;
  static const _weekdays = ['周四', '周五', '周六', '周日'];

  @override
  Widget build(BuildContext context) {
    final list = _expandList(kHomeAroundActivities, 8);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: CustomScrollView(
        slivers: [
          _buildGradientAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                '周边活动',
                style: GoogleFonts.zcoolKuaiLe(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = list[index];
                  final weekday = _weekdays[index % _weekdays.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NearbyPosterCard(
                      item: item,
                      weekday: weekday,
                      onTap: () => context.push('/activity/${item.id.split('_').first}'),
                    ),
                  );
                },
                childCount: list.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildGradientAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _kHeaderHeight,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFD32F2F),
              const Color(0xFFFF6D35),
            ],
          ),
        ),
      ),
      title: Text(
        '周边活动',
        style: GoogleFonts.zcoolKuaiLe(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  static List<HomeAroundActivityItem> _expandList(List<HomeAroundActivityItem> src, int targetCount) {
    if (src.isEmpty) return [];
    final out = <HomeAroundActivityItem>[];
    for (var i = 0; out.length < targetCount; i++) {
      for (final p in src) {
        if (out.length >= targetCount) break;
        out.add(HomeAroundActivityItem(
          id: '${p.id}_$i',
          title: p.title,
          date: p.date,
          location: p.location,
          imageUrl: p.imageUrl,
          hot: p.hot,
        ));
      }
    }
    return out;
  }
}

class _NearbyPosterCard extends StatelessWidget {
  const _NearbyPosterCard({required this.item, required this.weekday, required this.onTap});

  final HomeAroundActivityItem item;
  final String weekday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NearbyActivityListPage._kPosterRadius),
        child: Container(
          height: 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NearbyActivityListPage._kPosterRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: -2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(
                imageUrl: item.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.zcoolKuaiLe(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$weekday ${item.date} · ${item.location}',
                              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (item.hot)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.homeChipRed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text('HOT', style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w800)),
                        ),
                    ],
                  ),
                ),
              ),
              if (item.hot)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.homeChipRed.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('热门', style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w800)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
