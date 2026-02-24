import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

/// 亲子活动列表 - 海报式卡片、与首页视觉统一
class ChildActivityListPage extends StatelessWidget {
  const ChildActivityListPage({super.key});

  static const _kHeaderHeight = 120.0;
  static const _kPosterRadius = 14.0;

  @override
  Widget build(BuildContext context) {
    final list = _expandList(kHomeFamilyActivities, 9);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: CustomScrollView(
        slivers: [
          _buildGradientAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                '亲子活动推荐',
                style: AppTextStyles.header(AppColors.textPrimary, fontSize: 18.sp),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = list[index];
                  return _PosterCard(
                    item: item,
                    index: index,
                    onTap: () => context.push('/activity/${item.id.split('_').first}'),
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
        '亲子活动',
        style: AppTextStyles.header(Colors.white, fontSize: 18.sp),
      ),
    );
  }

  static List<HomeFamilyActivityItem> _expandList(List<HomeFamilyActivityItem> src, int targetCount) {
    if (src.isEmpty) return [];
    final out = <HomeFamilyActivityItem>[];
    for (var i = 0; out.length < targetCount; i++) {
      for (final p in src) {
        if (out.length >= targetCount) break;
        out.add(HomeFamilyActivityItem(
          id: '${p.id}_$i',
          title: p.title,
          subtitle: p.subtitle,
          imageUrl: p.imageUrl,
          tag: p.tag,
        ));
      }
    }
    return out;
  }
}

class _PosterCard extends StatelessWidget {
  const _PosterCard({required this.item, required this.index, required this.onTap});

  final HomeFamilyActivityItem item;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ChildActivityListPage._kPosterRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ChildActivityListPage._kPosterRadius),
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
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.header(Colors.white, fontSize: 14.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.tag,
                          style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index == 0)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.homeChipRed.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('推荐', style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w800)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
