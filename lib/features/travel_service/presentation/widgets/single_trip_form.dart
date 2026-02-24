import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../theme/luxury_travel_theme.dart';

/// Full one-way (单程) booking form — luxury theme: 出发/到达, date chips, passenger, cabin, search.
class SingleTripForm extends StatefulWidget {
  const SingleTripForm({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  State<SingleTripForm> createState() => _SingleTripFormState();
}

class _SingleTripFormState extends State<SingleTripForm>
    with SingleTickerProviderStateMixin {
  static const double _fieldRadius = 18;
  static const double _verticalGap = 18;
  static Color get _fieldBg => LuxuryTravelTheme.surfaceMuted;
  static Color get _unselectedGrey => LuxuryTravelTheme.textTertiary;
  static Color get _warmCard => LuxuryTravelTheme.cardBackground;
  static const List<String> _cabinLabels = ['经济', '商务', '头等'];

  late AnimationController _swapRotationController;

  String _departure = '北京';
  String _arrival = '上海';
  DateTime? _selectedDate;
  int _adults = 1;
  int _children = 0;
  int _cabinIndex = 0;

  @override
  void initState() {
    super.initState();
    _swapRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _swapRotationController.dispose();
    super.dispose();
  }

  void _swapCities() {
    setState(() {
      final t = _departure;
      _departure = _arrival;
      _arrival = t;
    });
    _swapRotationController.forward(from: 0);
  }

  DateTime _today() => DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _tomorrow() => _today().add(const Duration(days: 1));
  DateTime _thisWeekend() {
    final today = _today();
    final weekday = today.weekday;
    final daysUntilSaturday = DateTime.saturday - weekday;
    return today.add(Duration(
        days: daysUntilSaturday <= 0 ? daysUntilSaturday + 7 : daysUntilSaturday));
  }

  String _formatDate(DateTime d) => '${d.month}月${d.day}日';
  bool _dateEquals(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _openPassengerSheet() {
    showAppBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _PassengerSheet(
        adults: _adults,
        children: _children,
        onConfirm: (a, c) {
          setState(() {
            _adults = a;
            _children = c;
          });
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  void _onSearch() {
    context.analytics.logEvent(SearchClickEvent(
      departure: _departure,
      arrival: _arrival,
      tripType: 'single',
    ));
    context.push('/travel-service/flight-result');
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 360;
    final horizontalPadding = isCompact ? 16.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: widget.scrollController,
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 12, horizontalPadding, 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCityRow(),
                      SizedBox(height: _verticalGap),
                      _buildDateSection(),
                      SizedBox(height: _verticalGap),
                      _buildPassengerRow(),
                      SizedBox(height: _verticalGap),
                      _buildCabinSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _buildSearchButton(),
      ],
    );
  }

  static Border get _fieldBorder => Border.all(
    color: LuxuryTravelTheme.border,
    width: 1.5,
  );

  /// 1. 出发城市 / 2. 到达城市 with swap (rotation animation)
  Widget _buildCityRow() {
    return Container(
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(_fieldRadius),
        border: _fieldBorder,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(_fieldRadius),
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.flight_takeoff_rounded,
                  size: 24, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '出发城市',
                      style: TextStyle(
                          fontSize: 12, color: LuxuryTravelTheme.textTertiary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _departure,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: LuxuryTravelTheme.darkText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _swapCities,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: RotationTransition(
                      turns: Tween<double>(begin: 0, end: 0.5).animate(
                        CurvedAnimation(
                          parent: _swapRotationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Icon(
                        Icons.swap_vert_rounded,
                        size: 28,
                        color: LuxuryTravelTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '到达城市',
                      style: TextStyle(
                          fontSize: 12, color: LuxuryTravelTheme.textTertiary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _arrival,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: LuxuryTravelTheme.darkText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// 3. 日期 with chips: 今天, 明天, 本周末
  Widget _buildDateSection() {
    final today = _today();
    final tomorrow = _tomorrow();
    final weekend = _thisWeekend();
    final selected = _selectedDate ?? today;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 20, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                '日期',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: LuxuryTravelTheme.textSecondary),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _DateChip(
              label: '今天',
              selected: _selectedDate == null || _dateEquals(selected, today),
              onTap: () => setState(() => _selectedDate = today),
            ),
            _DateChip(
              label: '明天',
              selected: _dateEquals(selected, tomorrow),
              onTap: () => setState(() => _selectedDate = tomorrow),
            ),
            _DateChip(
              label: '本周末',
              selected: _dateEquals(selected, weekend),
              onTap: () => setState(() => _selectedDate = weekend),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _fieldBg,
            borderRadius: BorderRadius.circular(_fieldRadius),
            border: _fieldBorder,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selected,
                  firstDate: today,
                  lastDate: today.add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              borderRadius: BorderRadius.circular(_fieldRadius),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      _formatDate(selected),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: LuxuryTravelTheme.darkText,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_month_rounded,
                        size: 22, color: LuxuryTravelTheme.textTertiary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 4. 乘客数量 — opens bottom sheet counter
  Widget _buildPassengerRow() {
    final subtitle = _children > 0
        ? '$_adults 成人 · $_children 儿童'
        : '$_adults 人';

    return Container(
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(_fieldRadius),
        border: _fieldBorder,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openPassengerSheet,
          borderRadius: BorderRadius.circular(_fieldRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 24, color: LuxuryTravelTheme.textSecondary),
                const SizedBox(width: 14),
                Text(
                  '乘客数量',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: LuxuryTravelTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: LuxuryTravelTheme.darkText,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 26, color: LuxuryTravelTheme.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 5. 舱位 — segmented: 经济 / 商务 / 头等
  Widget _buildCabinSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.airline_seat_recline_extra_rounded,
                  size: 20, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                '舱位',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: LuxuryTravelTheme.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _fieldBg,
            borderRadius: BorderRadius.circular(16),
            border: _fieldBorder,
          ),
          child: Row(
            children: List.generate(3, (i) {
              final selected = _cabinIndex == i;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _cabinIndex = i),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? _warmCard : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.07),
                                  offset: const Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        _cabinLabels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? LuxuryTravelTheme.darkText
                              : _unselectedGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// 6. 搜索 — gold background, black text, subtle shadow
  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onSearch,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFC6A769),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.08),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '搜索',
              style: LuxuryTravelTheme.buttonLabel(Colors.black).copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

// ——— Helpers ———

class _DateChip extends StatelessWidget {
  const _DateChip({
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
      color: selected ? LuxuryTravelTheme.primaryGold.withValues(alpha: 0.15) : LuxuryTravelTheme.surfaceMuted,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: selected ? Border.all(color: LuxuryTravelTheme.primaryGold, width: 2) : null,
          ),
          child: Text(
            label,
            style: LuxuryTravelTheme.bodyMedium(selected ? LuxuryTravelTheme.darkText : LuxuryTravelTheme.textSecondary)
                .copyWith(fontSize: 15, fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class _PassengerSheet extends StatefulWidget {
  const _PassengerSheet({
    required this.adults,
    required this.children,
    required this.onConfirm,
  });

  final int adults;
  final int children;
  final void Function(int adults, int children) onConfirm;

  @override
  State<_PassengerSheet> createState() => _PassengerSheetState();
}

class _PassengerSheetState extends State<_PassengerSheet> {
  late int _adults;
  late int _children;

  @override
  void initState() {
    super.initState();
    _adults = widget.adults;
    _children = widget.children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LuxuryTravelTheme.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '乘客人数',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LuxuryTravelTheme.darkText,
            ),
          ),
          const SizedBox(height: 24),
          _CounterRow(
            label: '成人',
            value: _adults,
            min: 1,
            onIncrement: () => setState(() => _adults++),
            onDecrement: () =>
                setState(() => _adults = _adults > 1 ? _adults - 1 : 1),
          ),
          const SizedBox(height: 16),
          _CounterRow(
            label: '儿童',
            value: _children,
            min: 0,
            onIncrement: () => setState(() => _children++),
            onDecrement: () =>
                setState(() => _children = _children > 0 ? _children - 1 : 0),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () => widget.onConfirm(_adults, _children),
              style: FilledButton.styleFrom(
                backgroundColor: LuxuryTravelTheme.primaryGold,
                foregroundColor: LuxuryTravelTheme.darkText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text('确定',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.value,
    required this.min,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final int value;
  final int min;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: LuxuryTravelTheme.darkText,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CounterBtn(
              icon: Icons.remove_rounded,
              onPressed: value > min ? onDecrement : null,
            ),
            const SizedBox(width: 20),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: LuxuryTravelTheme.darkText,
              ),
            ),
            const SizedBox(width: 20),
            _CounterBtn(icon: Icons.add_rounded, onPressed: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _CounterBtn extends StatelessWidget {
  const _CounterBtn({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: enabled ? const Color(0xFFF5F5F5) : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon,
              size: 24,
              color: enabled ? LuxuryTravelTheme.darkText : LuxuryTravelTheme.textTertiary),
        ),
      ),
    );
  }
}
