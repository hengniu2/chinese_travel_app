import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../models/booking_models.dart';
import '../state/state.dart';
import 'booking_step_indicator.dart';

/// Step 2: Traveler information. Contact, traveler list, passport (if needed), special requests.
class BookingTravelersPage extends ConsumerStatefulWidget {
  const BookingTravelersPage({super.key, required this.packageId});

  final String packageId;

  @override
  ConsumerState<BookingTravelersPage> createState() => _BookingTravelersPageState();
}

class _BookingTravelersPageState extends ConsumerState<BookingTravelersPage> {
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _specialRequestsController = TextEditingController();
  final Map<int, TextEditingController> _nameControllers = {};
  final Map<int, TextEditingController> _phoneControllers = {};
  final Map<int, TextEditingController> _idControllers = {};
  final Map<int, TextEditingController> _passportControllers = {};
  final Map<int, String?> _errors = {};

  @override
  void dispose() {
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _specialRequestsController.dispose();
    for (final c in _nameControllers.values) c.dispose();
    for (final c in _phoneControllers.values) c.dispose();
    for (final c in _idControllers.values) c.dispose();
    for (final c in _passportControllers.values) c.dispose();
    super.dispose();
  }

  void _syncFromState(int count) {
    final booking = ref.read(travelBookingStateProvider);
    _contactPhoneController.text = booking.contactPhone ?? '';
    _contactEmailController.text = booking.contactEmail ?? '';
    _specialRequestsController.text = booking.notes ?? '';
    for (var i = 0; i < count; i++) {
      if (i < booking.travelers.length) {
        final t = booking.travelers[i];
        _nameControllers.putIfAbsent(i, () => TextEditingController()).text = t.name ?? '';
        _phoneControllers.putIfAbsent(i, () => TextEditingController()).text = t.phone ?? '';
        _idControllers.putIfAbsent(i, () => TextEditingController()).text = t.idNumber ?? '';
        _passportControllers.putIfAbsent(i, () => TextEditingController()).text = t.passportNumber ?? '';
      }
    }
  }

  List<TravelerInfo> _collectTravelers() {
    final booking = ref.read(travelBookingStateProvider);
    final count = booking.travelerCount;
    final list = <TravelerInfo>[];
    for (var i = 0; i < count; i++) {
      list.add(TravelerInfo(
        name: _nameControllers[i]?.text.trim(),
        phone: _phoneControllers[i]?.text.trim(),
        idNumber: _idControllers[i]?.text.trim(),
        passportNumber: _passportControllers[i]?.text.trim(),
      ));
    }
    return list;
  }

