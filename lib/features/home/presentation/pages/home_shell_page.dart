import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/app_router_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../data/home_mock_data.dart';

// ─── 中国卡通插画风 · 视觉常量 ─────────────────────────────────────────────
const double _kSectionPadH = 12;
const double _kSectionPadV = 10;
const double _kCardGap = 8;
const double _kGridRowGap = 4;
const double _kCardRadius = 8;
const double _kPosterCardRadius = 8;
const double _kSearchRadius = 12;
const double _kHeaderHeightDp = 260;

/// 首页 - 中国卡通插画风（高饱和 Header、混合卡片 A/B/C/D、模块分区色、0 overflow）
class HomeShellPage extends ConsumerStatefulWidget {
  const HomeShellPage({super.key});

  @override
  ConsumerState<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends ConsumerState<HomeShellPage>
    with TickerProviderStateMixin {
  late AnimationController _pageController;
  late AnimationController _contentController;
  late Animation<double> _pageOpacity;
  late Animation<Offset> _pageSlide;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _pageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
    );
    _pageSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic),
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pageController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _safePush(String path) {
    if (!mounted) return;
    // Use context.push so the shell branch navigator receives the push and the new page is shown.
    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    final heroHeight = _kHeaderHeightDp;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: Column(
        children: [
          SizedBox(
            height: heroHeight,
            width: double.infinity,
            child: _HomeHeader(heroHeight: heroHeight),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _pageOpacity,
              child: SlideTransition(
                position: _pageSlide,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _HomeContentCard(
                        contentController: _contentController,
                        index: 0,
                        onNavigate: _safePush,
                        onGoTours: () => _safePush('/tours'),
                        onGoHotels: () => _safePush('/hotels'),
                        onGoOrders: () => _safePush('/orders'),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _SectionGreen(
                        contentController: _contentController,
                        index: 1,
                        child: _PeopleSection(onNavigate: _safePush),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _SectionYellow(
                        contentController: _contentController,
                        index: 2,
                        child: _FamilyActivitiesSection(onNavigate: _safePush),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _SectionBlue(
                        contentController: _contentController,
                        index: 3,
                        child: _AroundActivitiesSection(onNavigate: _safePush),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header 结构：纯插画 + 可交互搜索栏（插画内已含标题，不再渲染标题）────────────────
// HeaderContainer (relative, height 260dp)
//   ├── BackgroundImage (zIndex 1, absolute fill, resizeMode: cover)
//   └── RealSearchBar (zIndex 3, absolute, 精准覆盖插画中的搜索栏)
// 禁止：再创建 Text 标题、副标题或任何叠加文字。
// ─────────────────────────────────────────────────────────────────────────────
const double _kHeaderHeightDpRef = 260;

// 搜索栏：底部居中，小号胶囊；点击放大镜显示输入，点击外部或 Enter 收起
const double _kHeaderSearchInsetBottom = 16;
const double _kHeaderSearchInsetHorizontal = 16;
const double _kHeaderSearchPillHeight = 36;
const double _kHeaderSearchPillRadius = 12;
const double _kHeaderSearchPillMaxWidth = 260;

/// Header：纯插画背景 + 顶部居中可展开搜索栏
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.heroHeight});

  final double heroHeight;

  @override
  Widget build(BuildContext context) {
    final imageUrl = kHomeHeaderSceneUrl.isNotEmpty ? kHomeHeaderSceneUrl : kHomeHeaderCartoonUrl;
    final effectiveUrl = imageUrl.isEmpty ? kHomeHeaderBackgroundUrl : imageUrl;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: _HeaderBackgroundImage(imageUrl: effectiveUrl),
        ),
        Positioned(
          bottom: _kHeaderSearchInsetBottom,
          left: _kHeaderSearchInsetHorizontal,
          right: _kHeaderSearchInsetHorizontal,
          child: _HeaderSearchBarFull(
            location: '安顺市',
            hint: '和种草官一起环游...',
          ),
        ),
      ],
    );
  }
}

/// Header 搜索栏：完整胶囊，输入框始终可见（与原始设计一致）
class _HeaderSearchBarFull extends StatefulWidget {
  const _HeaderSearchBarFull({
    required this.location,
    required this.hint,
  });

  final String location;
  final String hint;

  @override
  State<_HeaderSearchBarFull> createState() => _HeaderSearchBarFullState();
}

class _HeaderSearchBarFullState extends State<_HeaderSearchBarFull> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kHeaderSearchPillHeight,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.homeSearchCapsule,
        borderRadius: BorderRadius.circular(_kHeaderSearchPillRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondary),
          SizedBox(width: 6),
          Text(
            widget.location,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 6),
          Container(width: 1, height: 14, color: AppColors.divider),
          SizedBox(width: 6),
          Icon(Icons.search_rounded, size: 18, color: AppColors.textTertiary),
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 右侧局部插画：仅显示图片右侧部分（男孩在画面内），cover 且对齐右侧
class _HeaderPartialImage extends StatelessWidget {
  const _HeaderPartialImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.isEmpty ? kHomeHeaderBackgroundUrl : imageUrl;
    if (url.isEmpty) {
      return _HeaderCartoonPlaceholder();
    }
    // 对齐到右侧，使插画中的男孩（在原图右侧）完整露出
    const alignment = Alignment(1.0, 0.5);
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _HeaderCartoonPlaceholder(),
      );
    }
    return AppNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      alignment: alignment,
      fadeInDuration: const Duration(milliseconds: 400),
      errorWidget: _HeaderCartoonPlaceholder(),
    );
  }
}

