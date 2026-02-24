import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../theme/luxury_travel_theme.dart';

/// Multi-city (多程) booking form — luxury theme. Dynamic segments, "+ 添加行程", search → MultiTripResultPage.
class MultiTripForm extends StatefulWidget {
  const MultiTripForm({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

  @override
  State<MultiTripForm> createState() => _MultiTripFormState();
}

class _MultiTripFormState extends State<MultiTripForm> {
  static const double _fieldRadius = 18;
  static const double _verticalGap = 18;
  static const int _maxSegments = 5;
  static Color get _fieldBg => LuxuryTravelTheme.surfaceMuted;
  static Color get _unselectedGrey => LuxuryTravelTheme.textTertiary;
  static Color get _warmCard => LuxuryTravelTheme.cardBackground;
  static const List<String> _cabinLabels = ['经济', '商务', '头等'];
  static Border get _fieldBorder => Border.all(
    color: LuxuryTravelTheme.border,
    width: 1.5,
  );

  final List<_TripSegment> _segments = [];
  int _adults = 1;
  int _children = 0;
  int _cabinIndex = 0;

  @override
  void initState() {
    super.initState();
    _segments.add(_TripSegment(
      departure: '北京',
      arrival: '上海',
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    ));
  }

  DateTime _today() => DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String _formatDate(DateTime d) => '${d.month}月${d.day}日';

  void _addSegment() {
    if (_segments.length >= _maxSegments) return;
    setState(() {
      final last = _segments.isEmpty ? _today() : _segments.last.date;
      _segments.add(_TripSegment(
        departure: _segments.isEmpty ? '北京' : _segments.last.arrival,
        arrival: '上海',
        date: last.add(const Duration(days: 1)),
      ));
    });
  }

  void _removeSegment(int index) {
    if (_segments.length <= 1) return;
    setState(() => _segments.removeAt(index));
  }

  void _updateSegment(int index, _TripSegment segment) {
    setState(() => _segments[index] = segment);
  }

  void _openPassengerSheet() {
    showAppBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _MultiTripPassengerSheet(
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
      departure: _segments.first.departure,
      arrival: _segments.last.arrival,
      tripType: 'multi',
    ));
    context.push('/travel-service/multi-trip-result');
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
                      _buildSegmentsList(),
                      if (_segments.length < _maxSegments) ...[
                        SizedBox(height: _verticalGap),
                        _buildAddSegmentButton(),
                      ],
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

  Widget _buildSegmentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.flight_rounded,
                  size: 20, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                '行程',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: LuxuryTravelTheme.textSecondary),
              ),
            ],
          ),
        ),
        ...List.generate(_segments.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < _segments.length - 1 ? 12 : 0),
            child: _SegmentCard(
              segment: _segments[i],
              index: i + 1,
              canRemove: _segments.length > 1,
              onUpdate: (s) => _updateSegment(i, s),
              onRemove: () => _removeSegment(i),
              fieldRadius: _fieldRadius,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAddSegmentButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _addSegment,
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: LuxuryTravelTheme.primaryGold.withValues(alpha: 0.6),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(_fieldRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded,
                  size: 22, color: LuxuryTravelTheme.primaryGold),
              const SizedBox(width: 8),
              Text(
                '添加行程',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: LuxuryTravelTheme.primaryGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

// ——— Segment model & card ———

class _TripSegment {
  _TripSegment({
    required this.departure,
    required this.arrival,
    required this.date,
  });

  String departure;
  String arrival;
  DateTime date;

  _TripSegment copyWith({
    String? departure,
    String? arrival,
    DateTime? date,
  }) {
    return _TripSegment(
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      date: date ?? this.date,
    );
  }
}

class _SegmentCard extends StatelessWidget {
  const _SegmentCard({
    required this.segment,
    required this.index,
    required this.canRemove,
    required this.onUpdate,
    required this.onRemove,
    required this.fieldRadius,
  });

  final _TripSegment segment;
  final int index;
  final bool canRemove;
  final void Function(_TripSegment) onUpdate;
  final VoidCallback onRemove;
  final double fieldRadius;

  static const Color _fieldBg = Color(0xFFF8F7F5);

  String _formatDate(DateTime d) => '${d.month}月${d.day}日';

  DateTime _today() => DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  static Border get _segmentBorder => Border.all(
    color: LuxuryTravelTheme.border,
    width: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(fieldRadius),
        border: _segmentBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '第$index段',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: LuxuryTravelTheme.textSecondary,
                ),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(Icons.close_rounded, size: 20, color: LuxuryTravelTheme.textTertiary),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SegmentField(
                  label: '出发',
                  value: segment.departure,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SegmentField(
                  label: '到达',
                  value: segment.arrival,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Material(
            color: LuxuryTravelTheme.cardBackground,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: segment.date,
                  firstDate: _today(),
                  lastDate: _today().add(const Duration(days: 365)),
                );
                if (picked != null) onUpdate(segment.copyWith(date: picked));
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      '日期',
                      style: TextStyle(
                          fontSize: 13, color: LuxuryTravelTheme.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(segment.date),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: LuxuryTravelTheme.darkText,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_month_rounded,
                        size: 20, color: LuxuryTravelTheme.textTertiary),
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

class _SegmentField extends StatelessWidget {
  const _SegmentField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  static Border get _fieldBorder => Border.all(
    color: LuxuryTravelTheme.border,
    width: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LuxuryTravelTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: _fieldBorder,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 12, color: LuxuryTravelTheme.textTertiary),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: LuxuryTravelTheme.darkText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ——— Passenger sheet ———

class _MultiTripPassengerSheet extends StatefulWidget {
  const _MultiTripPassengerSheet({
    required this.adults,
    required this.children,
    required this.onConfirm,
  });

  final int adults;
  final int children;
  final void Function(int adults, int children) onConfirm;

  @override
  State<_MultiTripPassengerSheet> createState() =>
      _MultiTripPassengerSheetState();
}

class _MultiTripPassengerSheetState extends State<_MultiTripPassengerSheet> {
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
          _MultiTripCounterRow(
            label: '成人',
            value: _adults,
            min: 1,
            onIncrement: () => setState(() => _adults++),
            onDecrement: () =>
                setState(() => _adults = _adults > 1 ? _adults - 1 : 1),
          ),
          const SizedBox(height: 16),
          _MultiTripCounterRow(
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

class _MultiTripCounterRow extends StatelessWidget {
  const _MultiTripCounterRow({
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
            _MultiTripCounterBtn(
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
            _MultiTripCounterBtn(icon: Icons.add_rounded, onPressed: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _MultiTripCounterBtn extends StatelessWidget {
  const _MultiTripCounterBtn({required this.icon, this.onPressed});

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
          child: Icon(icon,
              size: 24,
              color: enabled ? LuxuryTravelTheme.darkText : LuxuryTravelTheme.textTertiary),
        ),
      ),
    );
  }
}
