import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/app_colors.dart';

/// Round-trip (往返) booking form: same structure as 单程 but with
/// 去程日期 and 返程日期. Search navigates to RoundTripResultPage.
class RoundTripForm extends StatefulWidget {
  const RoundTripForm({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  State<RoundTripForm> createState() => _RoundTripFormState();
}

class _RoundTripFormState extends State<RoundTripForm>
    with SingleTickerProviderStateMixin {
  static const double _fieldRadius = 18;
  static const double _verticalGap = 18;
  static const Color _fieldBg = Color(0xFFF8F7F5);
  static const Color _unselectedGrey = Color(0xFF8E8E8E);
  static const Color _warmCard = Color(0xFFFFFEFC);
  static const List<String> _cabinLabels = ['经济', '商务', '头等'];

  late AnimationController _swapRotationController;

  String _departure = '北京';
  String _arrival = '上海';
  DateTime? _outboundDate;
  DateTime? _returnDate;
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

  String _formatDate(DateTime d) => '${d.month}月${d.day}日';

  void _openPassengerSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _RoundTripPassengerSheet(
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
    context.push('/travel-service/round-trip-result');
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

  Widget _buildCityRow() {
    return Material(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(_fieldRadius),
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.flight_takeoff_rounded,
                  size: 24, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '出发城市',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textTertiary),
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
                      '到达城市',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textTertiary),
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

  /// 去程日期 + 返程日期 (two date pickers)
  Widget _buildDateSection() {
    final today = _today();
    final outbound = _outboundDate ?? today;
    final returnDate = _returnDate ?? today.add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '日期',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Material(
          color: _fieldBg,
          borderRadius: BorderRadius.circular(_fieldRadius),
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: outbound,
                firstDate: today,
                lastDate: today.add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _outboundDate = picked);
            },
            borderRadius: BorderRadius.circular(_fieldRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Text(
                    '去程日期',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDate(outbound),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_month_rounded,
                      size: 22, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: _fieldBg,
          borderRadius: BorderRadius.circular(_fieldRadius),
          child: InkWell(
            onTap: () async {
              final first = _outboundDate ?? today;
              final picked = await showDatePicker(
                context: context,
                initialDate: returnDate.isBefore(first)
                    ? first.add(const Duration(days: 1))
                    : returnDate,
                firstDate: first,
                lastDate: today.add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _returnDate = picked);
            },
            borderRadius: BorderRadius.circular(_fieldRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Text(
                    '返程日期',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDate(returnDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_month_rounded,
                      size: 22, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerRow() {
    final subtitle = _children > 0
        ? '$_adults 成人 · $_children 儿童'
        : '$_adults 人';

    return Material(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(_fieldRadius),
      child: InkWell(
        onTap: _openPassengerSheet,
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 24, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Text(
                '乘客数量',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 26, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

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
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '舱位',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary),
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
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? AppColors.textPrimary
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

  Widget _buildSearchButton() {
    const Color gradientStart = Color(0xFFFFD54F);
    const Color gradientEnd = Color(0xFFFFC107);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onSearch,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientStart, gradientEnd],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: gradientEnd.withValues(alpha: 0.4),
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
      ),
    );
  }
}

// ——— Helpers (round-trip passenger sheet) ———

class _RoundTripPassengerSheet extends StatefulWidget {
  const _RoundTripPassengerSheet({
    required this.adults,
    required this.children,
    required this.onConfirm,
  });

  final int adults;
  final int children;
  final void Function(int adults, int children) onConfirm;

  @override
  State<_RoundTripPassengerSheet> createState() =>
      _RoundTripPassengerSheetState();
}

class _RoundTripPassengerSheetState extends State<_RoundTripPassengerSheet> {
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
          _RoundTripCounterRow(
            label: '成人',
            value: _adults,
            min: 1,
            onIncrement: () => setState(() => _adults++),
            onDecrement: () =>
                setState(() => _adults = _adults > 1 ? _adults - 1 : 1),
          ),
          const SizedBox(height: 16),
          _RoundTripCounterRow(
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
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.black87,
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

class _RoundTripCounterRow extends StatelessWidget {
  const _RoundTripCounterRow({
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
            _RoundTripCounterBtn(
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
            _RoundTripCounterBtn(icon: Icons.add_rounded, onPressed: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _RoundTripCounterBtn extends StatelessWidget {
  const _RoundTripCounterBtn({required this.icon, this.onPressed});

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
              color: enabled ? AppColors.textPrimary : Colors.grey),
        ),
      ),
    );
  }
}