  bool _validate() {
    final booking = ref.read(travelBookingStateProvider);
    final errors = <int, String>{};
    for (var i = 0; i < booking.travelerCount; i++) {
      final name = _nameControllers[i]?.text.trim() ?? '';
      final phone = _phoneControllers[i]?.text.trim() ?? '';
      if (name.isEmpty) errors[i] = 'Name required';
      else if (phone.isEmpty) errors[i] = 'Phone required';
    }
    setState(() => _errors.clear());
    setState(() => _errors.addAll(errors));
    return errors.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(travelBookingStateProvider);
    final l10n = AppLocalizations.of(context)!;
    if (booking.travelerCount > _nameControllers.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncFromState(booking.travelerCount);
      });
    }

    return Scaffold(
      backgroundColor: TravelDesignTokens.background,
      appBar: AppBar(
        title: Text(l10n.bookingTravelers),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TravelDesignTokens.screenHorizontal,
                vertical: 12,
              ),
              child: BookingStepIndicator(currentStep: 2, totalSteps: 6),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: TravelDesignTokens.screenHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FormCard(
                      title: l10n.bookingContactInfo,
                      children: [
                        TextField(
                          controller: _contactPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => ref.read(travelBookingStateProvider.notifier).setContact(
                                _contactPhoneController.text.trim(),
                                _contactEmailController.text.trim().isEmpty ? null : _contactEmailController.text.trim(),
                              ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _contactEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email (optional)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => ref.read(travelBookingStateProvider.notifier).setContact(
                                _contactPhoneController.text.trim().isEmpty ? null : _contactPhoneController.text.trim(),
                                _contactEmailController.text.trim().isEmpty ? null : _contactEmailController.text.trim(),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(
                      title: l10n.bookingTravelerList,
                      trailing: TextButton.icon(
                        onPressed: () {
                          ref.read(travelBookingStateProvider.notifier).addTraveler();
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(l10n.bookingAddTraveler),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(booking.travelerCount, (i) {
                      _nameControllers.putIfAbsent(i, () => TextEditingController());
                      _phoneControllers.putIfAbsent(i, () => TextEditingController());
                      _idControllers.putIfAbsent(i, () => TextEditingController());
                      _passportControllers.putIfAbsent(i, () => TextEditingController());
                      return _TravelerTile(
                        index: i,
                        nameController: _nameControllers[i]!,
                        phoneController: _phoneControllers[i]!,
                        idController: _idControllers[i]!,
                        passportController: _passportControllers[i]!,
                        error: _errors[i],
                        onChanged: () {
                          ref.read(travelBookingStateProvider.notifier).updateTraveler(
                                i,
                                TravelerInfo(
                                  name: _nameControllers[i]?.text.trim(),
                                  phone: _phoneControllers[i]?.text.trim(),
                                  idNumber: _idControllers[i]?.text.trim(),
                                  passportNumber: _passportControllers[i]?.text.trim(),
                                ),
                              );
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    _FormCard(
                      title: l10n.bookingSpecialRequests,
                      children: [
                        TextField(
                          controller: _specialRequestsController,
                          decoration: const InputDecoration(
                            hintText: 'Diet, accessibility, etc.',
                            border: OutlineInputBorder(),
                            isDense: true,
                            alignLabelWithHint: true,
                          ),
                          maxLines: 2,
                          onChanged: (_) => ref.read(travelBookingStateProvider.notifier).setNotes(_specialRequestsController.text.trim()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TravelDesignTokens.screenHorizontal,
                12,
                TravelDesignTokens.screenHorizontal,
                16,
              ),
              child: TravelPrimaryButton(
                label: l10n.bookingNext,
                onPressed: () {
                  ref.read(travelBookingStateProvider.notifier).setTravelers(_collectTravelers());
                  ref.read(travelBookingStateProvider.notifier).setContact(
                        _contactPhoneController.text.trim().isEmpty ? null : _contactPhoneController.text.trim(),
                        _contactEmailController.text.trim().isEmpty ? null : _contactEmailController.text.trim(),
                      );
                  ref.read(travelBookingStateProvider.notifier).setNotes(
                        _specialRequestsController.text.trim().isEmpty ? null : _specialRequestsController.text.trim(),
                      );
                  if (!_validate()) return;
                  context.push('/planner/detail/${widget.packageId}/booking/addons');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TravelDesignTokens.titleL(null)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _TravelerTile extends StatelessWidget {
  const _TravelerTile({
    required this.index,
    required this.nameController,
    required this.phoneController,
    required this.idController,
    required this.passportController,
    this.error,
    required this.onChanged,
  });

  final int index;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController idController;
  final TextEditingController passportController;
  final String? error;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.circular(12),
        border: error != null ? Border.all(color: AppColors.error, width: 1) : null,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Traveler ${index + 1}',
            style: TravelDesignTokens.body(null).copyWith(fontWeight: FontWeight.w600),
          ),
          if (error != null) ...[
            const SizedBox(height: 4),
            Text(error!, style: TravelDesignTokens.caption(AppColors.error)),
          ],
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.travelerFormName,
              border: const OutlineInputBorder(),
              isDense: true,
              errorText: null,
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: l10n.travelerFormPhone,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: TextInputType.phone,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: l10n.travelerFormIdCard,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passportController,
            decoration: InputDecoration(
              labelText: l10n.bookingPassportInfo,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }
}