/// Header 背景：仅卡通插画（URL/asset）或代码绘制 Q 版占位；禁止风景摄影图。
class _HeaderBackgroundImage extends StatelessWidget {
  const _HeaderBackgroundImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.isEmpty ? kHomeHeaderBackgroundUrl : imageUrl;
    if (url.isEmpty) {
      return _HeaderCartoonPlaceholder();
    }
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _HeaderCartoonPlaceholder(),
      );
    }
    return AppNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      fadeInDuration: const Duration(milliseconds: 400),
      errorWidget: _HeaderCartoonPlaceholder(),
    );
  }
}

/// Q 版春节旅行插画占位（代码绘制）：红橙暖色、小人、塔、路径、烟花，禁止使用照片
class _HeaderCartoonPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _HeaderCartoonPlaceholderPainter(),
    );
  }
}

class _HeaderCartoonPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final u = w * 0.04;

    // 暖色红橙渐变背景
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFD32F2F),
        const Color(0xFFFF6D35),
        const Color(0xFFFF8F65),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    canvas.drawRect(bgRect, Paint()..shader = bgGradient.createShader(bgRect));

    // 右侧小塔（中国元素）
    final towerPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);
    final towerPath = Path()
      ..moveTo(w * 0.78, h * 0.72)
      ..lineTo(w * 0.82, h * 0.5)
      ..lineTo(w * 0.86, h * 0.72)
      ..close();
    canvas.drawPath(towerPath, towerPaint);

    // 地图路径线（曲线）
    final pathPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(w * 0.1, h * 0.6)
      ..quadraticBezierTo(w * 0.35, h * 0.4, w * 0.6, h * 0.55)
      ..quadraticBezierTo(w * 0.85, h * 0.7, w * 0.95, h * 0.45);
    canvas.drawPath(path, pathPaint);

    // 小烟花点
    final sparkPaint = Paint()..color = Colors.white.withValues(alpha: 0.35);
    for (final p in [
      Offset(w * 0.88, h * 0.22),
      Offset(w * 0.92, h * 0.35),
      Offset(w * 0.15, h * 0.28),
    ]) {
      canvas.drawCircle(p, 4, sparkPaint);
    }

    // Q 版旅行小人（右侧，背背包）
    final cx = w * 0.72;
    final baseY = h * 0.68;
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.45);
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final r = u * 1.2;
    canvas.drawCircle(Offset(cx, baseY - r * 1.6), r, paint);
    canvas.drawCircle(Offset(cx, baseY - r * 1.6), r, stroke);
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, baseY + r * 0.4), width: r * 1.8, height: r * 2),
      Radius.circular(r * 0.8),
    );
    canvas.drawRRect(body, paint);
    canvas.drawRRect(body, stroke);
    final bag = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx + r * 0.3, baseY - r * 0.2, r * 0.6, r * 1),
      Radius.circular(r * 0.3),
    );
    canvas.drawRRect(bag, paint);
    canvas.drawRRect(bag, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeSearchBarCapsule extends StatelessWidget {
  const _HomeSearchBarCapsule({
    required this.location,
    required this.hint,
    this.onTap,
  });

  final String location;
  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.homeSearchCapsule,
          borderRadius: BorderRadius.circular(_kSearchRadius),
          boxShadow: AppShadow.light,
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_rounded, size: 18.sp, color: AppColors.textSecondary),
            SizedBox(width: 5),
            Text(
              location,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 8),
            Container(width: 1, height: 14, color: AppColors.divider),
            SizedBox(width: 8),
            Icon(Icons.search_rounded, size: 18.sp, color: AppColors.textTertiary),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                hint,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 内容区白卡：搜索栏 + 功能入口 Grid（搜索栏不放在 Header，保持原设计）
class _HomeContentCard extends StatelessWidget {
  const _HomeContentCard({
    required this.contentController,
    required this.index,
    required this.onNavigate,
    required this.onGoTours,
    required this.onGoHotels,
    required this.onGoOrders,
  });

  final AnimationController contentController;
  final int index;
  final void Function(String path) onNavigate;
  final VoidCallback onGoTours;
  final VoidCallback onGoHotels;
  final VoidCallback onGoOrders;

  @override
  Widget build(BuildContext context) {
    return _AnimatedSection(
      controller: contentController,
      index: index,
      child: Container(
        width: double.infinity,
        color: AppColors.homeSearchCapsule,
        padding: EdgeInsets.fromLTRB(_kSectionPadH, _kSectionPadV * 1.2, _kSectionPadH, _kSectionPadV),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildGridRows(context),
        ),
      ),
    );
  }

  List<Widget> _buildGridRows(BuildContext context) {
    // 10 个入口，中国风图标（圆角方形容器 + Icon）
    final items = [
      (icon: Icons.groups_rounded, label: '社交旅行', color: AppColors.tagGreen, badge: null, onTap: () => onNavigate('/social-travel')),
      (icon: Icons.family_restroom_rounded, label: '亲子旅行', color: AppColors.accentGold, badge: null, onTap: () => onNavigate('/family-travel')),
      (icon: Icons.tune_rounded, label: '定制旅行', color: AppColors.accentCool, badge: null, onTap: () => onNavigate('/custom-travel')),
      (icon: Icons.groups_2_rounded, label: '小包团', color: AppColors.primary, badge: '2~8人', onTap: () => onNavigate('/small-group')),
      (icon: Icons.tour_rounded, label: '精选线路', color: AppColors.tagGreen, badge: null, onTap: onGoTours),
      (icon: Icons.hotel_rounded, label: '酒店', color: AppColors.accentGold, badge: null, onTap: onGoHotels),
      (icon: Icons.receipt_long_rounded, label: '我的订单', color: AppColors.accentCool, badge: null, onTap: onGoOrders),
      (icon: Icons.explore_rounded, label: '周边活动', color: AppColors.accentWarm, badge: null, onTap: () => onNavigate('/surrounding-activities')),
      (icon: Icons.child_care_rounded, label: '亲子活动', color: AppColors.accentGold, badge: null, onTap: () => onNavigate('/family-travel')),
      (icon: Icons.menu_book_rounded, label: '游玩笔记', color: AppColors.accentCool, badge: null, onTap: () => onNavigate('/notes')),
    ];
    return [
      Row(
        children: [
          for (int i = 0; i < 5; i++)
            Expanded(child: _GridItem(item: items[i])),
        ],
      ),
      SizedBox(height: _kGridRowGap),
      Row(
        children: [
          for (int i = 5; i < 10; i++)
            Expanded(child: _GridItem(item: items[i])),
        ],
      ),
    ];
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({required this.item});

  final ({IconData icon, String label, Color color, String? badge, VoidCallback onTap}) item;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: item.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: item.color.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    item.icon,
                    size: 24.sp,
                    color: item.color,
                  ),
                ),
                if (item.badge != null)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.homeChipRed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.badge!,
                        style: AppTextStyles.overline.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              item.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({
    required this.controller,
    required this.index,
    required this.child,
  });

  final AnimationController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.1).clamp(0.0, 0.6);
    final end = (index * 0.1 + 0.35).clamp(0.0, 1.0);
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = Curves.easeOutCubic.transform(
          ((controller.value - start) / (end - start)).clamp(0.0, 1.0),
        );
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}

