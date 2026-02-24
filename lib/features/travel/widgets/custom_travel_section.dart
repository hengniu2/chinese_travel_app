import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/app_colors.dart';
import '../../../shared/design_system/travel_typography.dart';
import '../../../shared/design_system/personal_team_toggle.dart';

/// Custom travel section: visually separated from booking, rounded white card
/// with soft green-yellow gradient accent border. Contains mode switch,
/// destination input, budget slider, style chips, and CTA.
class CustomTravelSection extends StatefulWidget {
  const CustomTravelSection({
    super.key,
    this.onSubmit,
  });

  /// Called when "马上为我定制" is pressed. Passes destination, isTeam, budget range, themes.
  final void Function({
    String? destination,
    required bool isTeam,
    required double budgetMin,
    required double budgetMax,
    required List<String> themes,
  })? onSubmit;

  @override
  State<CustomTravelSection> createState() => _CustomTravelSectionState();
}

class _CustomTravelSectionState extends State<CustomTravelSection> {
  static const double _borderRadius = 8;
  static const double _borderWidth = 2;
  static const Color _greenStart = Color(0xFFC5E1A5);
  static const Color _yellowEnd = Color(0xFFFFF176);
  static const Color _fieldBg = Color(0xFFF5F5F5);
  static const Color _sliderLime = Color(0xFFD4EE9E);
  static const Color _sliderJade = Color(0xFF7CB87C);
  static const double _budgetMin = 3000;
  static const double _budgetMax = 50000;

  static const List<_BudgetPreset> _budgetPresets = [
    _BudgetPreset(label: '¥3000', low: 3000, high: 8000),
    _BudgetPreset(label: '¥8000', low: 8000, high: 20000),
    _BudgetPreset(label: '¥20000', low: 20000, high: 40000),
    _BudgetPreset(label: '高端定制', low: 35000, high: 50000),
  ];

  bool _isTeamMode = false;
  final _destinationController = TextEditingController();
  int _placeholderIndex = 0;
  Timer? _placeholderTimer;
  double _budgetLow = _budgetMin;

  static const List<String> _suggestedDestinations = ['日本', '新疆', '泰国', '冰岛'];
  double _budgetHigh = _budgetMax;
  final Set<String> _selectedThemes = {'亲子'};
  bool _stylesExpanded = false;

  static const List<_StyleChipItem> _styleChipsPrimary = [
    _StyleChipItem(emoji: '👶', label: '亲子'),
    _StyleChipItem(emoji: '💑', label: '蜜月'),
    _StyleChipItem(emoji: '💼', label: '商务'),
    _StyleChipItem(emoji: '🧗', label: '探险'),
    _StyleChipItem(emoji: '🚗', label: '自驾'),
    _StyleChipItem(emoji: '🏝', label: '海岛'),
  ];

  static const List<_StyleChipItem> _styleChipsMore = [
    _StyleChipItem(emoji: '🏯', label: '古镇'),
    _StyleChipItem(emoji: '🍜', label: '美食'),
    _StyleChipItem(emoji: '📷', label: '摄影'),
    _StyleChipItem(emoji: '📚', label: '文化'),
  ];

