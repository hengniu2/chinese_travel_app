import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

/// 享梦游种草官列表 - 商业级列表页，与首页视觉统一
class SeedListPage extends StatelessWidget {
  const SeedListPage({super.key});

  static const _kHeaderHeight = 120.0;
  static const _kCardRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final list = _expandList(kHomePeople, 6);
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: CustomScrollView(
        slivers: [
          _buildGradientAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                '发现更多种草官',
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
                  final person = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SeedListCard(
                      person: person,
                      onTap: () => context.push('/blog/${person.id.split('_').first}'),
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
        '享梦游种草官',
        style: GoogleFonts.zcoolKuaiLe(
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  static List<HomePersonItem> _expandList(List<HomePersonItem> src, int targetCount) {
    if (src.isEmpty) return [];
    final out = <HomePersonItem>[];
    for (var i = 0; out.length < targetCount; i++) {
      for (final p in src) {
        if (out.length >= targetCount) break;
        out.add(HomePersonItem(
          id: '${p.id}_$i',
          name: p.name,
          avatarUrl: p.avatarUrl,
        ));
      }
    }
    return out;
  }
}

class _SeedListCard extends StatelessWidget {
  const _SeedListCard({required this.person, required this.onTap});

  final HomePersonItem person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SeedListPage._kCardRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SeedListPage._kCardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(SeedListPage._kCardRadius)),
                child: AppNetworkImage(
                  imageUrl: person.avatarUrl,
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: GoogleFonts.zcoolKuaiLe(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '发现更多旅行故事',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