class _SectionGreen extends StatelessWidget {
  const _SectionGreen({
    required this.contentController,
    required this.index,
    required this.child,
  });

  final AnimationController contentController;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _AnimatedSection(
      controller: contentController,
      index: index,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.homeSectionGreen,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        padding: EdgeInsets.fromLTRB(_kSectionPadH, _kSectionPadV, _kSectionPadH, _kSectionPadV),
        child: child,
      ),
    );
  }
}

class _SectionYellow extends StatelessWidget {
  const _SectionYellow({
    required this.contentController,
    required this.index,
    required this.child,
  });

  final AnimationController contentController;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _AnimatedSection(
      controller: contentController,
      index: index,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.homeSectionYellow,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        padding: EdgeInsets.fromLTRB(_kSectionPadH, _kSectionPadV, _kSectionPadH, _kSectionPadV),
        child: child,
      ),
    );
  }
}

class _SectionBlue extends StatelessWidget {
  const _SectionBlue({
    required this.contentController,
    required this.index,
    required this.child,
  });

  final AnimationController contentController;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _AnimatedSection(
      controller: contentController,
      index: index,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.homeSectionBlueStart,
              AppColors.homeSectionBlueEnd,
            ],
          ),
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        padding: EdgeInsets.fromLTRB(_kSectionPadH, _kSectionPadV, _kSectionPadH, _kSectionPadV),
        child: child,
      ),
    );
  }
}

