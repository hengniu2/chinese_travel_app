import 'package:flutter/material.dart';

import '../../../../shared/design_system/app_colors.dart';

/// Premium booking form for commercial Chinese travel app: large rounded card,
/// elevated shadow, gradient TabBar, departure/arrival with swap, date chips,
/// passenger sheet, cabin segments, gradient CTA search button.
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
  static const Color _yellowHighlight = Color(0xFFFFF176);
  static const Color _fieldBg = Color(0xFFF8F7F5);
  static const Color _unselectedGrey = Color(0xFF8E8E8E);
  static const Color _warmCard = Color(0xFFFFFEFC);

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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
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
              Icon(Icons.flight_takeoff_rounded, size: 24, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '出发',
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _departure,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
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
                        color: AppColors.textSecondary,
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
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _arrival,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
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
              Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '日期',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_month_rounded, size: 22, color: AppColors.textTertiary),
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
              Icon(Icons.airline_seat_recline_extra_rounded, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '舱位',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
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
                          color: selected ? AppColors.textPrimary : _unselectedGrey,
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
              Icon(icon, size: 24, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: AppColors.textTertiary),
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

  static const Color _yellowAccent = Color(0xFFFFEE58);
  static const Color _yellowBg = Color(0xFFFFF9C4);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _yellowBg : const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: selected ? Border.all(color: _yellowAccent, width: 2) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
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
        color: Colors.white,
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
              color: AppColors.textPrimary,
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
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text('确定', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
            color: AppColors.textPrimary,
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
                color: AppColors.textPrimary,
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
      color: enabled ? const Color(0xFFF5F5F5) : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 24, color: enabled ? AppColors.textPrimary : Colors.grey),
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

  static const Color _gradientStart = Color(0xFFFFD54F);
  static const Color _gradientEnd = Color(0xFFFFC107);

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
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_gradientStart, _gradientEnd],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _gradientEnd.withValues(alpha: 0.4),
                offset: const Offset(0, 6),
                blurRadius: 16,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            '搜索',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