  @override
  void initState() {
    super.initState();
    _placeholderTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() {
          _placeholderIndex = (_placeholderIndex + 1) % _suggestedDestinations.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _placeholderTimer?.cancel();
    _destinationController.dispose();
    super.dispose();
  }

  void _onCtaPressed() {
    widget.onSubmit?.call(
      destination: _destinationController.text.trim().isEmpty
          ? null
          : _destinationController.text.trim(),
      isTeam: _isTeamMode,
      budgetMin: _budgetLow,
      budgetMax: _budgetHigh,
      themes: _selectedThemes.toList(),
    );
  }

  void _toggleTheme(String theme) {
    setState(() {
      if (_selectedThemes.contains(theme)) {
        _selectedThemes.remove(theme);
      } else {
        _selectedThemes.add(theme);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(_borderWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_greenStart, _yellowEnd],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_borderRadius - _borderWidth),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSegmentedSwitch(),
              const SizedBox(height: 20),
              _buildDestinationInput(),
              const SizedBox(height: 20),
              _buildBudgetSlider(),
              const SizedBox(height: 20),
              _buildTravelStyleChips(),
              const SizedBox(height: 20),
              _buildInspirationSection(),
              const SizedBox(height: 20),
              _buildAiPlannerPreview(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildCtaButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedSwitch() {
    return PersonalTeamToggle(
      isPersonal: !_isTeamMode,
      onChanged: (isPersonal) => setState(() => _isTeamMode = !isPersonal),
      personalLabel: '个人定制',
      teamLabel: '团队定制',
    );
  }

  Widget _buildDestinationInput() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _fieldBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: _suggestedDestinations[_placeholderIndex],
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TravelTypography.hint(Colors.grey[600]!, fontSize: 14),
                  ),
                  style: TravelTypography.content(AppColors.textPrimary, fontSize: 14),
                ),
              ),
              Icon(Icons.auto_awesome, size: 18, color: Colors.grey[500]),
            ],
          ),
        ),
        Positioned(
          top: -6,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Text(
              '热门',
              style: TravelTypography.label(Colors.white, fontSize: 10)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '预算范围',
          style: TravelTypography.sectionTitle(Colors.grey[700]!, fontSize: 13),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final thumbRadius = 12.0;
            final trackPadding = thumbRadius;
            final usableWidth = trackWidth - trackPadding * 2;
            final lowPos = trackPadding + (_budgetLow - _budgetMin) / (_budgetMax - _budgetMin) * usableWidth;
            final highPos = trackPadding + (_budgetHigh - _budgetMin) / (_budgetMax - _budgetMin) * usableWidth;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    overlayColor: _sliderJade.withValues(alpha: 0.2),
                    inactiveTrackColor: const Color(0xFFE0E0E0),
                    rangeThumbShape: const _BudgetRangeThumbShape(),
                    rangeTrackShape: const _GradientRangeTrackShape(),
                  ),
                  child: RangeSlider(
                    values: RangeValues(_budgetLow, _budgetHigh),
                    min: _budgetMin,
                    max: _budgetMax,
                    divisions: 94,
                    onChanged: (v) => setState(() {
                      _budgetLow = v.start;
                      _budgetHigh = v.end;
                    }),
                  ),
                ),
                Positioned(
                  left: (lowPos - 22).clamp(4.0, trackWidth - 4),
                  top: -20,
                  child: _BudgetValueBubble(value: _budgetLow),
                ),
                Positioned(
                  left: (highPos - 22).clamp(4.0, trackWidth - 4),
                  top: -20,
                  child: _BudgetValueBubble(value: _budgetHigh),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 5,
          children: _budgetPresets.map((p) {
            final isSelected = (_budgetLow - p.low).abs() < 1000 && (_budgetHigh - p.high).abs() < 1000;
            return _BudgetPresetChip(
              label: p.label,
              selected: isSelected,
              onTap: () => setState(() {
                _budgetLow = p.low;
                _budgetHigh = p.high;
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTravelStyleChips() {
    final l10n = AppLocalizations.of(context);
    final allChips = [
      ..._styleChipsPrimary,
      if (_stylesExpanded) ..._styleChipsMore,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '出行风格',
          style: TravelTypography.sectionTitle(Colors.grey[700]!, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ...allChips.map((item) => _StyleChip(
              emoji: item.emoji,
              label: item.label,
              selected: _selectedThemes.contains(item.label),
              onTap: () => _toggleTheme(item.label),
            )),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _stylesExpanded = !_stylesExpanded),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    _stylesExpanded ? '收起' : (l10n?.plannerViewMore ?? '查看更多'),
                    style: TravelTypography.label(const Color(0xFF7CB87C), fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInspirationSection() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Text('🔥', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '灵感推荐',
                style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 15),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n?.plannerViewMore ?? '查看更多',
                  style: TravelTypography.label(const Color(0xFF7CB87C), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: _inspirationItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _inspirationItems[index];
              return _InspirationCard(
                title: item.title,
                tags: item.tags,
                gradientColors: item.gradientColors,
              );
            },
          ),
        ),
      ],
    );
  }

  static const List<_InspirationItem> _inspirationItems = [
    _InspirationItem(
      title: '云南大理',
      tags: ['苍山洱海', '古镇', '慢生活'],
      gradientColors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
    ),
    _InspirationItem(
      title: '成都美食',
      tags: ['火锅', '熊猫', '川味'],
      gradientColors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
    ),
    _InspirationItem(
      title: '杭州西湖',
      tags: ['西湖十景', '灵隐', '文艺'],
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    _InspirationItem(
      title: '新疆喀纳斯',
      tags: ['湖泊', '雪山', '摄影'],
      gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    _InspirationItem(
      title: '厦门鼓浪屿',
      tags: ['海岛', '文艺', '美食'],
      gradientColors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
    ),
  ];

  Widget _buildAiPlannerPreview() {
    return _AiPlannerPreviewCard(
      onTryNow: () => widget.onSubmit?.call(
        destination: _destinationController.text.trim().isEmpty
            ? null
            : _destinationController.text.trim(),
        isTeam: _isTeamMode,
        budgetMin: _budgetLow,
        budgetMax: _budgetHigh,
        themes: _selectedThemes.toList(),
      ),
    );
  }

  Widget _buildCtaButton() {
    return _CustomTravelCtaButton(
      label: '马上为我定制',
      onPressed: _onCtaPressed,
    );
  }
}

class _AiPlannerPreviewCard extends StatelessWidget {
  const _AiPlannerPreviewCard({this.onTryNow});

  final VoidCallback? onTryNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5FCE8),
            Color(0xFFE8F8E0),
            Color(0xFFF0FDF4),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFFB8E06C).withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7CB87C).withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.smart_toy_rounded,
              size: 28,
              color: Color(0xFF7CB87C),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI 3秒生成专属行程',
                  style: TravelTypography.title(AppColors.textPrimary, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '智能匹配酒店/机票/玩法',
                  style: TravelTypography.hint(AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTryNow,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(color: Color(0xFF7CB87C), width: 1.5),
              foregroundColor: const Color(0xFF5A8A5A),
            ),
            child: Text('立即体验', style: TravelTypography.button(const Color(0xFF5A8A5A), fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _InspirationItem {
  const _InspirationItem({
    required this.title,
    required this.tags,
    required this.gradientColors,
  });
  final String title;
  final List<String> tags;
  final List<Color> gradientColors;
}

class _InspirationCard extends StatelessWidget {
  const _InspirationCard({
    required this.title,
    required this.tags,
    required this.gradientColors,
  });

  final String title;
  final List<String> tags;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
                borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TravelTypography.sectionTitle(Colors.white, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: tags.take(5).map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t,
                            style: TravelTypography.hint(
                              Colors.white.withValues(alpha: 0.95),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetPreset {
  const _BudgetPreset({
    required this.label,
    required this.low,
    required this.high,
  });
  final String label;
  final double low;
  final double high;
}

class _BudgetPresetChip extends StatelessWidget {
  const _BudgetPresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
                borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            label,
            style: TravelTypography.label(
              selected ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 12,
            ).copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class _BudgetValueBubble extends StatelessWidget {
  const _BudgetValueBubble({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        '¥${value.toInt()}',
        style: TravelTypography.content(AppColors.textPrimary, fontSize: 12)
            .copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _BudgetRangeThumbShape extends RangeSliderThumbShape {
  const _BudgetRangeThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool isOnTop = false,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool isPressed = false,
  }) {
    final canvas = context.canvas;
    final radius = 10.0;
    canvas.drawCircle(
      center,
      radius + 2,
      Paint()
        ..color = const Color(0xFF7CB87C).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4EE9E), Color(0xFF7CB87C)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: '¥',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.95),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
}

class _GradientRangeTrackShape extends RoundedRectRangeSliderTrackShape {
  const _GradientRangeTrackShape();

  static const Color _lime = Color(0xFFD4EE9E);
  static const Color _jade = Color(0xFF7CB87C);

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = true,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackHeight = rect.height;
    final radius = Radius.circular(trackHeight / 2);
    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? const Color(0xFFE0E0E0);
    final leftRect = Rect.fromLTRB(rect.left, rect.top, startThumbCenter.dx, rect.bottom);
    final rightRect = Rect.fromLTRB(endThumbCenter.dx, rect.top, rect.right, rect.bottom);
    if (leftRect.width > 0) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(leftRect, radius),
        inactivePaint,
      );
    }
    if (rightRect.width > 0) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(rightRect, radius),
        inactivePaint,
      );
    }
    final activeRect = Rect.fromLTRB(startThumbCenter.dx, rect.top, endThumbCenter.dx, rect.bottom);
    if (activeRect.width > 0) {
      final activeGradient = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_lime, _jade],
        ).createShader(activeRect);
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(activeRect, radius),
        activeGradient,
      );
    }
  }
}

class _StyleChipItem {
  const _StyleChipItem({required this.emoji, required this.label});
  final String emoji;
  final String label;
}

class _StyleChip extends StatelessWidget {
  const _StyleChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const Color _limeBorder = Color(0xFFB8E06C);
  static const Color _limeBg = Color(0xFFF5FCE0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
                borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _limeBg : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(6),
            border: selected ? Border.all(color: _limeBorder, width: 1.5) : Border.all(color: const Color(0xFFE8E8E8), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: selected ? 0.06 : 0.04),
                offset: const Offset(0, 2),
                blurRadius: selected ? 6 : 4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TravelTypography.content(
                  selected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 13,
                ).copyWith(fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTravelCtaButton extends StatefulWidget {
  const _CustomTravelCtaButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<_CustomTravelCtaButton> createState() => _CustomTravelCtaButtonState();
}

class _CustomTravelCtaButtonState extends State<_CustomTravelCtaButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const Color _limeStart = Color(0xFFD4EE9E);
  static const Color _limeEnd = Color(0xFFB8E06C);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.12, end: 0.28).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: _limeEnd.withValues(alpha: _pulseAnimation.value),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Container(
                height: 46,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_limeStart, _limeEnd],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: TravelTypography.button(const Color(0xFF1A1A1A), fontSize: 16)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
