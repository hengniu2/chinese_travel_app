import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';
import '../data/travel_assets.dart';
import '../models/planner_request.dart';
import '../widgets/ai_branding.dart';

/// Step 1: 目的地选择
class PlannerStepDestination extends StatelessWidget {
  const PlannerStepDestination({
    required this.request,
    required this.onChanged,
  });

  final PlannerRequest request;
  final void Function(PlannerRequest) onChanged;

  static const _destinationsDefault = [
    '杭州', '成都', '云南', '北京', '厦门', '日本', '泰国', '新疆', '西安', '桂林',
  ];

  List<String> get _destinations =>
      request.themes.isNotEmpty
          ? ThemeDestinations.forThemes(request.themes)
          : _destinationsDefault;

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations;
    return _StepScaffold(
      icon: Icons.place_rounded,
      title: '目的地选择',
      subtitle: request.themes.isNotEmpty ? '根据你的选择智能推荐' : '你想去哪里？',
      subtitleTrailing: request.themes.isNotEmpty ? const AiSparkleIcon(size: 14) : null,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: destinations.map((d) {
          final selected = request.destination == d;
          return _SelectChip(
            label: d,
            selected: selected,
            onTap: () => onChanged(request.copyWith(destination: d)),
          );
        }).toList(),
      ),
    );
  }
}

/// Step 2: 出行时间
class PlannerStepDates extends StatefulWidget {
  const PlannerStepDates({
    required this.request,
    required this.onChanged,
  });

  final PlannerRequest request;
  final void Function(PlannerRequest) onChanged;

  @override
  State<PlannerStepDates> createState() => _PlannerStepDatesState();
}