// ─── 推荐区：类型 B 贴纸人物卡（阴影、圆角、两卡并排）────────────────────────────
class _PeopleSection extends StatelessWidget {
  const _PeopleSection({required this.onNavigate});

  final void Function(String path) onNavigate;

  @override
  Widget build(BuildContext context) {
    final list = kHomePeople.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.eco_rounded, size: 18.sp, color: AppColors.primary),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                '享梦游种草官',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => onNavigate('/home/seed-list'),
              child: Text(
                '更多>',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: _kCardGap),
        Row(
          children: [
            for (int i = 0; i < list.length; i++) ...[
              if (i > 0) SizedBox(width: _kCardGap),
              Expanded(
                child: _PersonStickerCard(
                  person: list[i],
                  onTap: () => onNavigate('/blog/${list[i].id}'),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// 类型 B：贴纸人物卡（阴影、圆角 14、图略突出）
class _PersonStickerCard extends StatelessWidget {
  const _PersonStickerCard({required this.person, required this.onTap});

  final HomePersonItem person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppShadow.cardElevated,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppNetworkImage(
                  imageUrl: person.avatarUrl,
                  width: double.infinity,
                  height: 88.h,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 12.sp, color: AppColors.textTertiary),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      person.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 亲子活动：横滑卡片，上图下文 + 渐变遮罩 + 标题/副标题/城市 ─────────────────────
class _FamilyActivitiesSection extends StatelessWidget {
  const _FamilyActivitiesSection({required this.onNavigate});

  final void Function(String path) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.child_care_rounded, size: 18.sp, color: AppColors.accentGold),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                '亲子活动',
                style: GoogleFonts.zcoolKuaiLe(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => onNavigate('/home/child-activity-list'),
              child: Text(
                '查看更多',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: _kFamilyCardHeight.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: _kSectionPadH),
            itemCount: kHomeFamilyActivities.length,
            itemBuilder: (context, index) {
              final a = kHomeFamilyActivities[index];
              return Padding(
                padding: EdgeInsets.only(right: _kCardGap),
                child: _FamilyMiniPosterCard(
                  item: a,
                  index: index,
                  onTap: () => onNavigate('/activity/${a.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const double _kFamilyCardHeight = 164;
const double _kFamilyCardWidth = 112;

/// 亲子活动 · 竖版卡片：图片 + 底部渐变 + 标题/副标题/城市标签
class _FamilyMiniPosterCard extends StatelessWidget {
  const _FamilyMiniPosterCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  final HomeFamilyActivityItem item;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardH = _kFamilyCardHeight.h;
    final imageH = cardH * 0.62;
    final bottomH = cardH * 0.38;
    return _TapScale(
      onTap: onTap,
      child: SizedBox(
        width: _kFamilyCardWidth.w,
        height: cardH,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_kPosterCardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: imageH,
                child: AppNetworkImage(
                  imageUrl: item.imageUrl,
                  width: double.infinity,
                  height: imageH,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: bottomH,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.82),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.zcoolKuaiLe(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.subtitle,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.tag,
                              style: AppTextStyles.overline.copyWith(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (index == 0)
                Positioned(
                  left: 8,
                  top: 8,
                  child: _PosterBadge(label: '推荐', warm: true),
                )
              else if (index == 1)
                Positioned(
                  right: 8,
                  top: 8,
                  child: _PosterBadge(label: '热门', warm: true),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosterBadge extends StatelessWidget {
  const _PosterBadge({required this.label, this.warm = true});
  final String label;
  final bool warm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: warm ? AppColors.homeChipRed.withValues(alpha: 0.95) : AppColors.primary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── 周边活动：类型 C 标签覆盖图（全图 + 热门胶囊 + 底部渐变遮罩 + 白字）────────
class _AroundActivitiesSection extends StatelessWidget {
  const _AroundActivitiesSection({required this.onNavigate});

  final void Function(String path) onNavigate;

  static const _weekdays = ['周四', '周五', '周六', '周日'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.explore_rounded, size: 18.sp, color: AppColors.accentWarm),
            SizedBox(width: 6),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '周边活动',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.homeChipGreen,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '有趣的一天',
                      style: AppTextStyles.overline.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () => onNavigate('/home/nearby-activity-list'),
                child: Text(
                  '查看全部>',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: _kCardGap),
        SizedBox(
          height: 152.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: kHomeAroundActivities.length,
            itemBuilder: (context, index) {
              final a = kHomeAroundActivities[index];
              final weekday = _weekdays[index % _weekdays.length];
              return Padding(
                padding: EdgeInsets.only(right: _kCardGap),
                child: _CardTypeC(
                  item: a,
                  weekday: weekday,
                  onTap: () => onNavigate('/activity/${a.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 类型 C：全图 + 左上热门胶囊 + 底部渐变遮罩 + 白色标题/日期
class _CardTypeC extends StatelessWidget {
  const _CardTypeC({
    required this.item,
    required this.weekday,
    required this.onTap,
  });

  final HomeAroundActivityItem item;
  final String weekday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width * 0.48;
    return _TapScale(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        height: 152.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_kCardRadius),
            boxShadow: AppShadow.cardElevated,
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
                fadeInDuration: const Duration(milliseconds: 300),
              ),
              if (item.hot)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.homeChipRed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '热门',
                      style: AppTextStyles.overline.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 24.h, 10, 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.75),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${item.date} · ${item.location} · $weekday',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TapScale extends StatefulWidget {
  const _TapScale({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _controller.forward(),
      onPointerUp: (_) => _controller.reverse(),
      onPointerCancel: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, c) => Transform.scale(scale: _scale.value, child: c),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: widget.child,
        ),
      ),
    );
  }
}
