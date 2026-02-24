import 'package:flutter/material.dart';

import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../theme/luxury_travel_theme.dart';

/// Luxury booking form: cream/gold palette, soft shadow, departure/arrival with swap,
/// date chips, passenger sheet, cabin segments, gold CTA search button.
class BookingForm extends StatefulWidget {
  const BookingForm({
    super.key,
    this.scrollController,
    this.onSearch,
  });

  final ScrollController? scrollController;
  final VoidCallback? onSearch;

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm>
    with SingleTickerProviderStateMixin {
  static Color get _fieldBg => LuxuryTravelTheme.surfaceMuted;
  static Color get _unselectedGrey => LuxuryTravelTheme.textTertiary;
  static Color get _warmCard => LuxuryTravelTheme.cardBackground;

  late AnimationController _swapRotationController;

  String _departure = '北京';
  String _arrival = '上海';
  DateTime? _selectedDate;
  int _adults = 1;
  int _children = 0;
  int _cabinIndex = 0; // 0 经济舱, 1 公务舱, 2 头等舱

  static const List<String> _cabinLabels = ['经济舱', '公务舱', '头等舱'];

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

  void _swapDepartureArrival() {
    setState(() {
      final t = _departure;
      _departure = _arrival;
      _arrival = t;
    });
    _swapRotationController.forward(from: 0);
  }

  DateTime _today() => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _tomorrow() => _today().add(const Duration(days: 1));
  DateTime _thisWeekend() {
    final today = _today();
    final weekday = today.weekday;
    final daysUntilSaturday = DateTime.saturday - weekday;
    return today.add(Duration(days: daysUntilSaturday <= 0 ? daysUntilSaturday + 7 : daysUntilSaturday));
  }

  String _formatDate(DateTime d) =>
      '${d.month}月${d.day}日';

  void _selectDate(DateTime d) => setState(() => _selectedDate = d);

  void _openPassengerSheet() {
    showAppBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _PassengerBottomSheet(
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

  @override
  Widget build(BuildContext context) {
    return _buildOneWayTabContent();
  }

  Widget _buildOneWayTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _buildOneWayForm(),
        ),
        _buildStickySearchButton(),
      ],
    );
  }

  Widget _buildOneWayForm() {
    const double fieldRadius = 18;
    const double gap = 18;
    final isCompact = MediaQuery.sizeOf(context).width < 360;
    final horizontalPadding = isCompact ? 18.0 : 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: widget.scrollController,
          padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 14),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDepartureArrivalRow(fieldRadius),
                SizedBox(height: gap),
                _buildDateRow(fieldRadius),
                SizedBox(height: gap),
                _buildPassengerRow(fieldRadius),
                SizedBox(height: gap),
                _buildCabinSegments(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDepartureArrivalRow(double radius) {
    return Material(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(radius),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: () {}, // Could open city picker
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.flight_takeoff_rounded, size: 24, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '出发',
                      style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
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
                  onTap: _swapDepartureArrival,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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
                      '到达',
                      style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
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
    );
  }

  Widget _buildDateRow(double radius) {
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
              Icon(Icons.calendar_today_rounded, size: 20, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                '日期',
                style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.textSecondary),
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
              date: today,
              selected: _selectedDate == null || _dateEquals(selected, today),
              onTap: () => _selectDate(today),
            ),
            _DateChip(
              label: '明天',
              date: tomorrow,
              selected: _dateEquals(selected, tomorrow),
              onTap: () => _selectDate(tomorrow),
            ),
            _DateChip(
              label: '本周末',
              date: weekend,
              selected: _dateEquals(selected, weekend),
              onTap: () => _selectDate(weekend),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Material(
          color: _fieldBg,
          borderRadius: BorderRadius.circular(radius),
          elevation: 0,
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selected,
                firstDate: today,
                lastDate: today.add(const Duration(days: 365)),
              );
              if (picked != null) _selectDate(picked);
            },
            borderRadius: BorderRadius.circular(radius),
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
                  Icon(Icons.calendar_month_rounded, size: 22, color: LuxuryTravelTheme.textTertiary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _dateEquals(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildPassengerRow(double radius) {
    final subtitle = _children > 0 ? '$_adults 成人 · $_children 儿童' : '$_adults 人';

    return _FormTile(
      icon: Icons.person_outline_rounded,
      label: '乘客',
      value: subtitle,
      onTap: _openPassengerSheet,
      radius: radius,
      fieldBg: _fieldBg,
    );
  }

  Widget _buildCabinSegments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.airline_seat_recline_extra_rounded, size: 20, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                '舱位',
                style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _fieldBg,
            borderRadius: BorderRadius.circular(16),
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
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected ? LuxuryTravelTheme.darkText : _unselectedGrey,
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

  Widget _buildStickySearchButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
      child: _SearchButton(
        onPressed: widget.onSearch,
      ),
    );
  }

}

class _FormTile extends StatelessWidget {
  const _FormTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.radius,
    required this.fieldBg,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final double radius;
  final Color fieldBg;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fieldBg,
      borderRadius: BorderRadius.circular(radius),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 24, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: LuxuryTravelTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: LuxuryTravelTheme.darkText,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: LuxuryTravelTheme.textTertiary),
            ],
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
    required this.selected,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? LuxuryTravelTheme.primaryGold.withValues(alpha: 0.15) : LuxuryTravelTheme.surfaceMuted,
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
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

class _PassengerBottomSheet extends StatefulWidget {
  const _PassengerBottomSheet({
    required this.adults,
    required this.children,
    required this.onConfirm,
  });

  final int adults;
  final int children;
  final void Function(int adults, int children) onConfirm;

  @override
  State<_PassengerBottomSheet> createState() => _PassengerBottomSheetState();
}

class _PassengerBottomSheetState extends State<_PassengerBottomSheet> {
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
            onDecrement: () => setState(() { if (_adults > 1) _adults--; }),
          ),
          const SizedBox(height: 16),
          _CounterRow(
            label: '儿童',
            value: _children,
            min: 0,
            onIncrement: () => setState(() => _children++),
            onDecrement: () => setState(() { if (_children > 0) _children--; }),
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
              child: Text('确定', style: LuxuryTravelTheme.buttonLabel(LuxuryTravelTheme.darkText)),
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
            _CounterButton(
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
            _CounterButton(
              icon: Icons.add_rounded,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: enabled ? LuxuryTravelTheme.surfaceMuted : LuxuryTravelTheme.border,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 24, color: enabled ? LuxuryTravelTheme.darkText : LuxuryTravelTheme.textTertiary),
        ),
      ),
    );
  }
}

class _SearchButton extends StatefulWidget {
  const _SearchButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: Duration(milliseconds: _pressed ? 80 : 200),
        curve: _pressed ? Curves.easeIn : Curves.elasticOut,
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
    );
  }
}
