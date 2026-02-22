import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../services/planner_service.dart';
import '../state/state.dart';

/// Smart planner form → submit → recommendation engine → Plan Result.
class TravelPlannerPage extends ConsumerWidget {
  const TravelPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(plannerFormStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.plannerFormCta),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFDF5),
              Color(0xFFF7F9FC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
                'Destination: ${formState.request.destination ?? "—"}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Departure: ${formState.request.departureCity ?? "—"}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Travelers: ${formState.request.travelers ?? "—"}',
                style: AppTextStyles.bodyMedium,
              ),
              if (formState.submitError != null) ...[
                const SizedBox(height: 12),
                Text(
                  formState.submitError!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: formState.isSubmitting
                    ? null
                    : () => _submitAndNavigate(context, ref),
                child: formState.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.plannerGetPlan),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitAndNavigate(BuildContext context, WidgetRef ref) async {
    final formState = ref.read(plannerFormStateProvider);
    final notifier = ref.read(plannerFormStateProvider.notifier);
    notifier.setSubmitting(true);
    try {
      final service = ref.read(plannerServiceProvider);
      final result = await service.submitPlannerRequest(formState.request);
      ref.read(currentPlannerResultProvider.notifier).state = result;
      notifier.setSubmitting(false);
      if (context.mounted) context.push('/planner/planner/result');
    } catch (e) {
      notifier.setSubmitError(e.toString());
    }
  }
}
