import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics.dart';
import '../../../../core/micro_interactions/micro_interactions.dart';
import '../../../../shared/design_system/app_colors.dart';
import '../../models/models.dart';
import '../../providers/flight_search_provider.dart';

/// Single-trip form wired to flightSearchFormProvider.
/// Example of UI consuming Riverpod state.
class SingleTripFormRefactored extends ConsumerStatefulWidget {
  const SingleTripFormRefactored({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  ConsumerState<SingleTripFormRefactored> createState() =>
      _SingleTripFormRefactoredState();
}

class _SingleTripFormRefactoredState
    extends ConsumerState<SingleTripFormRefactored>
    with SingleTickerProviderStateMixin {
  static const double _fieldRadius = 18;
  static const double _verticalGap = 18;
  static const Color _fieldBg = Color(0xFFF8F7F5);
  static const Color _unselectedGrey = Color(0xFF8E8E8E);
  static const Color _warmCard = Color(0xFFFFFEFC);
  static const List<String> _cabinLabels = ['经济', '商务', '头等'];

  late AnimationController _swapRotationController;

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

  DateTime _today() => DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _tomorrow() => _today().add(const Duration(days: 1));
  DateTime _thisWeekend() {
    final today = _today();
    final wd = today.weekday;
    final days = DateTime.saturday - wd;
    return today.add(Duration(
        days: days <= 0 ? days + 7 : days));
  }

  String _formatDate(DateTime d) => '${d.month}月${d.day}日';
  bool _dateEquals(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _onSearch() {
    final notifier = ref.read(flightSearchFormProvider.notifier);
    final form = ref.read(flightSearchFormProvider);
    if (form.departureDate == null) notifier.setDepartureDate(_today());
    ref.read(analyticsServiceProvider).logEvent(SearchClickEvent(
      departure: form.departure,
      arrival: form.arrival,
      tripType: 'single',
    ));
    context.push('/travel-service/flight-result');
  }

  void _swapCities() {
    ref.read(flightSearchFormProvider.notifier).swapCities();
    _swapRotationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(flightSearchFormProvider);
    final notifier = ref.read(flightSearchFormProvider.notifier);
    final isCompact = MediaQuery.sizeOf(context).width < 360;
    final horizontalPadding = isCompact ? 16.0 : 20.0;
    final selectedDate = form.departureDate ?? _today();

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
                      _buildCityRow(form, notifier),
                      SizedBox(height: _verticalGap),
                      _buildDateSection(selectedDate, notifier),
                      SizedBox(height: _verticalGap),
                      _buildPassengerRow(form, notifier),
                      SizedBox(height: _verticalGap),
                      _buildCabinSection(form, notifier),
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

  Widget _buildCityRow(
    FlightSearchFormState form,
    FlightSearchFormNotifier notifier,
  ) {
    return Material(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(_fieldRadius),
      elevation: 0,
      child: InkWell(
        onTap: _swapCities,
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('出发城市',
                        style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                    const SizedBox(height: 4),
                    Text(form.departure,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _swapCities,
                child: AnimatedBuilder(
                  animation: _swapRotationController,
                  builder: (_, __) => Transform.rotate(
                    angle: _swapRotationController.value * 3.14159,
                    child: Icon(Icons.swap_horiz_rounded,
                        size: 28, color: AppColors.textSecondary),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('到达城市',
                        style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                    const SizedBox(height: 4),
                    Text(form.arrival,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(
    DateTime selectedDate,
    FlightSearchFormNotifier notifier,
  ) {
    final today = _today();
    final tomorrow = _tomorrow();
    final weekend = _thisWeekend();

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
              Text('日期',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _DateChip(
              label: '今天',
              selected: _dateEquals(selectedDate, today),
              onTap: () => notifier.setDepartureDate(today),
            ),
            _DateChip(
              label: '明天',
              selected: _dateEquals(selectedDate, tomorrow),
              onTap: () => notifier.setDepartureDate(tomorrow),
            ),
            _DateChip(
              label: '本周末',
              selected: _dateEquals(selectedDate, weekend),
              onTap: () => notifier.setDepartureDate(weekend),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassengerRow(
    FlightSearchFormState form,
    FlightSearchFormNotifier notifier,
  ) {
    final subtitle = form.children > 0
        ? '${form.adults} 成人 · ${form.children} 儿童'
        : '${form.adults} 人';

    return Material(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(_fieldRadius),
      child: InkWell(
        onTap: () {
          showAppBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => _PassengerSheet(
              adults: form.adults,
              children: form.children,
              onConfirm: (a, c) {
                notifier.setAdults(a);
                notifier.setChildren(c);
                Navigator.of(ctx).pop();
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(_fieldRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 24, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Text('乘客数量',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  )),
              const Spacer(),
              Text(subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 26, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCabinSection(
    FlightSearchFormState form,
    FlightSearchFormNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final selected = form.cabinIndex == i;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => notifier.setCabinIndex(i),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? _warmCard : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _cabinLabels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
    );
  }

  Widget _buildSearchButton() {
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
                colors: [Color(0xFFFFD54F), Color(0xFFFFC107)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: const Text(
              '搜索',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFFF9C4) : const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
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
          const Text('乘客人数',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              )),
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
        Text(label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            )),
        const Spacer(),
        Material(
          color: value > min ? const Color(0xFFF5F5F5) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: value > min ? onDecrement : null,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.remove, size: 24, color: AppColors.textPrimary),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('$value',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
        ),
        Material(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.add, size: 24, color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