class _PlannerStepDatesState extends State<PlannerStepDates> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    _syncFromRequest();
  }

  @override
  void didUpdateWidget(PlannerStepDates oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request.dates != widget.request.dates) _syncFromRequest();
  }

  void _syncFromRequest() {
    final now = DateTime.now();
    _start = widget.request.dates?.start ?? now;
    _end = widget.request.dates?.end ?? now.add(const Duration(days: 3));
  }

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.calendar_today_rounded,
      title: '出行时间',
      subtitle: '选择出发与返程日期',
      child: Column(
        children: [
          _DateChip(
            label: '出发',
            date: _start,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _start,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && mounted) {
                setState(() {
                  _start = picked;
                  if (_end.isBefore(_start)) _end = _start.add(const Duration(days: 3));
                  widget.onChanged(widget.request.copyWith(dates: DateTimeRange(start: _start, end: _end)));
                });
              }
            },
          ),
          const SizedBox(height: 10),
          _DateChip(
            label: '返程',
            date: _end,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _end,
                firstDate: _start,
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && mounted) {
                setState(() {
                  _end = picked;
                  widget.onChanged(widget.request.copyWith(dates: DateTimeRange(start: _start, end: _end)));
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Step 3: 预算区间
class PlannerStepBudget extends StatefulWidget {
  const PlannerStepBudget({
    required this.request,
    required this.onChanged,
  });

  final PlannerRequest request;
  final void Function(PlannerRequest) onChanged;

  @override
  State<PlannerStepBudget> createState() => _PlannerStepBudgetState();
}

class _PlannerStepBudgetState extends State<PlannerStepBudget> {
  static const _min = 3000.0;
  static const _max = 50000.0;
  late double _low;
  late double _high;

  @override
  void initState() {
    super.initState();
    _syncFromRequest();
  }

  @override
  void didUpdateWidget(PlannerStepBudget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request.budgetRange != widget.request.budgetRange) _syncFromRequest();
  }

  void _syncFromRequest() {
    _low = widget.request.budgetRange?.min ?? 8000;
    _high = widget.request.budgetRange?.max ?? 20000;
  }

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.account_balance_wallet_rounded,
      title: '预算区间',
      subtitle: '人均预算范围（元）',
      child: Column(
        children: [
          RangeSlider(
            values: RangeValues(_low, _high),
            min: _min,
            max: _max,
            divisions: 94,
            activeColor: TravelDesignTokens.primary,
            onChanged: (v) {
              setState(() {
                _low = v.start;
                _high = v.end;
                widget.onChanged(widget.request.copyWith(
                  budgetRange: PriceRange(min: _low, max: _high),
                ));
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('¥${_low.toInt()}', style: TravelTypography.content(AppColors.textPrimary, fontSize: 14)),
              Text('¥${_high.toInt()}', style: TravelTypography.content(AppColors.textPrimary, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Step 4: 出行偏好
class PlannerStepPreferences extends StatelessWidget {
  const PlannerStepPreferences({
    required this.request,
    required this.onChanged,
  });

  final PlannerRequest request;
  final void Function(PlannerRequest) onChanged;

  static const _themes = ['文化', '自然', '探险', '美食', '亲子', '摄影', '古镇', '海岛'];

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.favorite_rounded,
      title: '出行偏好',
      subtitle: '选择你喜欢的旅行风格',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _themes.map((t) {
          final selected = request.themes.contains(t);
          return _SelectChip(
            label: t,
            selected: selected,
            onTap: () {
              final next = selected
                  ? request.themes.where((x) => x != t).toList()
                  : [...request.themes, t];
              onChanged(request.copyWith(themes: next));
            },
          );
        }).toList(),
      ),
    );
  }
}

/// Step 5: 人数信息
class PlannerStepTravelers extends StatelessWidget {
  const PlannerStepTravelers({
    required this.request,
    required this.onChanged,
  });

  final PlannerRequest request;
  final void Function(PlannerRequest) onChanged;

  @override
  Widget build(BuildContext context) {
    final count = request.travelers ?? 2;
    return _StepScaffold(
      icon: Icons.people_rounded,
      title: '人数信息',
      subtitle: '出行人数',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: count > 1 ? () => onChanged(request.copyWith(travelers: count - 1)) : null,
            color: TravelDesignTokens.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '$count 人',
              style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 24),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: count < 9 ? () => onChanged(request.copyWith(travelers: count + 1)) : null,
            color: TravelDesignTokens.primary,
          ),
        ],
      ),
    );
  }
}

/// Step 6: 生成专属方案
class PlannerStepGenerate extends StatelessWidget {
  const PlannerStepGenerate({
    required this.request,
    required this.formState,
    required this.onGenerate,
  });

  final PlannerRequest request;
  final dynamic formState;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.auto_awesome_rounded,
      title: '生成专属方案',
      subtitle: 'AI 将为你定制行程',
      subtitleTrailing: const AiSparkleIcon(size: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(icon: Icons.place_outlined, label: '目的地', value: request.destination ?? '—'),
          const SizedBox(height: 8),
          _SummaryRow(
            icon: Icons.calendar_today,
            label: '时间',
            value: request.dates != null
                ? '${request.dates!.start.toString().substring(0, 10)} — ${request.dates!.end.toString().substring(0, 10)}'
                : '—',
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            icon: Icons.account_balance_wallet_outlined,
            label: '预算',
            value: request.budgetRange != null
                ? '¥${request.budgetRange!.min?.toInt()} — ¥${request.budgetRange!.max?.toInt()}'
                : '—',
          ),
          const SizedBox(height: 8),
          _SummaryRow(icon: Icons.people_outline, label: '人数', value: '${request.travelers ?? '—'} 人'),
          if (request.themes.isNotEmpty) ...[
            const SizedBox(height: 8),
            _SummaryRow(icon: Icons.favorite_border, label: '偏好', value: request.themes.join(' · ')),
          ],
          const SizedBox(height: 16),
          const Center(child: AiBranding(iconSize: 12, fontSize: 10)),
        ],
      ),
    );
  }
}

// ─── Shared step UI ────────────────────────────────────────────────────────

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.subtitleTrailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? subtitleTrailing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TravelDesignTokens.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: TravelDesignTokens.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 18),
          ),
          const SizedBox(height: 4),
          subtitleTrailing != null
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TravelTypography.hint(AppColors.textTertiary, fontSize: 14),
                      ),
                    ),
                    subtitleTrailing!,
                  ],
                )
              : Text(
                  subtitle,
                  style: TravelTypography.hint(AppColors.textTertiary, fontSize: 14),
                ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      pressedScale: 0.98,
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? TravelDesignTokens.primary.withValues(alpha: 0.2) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? TravelDesignTokens.primary : AppColors.divider,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TravelTypography.content(
              selected ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 14,
            ).copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
      ),
    ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      pressedScale: 0.98,
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: TravelDesignTokens.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TravelTypography.hint(AppColors.textTertiary, fontSize: 12)),
                    Text(
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                      style: TravelTypography.content(AppColors.textPrimary, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textTertiary),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(label, style: TravelTypography.hint(AppColors.textTertiary, fontSize: 13)),
        ),
        Expanded(
          child: Text(
            value,
            style: TravelTypography.content(AppColors.textPrimary, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
