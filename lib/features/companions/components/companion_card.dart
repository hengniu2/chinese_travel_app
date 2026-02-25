import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';
import '../models/companion_list_item.dart';
import '../widgets/rating_widget.dart';
import 'companion_theme.dart';
import 'compact_tag.dart';
import 'gradient_cta_button.dart';
import 'ranking_badge.dart';

/// Card size variant.
enum CompanionCardVariant {
  featured,
  list,
  smart,
}

/// Config for building a companion card. Easy to extend with more options.
class CompanionCardConfig {
  const CompanionCardConfig({
    required this.companion,
    required this.variant,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorited = false,
    this.showHotBadge = false,
    this.isSponsored = false,
    this.theme = CompanionThemeData.defaultTheme,
    this.bookNowLabel = '立即预约',
    this.pricePerDaySuffix = '/天',
    this.serviceCountFormat,
    this.isDarkSurface = false,
  });

  final CompanionListItem companion;
  final CompanionCardVariant variant;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorited;
  final bool showHotBadge;
  final bool isSponsored;
  final CompanionThemeData theme;
  final String bookNowLabel;
  final String pricePerDaySuffix;
  final String Function(int count)? serviceCountFormat;
  /// When true, card uses dark background and light text (for horizontal slides on bright section).
  final bool isDarkSurface;

  int get _displayFavoritesCount =>
      companion.favoritesCount + (isFavorited ? 1 : 0);
}

/// Config-based companion card. Renders featured, list, or smart layout.
class CompanionCard extends StatelessWidget {
  const CompanionCard({
    super.key,
    required this.config,
  });

  final CompanionCardConfig config;

  @override
  Widget build(BuildContext context) {
    switch (config.variant) {
      case CompanionCardVariant.featured:
        return _FeaturedLayout(config: config);
      case CompanionCardVariant.list:
        return _ListLayout(config: config);
      case CompanionCardVariant.smart:
        return _SmartLayout(config: config);
    }
  }
}

// ─── Shared helpers ───

/// Strong price visibility: warm gradient, bold weight (Chinese user psychology).
Widget _gradientPrice(double price,
    {String? unit, double fontSize = 14, required CompanionThemeData theme}) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFFFF8A00), Color(0xFFE85A4A), Color(0xFFD84315)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: Text(
      '¥${price.toStringAsFixed(0)}${unit ?? ''}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
        color: Colors.white,
      ),
    ),
  );
}

Widget _levelBadge(int level, double progress) {
  final clampedLevel = level.clamp(1, 5);
  final clampedProgress = progress.clamp(0.0, 1.0);
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CompactTag(type: CompactTagType.level, value: clampedLevel),
      if (clampedProgress > 0 && clampedLevel < 5) ...[
        const SizedBox(height: 2),
        SizedBox(
          width: 28,
          height: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: LinearProgressIndicator(
              value: clampedProgress,
              backgroundColor: AppColors.textTertiary.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

IconData _tagToIcon(String tag) {
  if (tag.contains('摄影') || tag.contains('跟拍')) return Icons.camera_alt_rounded;
  if (tag.contains('美食')) return Icons.restaurant_rounded;
  if (tag.contains('讲解') || tag.contains('文化')) return Icons.menu_book_rounded;
  if (tag.contains('路线') || tag.contains('规划')) return Icons.route_rounded;
  if (tag.contains('方言') || tag.contains('沟通')) return Icons.translate_rounded;
  if (tag.contains('历史')) return Icons.account_balance_rounded;
  if (tag.contains('园林') || tag.contains('古镇')) return Icons.park_rounded;
  if (tag.contains('夜景')) return Icons.nightlight_rounded;
  return Icons.auto_awesome_rounded;
}

Widget _packagePrices(CompanionListItem c, CompanionThemeData theme,
    {String? pricePerDaySuffix, double fontSize = 11}) {
  final suffix = pricePerDaySuffix ?? '/天';
  if (c.pricePer3h != null) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('3h ',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textTertiary, fontSize: 9)),
        _gradientPrice(c.pricePer3h!, unit: '', fontSize: fontSize, theme: theme),
        Text(' · ',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textTertiary, fontSize: 9)),
        _gradientPrice(c.pricePerDay, unit: suffix, fontSize: fontSize, theme: theme),
      ],
    );
  }
  return _gradientPrice(c.pricePerDay, unit: suffix, fontSize: 13, theme: theme);
}

// ─── Featured layout (compact horizontal card) ───

const double _kFeaturedCardWidth = 124;
const double _kFeaturedAvatarSize = 42;
const double _kCardRadius = 16;

class _FeaturedLayout extends StatelessWidget {
  const _FeaturedLayout({required this.config});

  final CompanionCardConfig config;

  @override
  Widget build(BuildContext context) {
    final c = config.companion;
    final theme = config.theme;
    final slideStyle = config.isDarkSurface;
    final surfaceColor = slideStyle ? AppColors.companionSlideSurface : AppColors.card;
    final borderColor = slideStyle ? AppColors.border.withValues(alpha: 0.7) : AppColors.border;
    final textPrimary = AppColors.textPrimary;
    final textTertiary = AppColors.textTertiary;
    final displayBadges = c.rankBadges.isNotEmpty
        ? c.rankBadges.take(2).toList()
        : <CompanionRankBadge>[
            if (c.isVerified) CompanionRankBadge.verified,
          ];
    final useSenior = c.rankBadges.isEmpty && c.experienceYears >= 5;
    final skills = c.tags.take(3).toList();

    return AppTapScale(
      onTap: config.onTap,
      enableHover: kIsWeb,
      child: Container(
        width: _kFeaturedCardWidth,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(_kCardRadius),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  Hero(
                    tag: 'companion_avatar_${c.id}',
                    child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: ClipOval(
                      child: c.avatarUrl.isNotEmpty
                          ? Image.network(
                              c.avatarUrl,
                              width: _kFeaturedAvatarSize,
                              height: _kFeaturedAvatarSize,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _avatarPlaceholder(c.name, _kFeaturedAvatarSize),
                            )
                          : _avatarPlaceholder(c.name, _kFeaturedAvatarSize),
                    ),
                  ),
                ),
                if (c.isOnline) _onlineDot(),
                if (config.showHotBadge)
                  Positioned(
                      top: -1,
                      right: -1,
                      child: CompactTag(type: CompactTagType.hot)),
                if (config.isSponsored)
                  Positioned(
                    top: -1,
                    left: -1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '广告',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (c.achievementIcons.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: c.achievementIcons
                    .take(3)
                    .map((icon) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Icon(icon, size: 10, color: AppColors.accentGold),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    c.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ...displayBadges
                            .expand((b) => [const SizedBox(width: 2), RankingBadge(badge: b, theme: theme)]),
                        if (useSenior) ...[
                          const SizedBox(width: 2),
                          CompactTag(type: CompactTagType.senior),
                        ],
                        if (c.isTrending) ...[
                          const SizedBox(width: 2),
                          CompactTag(type: CompactTagType.trending),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _levelBadge(c.level, c.levelProgress),
                  const SizedBox(width: 6),
                  if (config.onFavoriteTap != null)
                    _FavoriteChip(
                      isFavorited: config.isFavorited,
                      count: config._displayFavoritesCount,
                      onTap: config.onFavoriteTap!,
                      size: 12,
                    )
                  else if (c.favoritesCount > 0)
                    _staticFavorites(c.favoritesCount),
                  if (c.viewCount > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '${c.viewCount}浏览',
                      style: AppTextStyles.caption.copyWith(
                        color: textTertiary,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 1),
            RatingWidget(
              rating: c.rating,
              iconSize: 10,
              fontSize: 10,
              suffix: '${c.reviewCount}条评价',
              starColor: AppColors.accentGold,
            ),
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < skills.length && i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Icon(
                      _tagToIcon(skills[i]),
                      size: 10,
                      color: textTertiary,
                    ),
                  ],
                ],
              ),
            ],
            if (c.discountTag != null || c.hasGroupDiscount) ...[
              const SizedBox(height: 2),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 2,
                children: [
                  if (c.discountTag != null)
                    CompactTag(
                      type: c.discountTag == CompanionDiscountTag.limitedTime
                          ? CompactTagType.discountLimited
                          : CompactTagType.discountToday,
                    ),
                  if (c.hasGroupDiscount)
                    CompactTag(type: CompactTagType.groupDiscount),
                ],
              ),
            ],
            _packagePrices(c, theme, pricePerDaySuffix: config.pricePerDaySuffix),
            if (c.spotsLeftToday != null && c.spotsLeftToday! <= 3) ...[
              const SizedBox(height: 1),
              Center(
                  child: CompactTag(
                      type: CompactTagType.urgency, value: c.spotsLeftToday)),
            ],
            if (c.responseTimeMinutes != null &&
                c.responseTimeMinutes! <= 10) ...[
              const SizedBox(height: 1),
              Center(
                child: CompactTag(
                    type: CompactTagType.fastResponse,
                    value: c.responseTimeMinutes),
              ),
            ],
            const SizedBox(height: 3),
            SizedBox(
              width: double.infinity,
              child: GradientCTAButton(
                label: config.bookNowLabel,
                onTap: config.onTap,
                theme: theme,
                fontSize: 12,
                compact: true,
              ),
            ),
            const SizedBox(height: 2),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 2,
              children: [
                CompactTag(type: CompactTagType.trustPlatform, compact: true),
                if (c.isVerified)
                  CompactTag(type: CompactTagType.trustVerified, compact: true),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _onlineDot() {
    final ringColor = config.isDarkSurface
        ? AppColors.companionSlideSurface
        : AppColors.card;
    return Positioned(
      right: 2,
      bottom: 2,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          border: Border.all(color: ringColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.7),
              blurRadius: 4,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _staticFavorites(int count) {
    final isHighlight = count > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite_border_rounded,
          size: 10,
          color: isHighlight ? AppColors.accentWarm : AppColors.textTertiary,
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: AppTextStyles.caption.copyWith(
            color: isHighlight ? AppColors.accentWarm : AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Placeholder for favorite chip with animation (simplified: no animation in component, page can wrap)
Widget _FavoriteChip(
    {required bool isFavorited, required int count, required VoidCallback onTap, double size = 14}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: size,
          color: isFavorited ? AppColors.accentWarm : AppColors.textTertiary,
        ),
        if (count > 0) ...[
          const SizedBox(width: 2),
          Text(
            '$count',
            style: AppTextStyles.caption.copyWith(
              color: isFavorited ? AppColors.accentWarm : AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _avatarPlaceholder(String name, double size) {
  final initial = name.isNotEmpty ? name[0] : '?';
  final hue = (name.hashCode % 360).toDouble();
  final color = HSLColor.fromAHSL(1, hue, 0.4, 0.65).toColor();
  return Container(
    width: size,
    height: size,
    color: color.withValues(alpha: 0.3),
    child: Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.45,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ),
  );
}

// ─── List layout (full-width row card) ───

class _ListLayout extends StatelessWidget {
  const _ListLayout({required this.config});

  final CompanionCardConfig config;

  static const double _avatarSize = 72;

  @override
  Widget build(BuildContext context) {
    final c = config.companion;
    final theme = config.theme;
    final serviceText = config.serviceCountFormat?.call(c.completedOrders) ??
        '已服务${c.completedOrders}次';

    return AppTapScale(
      onTap: config.onTap,
      enableHover: kIsWeb,
      child: Container(
        decoration: BoxDecoration(
          color: c.isSponsored
              ? AppColors.accentGold.withValues(alpha: 0.04)
              : AppColors.card,
          borderRadius: BorderRadius.circular(_kCardRadius),
          border: Border.all(
            color: c.isSponsored
                ? AppColors.accentGold.withValues(alpha: 0.2)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomRight,
                        children: [
                          Hero(
                            tag: 'companion_avatar_${c.id}',
                            child: ClipOval(
                              child: c.avatarUrl.isNotEmpty
                                  ? Image.network(
                                      c.avatarUrl,
                                      width: _avatarSize,
                                      height: _avatarSize,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _avatarPlaceholder(c.name, _avatarSize),
                                    )
                                  : _avatarPlaceholder(c.name, _avatarSize),
                            ),
                          ),
                          if (c.isOnline)
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                  border: Border.all(
                                      color: AppColors.card, width: 1.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (c.achievementIcons.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: c.achievementIcons
                              .take(3)
                              .map((icon) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 1),
                                    child: Icon(icon,
                                        size: 12, color: AppColors.accentGold),
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                c.name,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...c.rankBadges.take(3).expand((b) => [
                                          const SizedBox(width: 4),
                                          RankingBadge(badge: b, theme: theme),
                                        ]),
                                    if (c.rankBadges.isEmpty && c.isVerified) ...[
                                      const SizedBox(width: 4),
                                      RankingBadge(
                                          badge: CompanionRankBadge.verified,
                                          theme: theme),
                                    ],
                                    if (c.rankBadges.isEmpty &&
                                        c.experienceYears >= 5) ...[
                                      const SizedBox(width: 4),
                                      CompactTag(type: CompactTagType.senior),
                                    ],
                                    if (c.isTrending) ...[
                                      const SizedBox(width: 4),
                                      CompactTag(type: CompactTagType.trending),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _levelBadge(c.level, c.levelProgress),
                              if (c.favoritesCount > 0 ||
                                  c.viewCount > 0) ...[
                                const SizedBox(width: 8),
                                if (config.onFavoriteTap != null)
                                  _FavoriteChip(
                                    isFavorited: config.isFavorited,
                                    count: config._displayFavoritesCount,
                                    onTap: config.onFavoriteTap!,
                                    size: 14,
                                  )
                                else
                                  _staticFavoritesList(c.favoritesCount),
                                if (c.viewCount > 0) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '${c.viewCount}浏览',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        if (c.discountTag != null || c.hasGroupDiscount) ...[
                          const SizedBox(height: 2),
                          Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              if (c.discountTag != null)
                                CompactTag(
                                  type: c.discountTag ==
                                          CompanionDiscountTag.limitedTime
                                      ? CompactTagType.discountLimited
                                      : CompactTagType.discountToday,
                                ),
                              if (c.hasGroupDiscount)
                                CompactTag(type: CompactTagType.groupDiscount),
                            ],
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          c.cityRank != null
                              ? '#${c.cityRank} ${c.city} · ${c.experienceYears}年经验'
                              : '${c.city} · ${c.experienceYears}年经验',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (c.tags.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.5),
                ),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: c.tags.take(4).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_tagToIcon(tag),
                              size: 10, color: AppColors.textTertiary),
                          const SizedBox(width: 3),
                          Text(
                            tag,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warmBackground.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(_kCardRadius),
                  bottomRight: Radius.circular(_kCardRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      RatingWidget(
                        rating: c.rating,
                        iconSize: 11,
                        fontSize: 10,
                        suffix: '${c.reviewCount}条评价',
                        starColor: AppColors.accentGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        serviceText,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (c.pricePer3h != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('3h ',
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontSize: 10)),
                            _gradientPrice(c.pricePer3h!, unit: '',
                                fontSize: 15, theme: theme),
                            Text(' · ',
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontSize: 10)),
                            _gradientPrice(c.pricePerDay,
                                unit: config.pricePerDaySuffix,
                                fontSize: 17,
                                theme: theme),
                          ],
                        )
                      else
                        _gradientPrice(c.pricePerDay,
                            unit: config.pricePerDaySuffix,
                            fontSize: 20,
                            theme: theme),
                      const SizedBox(width: 8),
                      if (c.spotsLeftToday != null &&
                          c.spotsLeftToday! <= 3)
                        CompactTag(
                            type: CompactTagType.urgency,
                            value: c.spotsLeftToday),
                      if (c.responseTimeMinutes != null &&
                          c.responseTimeMinutes! <= 10) ...[
                        const SizedBox(width: 6),
                        CompactTag(
                            type: CompactTagType.fastResponse,
                            value: c.responseTimeMinutes),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: GradientCTAButton(
                      label: config.bookNowLabel,
                      onTap: config.onTap,
                      theme: theme,
                      fontSize: 13,
                      compact: true,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CompactTag(type: CompactTagType.trustPlatform),
                      if (c.isVerified) ...[
                        const SizedBox(width: 8),
                        CompactTag(type: CompactTagType.trustVerified),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _staticFavoritesList(int count) {
    final isHighlight = count > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite_border_rounded,
          size: 12,
          color: isHighlight ? AppColors.accentWarm : AppColors.textTertiary,
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: AppTextStyles.caption.copyWith(
            color: isHighlight ? AppColors.accentWarm : AppColors.textTertiary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── Smart layout (premium larger card) ───

class _SmartLayout extends StatelessWidget {
  const _SmartLayout({required this.config});

  final CompanionCardConfig config;

  static const double _avatarSize = 52;
  static const double _cardWidth = 156;

  @override
  Widget build(BuildContext context) {
    final c = config.companion;
    final theme = config.theme;
    final slideStyle = config.isDarkSurface;
    final surfaceColor = slideStyle ? AppColors.companionSlideSurface : AppColors.card;
    final borderColor = slideStyle
        ? AppColors.border.withValues(alpha: 0.7)
        : AppColors.accentGold.withValues(alpha: 0.2);
    final avatarBorderColor = slideStyle
        ? AppColors.border.withValues(alpha: 0.8)
        : AppColors.accentGold.withValues(alpha: 0.35);
    final textPrimary = AppColors.textPrimary;
    final textTertiary = AppColors.textTertiary;
    final displayBadges = c.rankBadges.isNotEmpty
        ? c.rankBadges.take(2).toList()
        : <CompanionRankBadge>[
            if (c.isVerified) CompanionRankBadge.verified,
          ];
    final useSenior = c.rankBadges.isEmpty && c.experienceYears >= 5;
    final skills = c.tags.take(3).toList();

    return AppTapScale(
      onTap: config.onTap,
      enableHover: kIsWeb,
      child: Container(
        width: _cardWidth,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withValues(alpha: 0.08),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
            const BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: 'companion_avatar_${c.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: avatarBorderColor,
                          width: 1.5),
                    ),
                    child: ClipOval(
                      child: c.avatarUrl.isNotEmpty
                          ? Image.network(
                              c.avatarUrl,
                              width: _avatarSize,
                              height: _avatarSize,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _avatarPlaceholder(c.name, _avatarSize),
                            )
                          : _avatarPlaceholder(c.name, _avatarSize),
                    ),
                  ),
                ),
                if (c.isOnline) _onlineDot(),
              ],
            ),
            if (c.achievementIcons.isNotEmpty) ...[
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: c.achievementIcons
                    .take(3)
                    .map((icon) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Icon(icon, size: 11, color: AppColors.accentGold),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    c.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ...displayBadges
                            .expand((b) => [const SizedBox(width: 2), RankingBadge(badge: b, theme: theme)]),
                        if (useSenior) ...[
                          const SizedBox(width: 2),
                          CompactTag(type: CompactTagType.senior),
                        ],
                        if (c.isTrending) ...[
                          const SizedBox(width: 2),
                          CompactTag(type: CompactTagType.trending),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _levelBadge(c.level, c.levelProgress),
                  const SizedBox(width: 6),
                  if (config.onFavoriteTap != null)
                    _FavoriteChip(
                      isFavorited: config.isFavorited,
                      count: config._displayFavoritesCount,
                      onTap: config.onFavoriteTap!,
                      size: 12,
                    )
                  else if (c.favoritesCount > 0)
                    _staticFavorites(c.favoritesCount),
                  if (c.viewCount > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      '${c.viewCount}浏览',
                      style: AppTextStyles.caption.copyWith(
                        color: textTertiary,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 3),
            RatingWidget(
              rating: c.rating,
              iconSize: 11,
              fontSize: 11,
              suffix: '${c.reviewCount}条',
              starColor: AppColors.textTertiary,
            ),
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < skills.length && i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Icon(
                      _tagToIcon(skills[i]),
                      size: 11,
                      color: textTertiary,
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 3),
            _packagePrices(c, theme,
                pricePerDaySuffix: config.pricePerDaySuffix, fontSize: 11),
            if (c.spotsLeftToday != null && c.spotsLeftToday! <= 3) ...[
              const SizedBox(height: 2),
              Center(
                  child: CompactTag(
                      type: CompactTagType.urgency, value: c.spotsLeftToday)),
            ],
            if (c.responseTimeMinutes != null &&
                c.responseTimeMinutes! <= 10) ...[
              const SizedBox(height: 2),
              Center(
                child: CompactTag(
                    type: CompactTagType.fastResponse,
                    value: c.responseTimeMinutes),
              ),
            ],
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: GradientCTAButton(
                label: config.bookNowLabel,
                onTap: config.onTap,
                theme: theme,
                fontSize: 13,
                compact: true,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CompactTag(type: CompactTagType.trustPlatform, compact: true),
                if (c.isVerified) ...[
                  const SizedBox(width: 4),
                  CompactTag(type: CompactTagType.trustVerified, compact: true),
                ],
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _onlineDot() {
    final ringColor = config.isDarkSurface
        ? AppColors.companionSlideSurface
        : AppColors.card;
    return Positioned(
      right: 2,
      bottom: 2,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
          border: Border.all(color: ringColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.7),
              blurRadius: 4,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _staticFavorites(int count) {
    final isHighlight = count > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.favorite_border_rounded,
          size: 10,
          color: isHighlight ? AppColors.accentWarm : AppColors.textTertiary,
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: AppTextStyles.caption.copyWith(
            color: isHighlight ? AppColors.accentWarm : AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
