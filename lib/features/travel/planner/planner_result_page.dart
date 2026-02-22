import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../discovery/discovery_package_card.dart';
import '../models/models.dart';
import '../services/planner_service.dart';
import '../state/state.dart';

/// Plan result: recommended packages (scored) + Save / Edit / Share / Consultant.
class PlannerResultPage extends ConsumerStatefulWidget {
  const PlannerResultPage({super.key});

  @override
  ConsumerState<PlannerResultPage> createState() => _PlannerResultPageState();
}

class _PlannerResultPageState extends ConsumerState<PlannerResultPage> {
  CustomItineraryDraft? _customDraft;
  bool _customDraftLoading = false;

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(currentPlannerResultProvider);
    final l10n = AppLocalizations.of(context)!;

    if (result == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(l10n.plannerResultTitle),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.plannerResultNoPackages,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.plannerEditPlan),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final packages = result.recommendedPackages;
    final scored = result.scoredPackages;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.plannerResultTitle),
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
              _PlanActions(
                result: result,
                l10n: l10n,
                onSave: () => _savePlan(result, l10n),
                onEdit: () => _editPlan(result),
                onShare: () => _sharePlan(l10n),
                onConsultant: () => _requestConsultant(l10n),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.plannerResultRecommended),
              const SizedBox(height: 12),
              if (packages.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.plannerResultNoPackages,
                    style: TravelDesignTokens.body(AppColors.textTertiary),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: packages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final p = packages[index];
                    final score = index < scored.length
                        ? (scored[index].score * 100).round()
                        : null;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (score != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              l10n.plannerMatch(score),
                              style: TravelDesignTokens.caption(
                                TravelDesignTokens.primary,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        DiscoveryPackageCard(
                          package: p,
                          onTap: () => context.push('/planner/detail/${p.id}'),
                        ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 24),
              _CustomItinerarySection(
                request: result.request,
                draft: _customDraft,
                loading: _customDraftLoading,
                l10n: l10n,
                onGenerate: () => _generateCustomItinerary(result.request),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.push('/planner/discovery'),
                icon: const Icon(Icons.explore_rounded, size: 20),
                label: Text(l10n.plannerFeaturedSeeAll),
                style: OutlinedButton.styleFrom(
                  foregroundColor: TravelDesignTokens.primary,
                  side: BorderSide(color: TravelDesignTokens.primary),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _savePlan(PlannerResult result, AppLocalizations l10n) {
    final plan = savedPlanFromResult(result);
    ref.read(savedPlansProvider.notifier).savePlan(plan);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.plannerPlanSaved)),
      );
    }
  }

  void _editPlan(PlannerResult result) {
    ref.read(plannerFormStateProvider.notifier).updateRequest(result.request);
    if (mounted) context.pop();
  }

  void _sharePlan(AppLocalizations l10n) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.plannerShareMessage)),
      );
    }
  }

  void _requestConsultant(AppLocalizations l10n) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.plannerConsultantMessage)),
      );
    }
  }

  Future<void> _generateCustomItinerary(PlannerRequest request) async {
    setState(() => _customDraftLoading = true);
    final service = ref.read(plannerServiceProvider);
    final draft = await service.generateCustomItinerary(request);
    if (mounted) {
      setState(() {
        _customDraft = draft;
        _customDraftLoading = false;
      });
    }
  }
}

class _PlanActions extends StatelessWidget {
  const _PlanActions({
    required this.result,
    required this.l10n,
    required this.onSave,
    required this.onEdit,
    required this.onShare,
    required this.onConsultant,
  });

  final PlannerResult result;
  final AppLocalizations l10n;
  final VoidCallback onSave;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onConsultant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${result.request.destination ?? "Trip"} · ${result.recommendedPackages.length} packages',
            style: TravelDesignTokens.body(AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionChip(
                label: l10n.plannerSavePlan,
                icon: Icons.bookmark_outline_rounded,
                onTap: onSave,
              ),
              _ActionChip(
                label: l10n.plannerEditPlan,
                icon: Icons.edit_outlined,
                onTap: onEdit,
              ),
              _ActionChip(
                label: l10n.plannerSharePlan,
                icon: Icons.share_rounded,
                onTap: onShare,
              ),
              _ActionChip(
                label: l10n.plannerRequestConsultant,
                icon: Icons.phone_in_talk_rounded,
                onTap: onConsultant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: TravelDesignTokens.primary),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: TravelDesignTokens.primary.withValues(alpha: 0.08),
      side: BorderSide(color: TravelDesignTokens.primary.withValues(alpha: 0.3)),
    );
  }
}

class _CustomItinerarySection extends StatelessWidget {
  const _CustomItinerarySection({
    required this.request,
    required this.draft,
    required this.loading,
    required this.l10n,
    required this.onGenerate,
  });

  final PlannerRequest request;
  final CustomItineraryDraft? draft;
  final bool loading;
  final AppLocalizations l10n;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: l10n.plannerCustomItinerary),
          const SizedBox(height: 8),
          if (draft != null) ...[
            if (draft!.title != null)
              Text(
                draft!.title!,
                style: TravelDesignTokens.titleL(null),
              ),
            if (draft!.summary != null) ...[
              const SizedBox(height: 6),
              Text(
                draft!.summary!,
                style: TravelDesignTokens.body(AppColors.textSecondary),
              ),
            ],
            if (draft!.days.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...draft!.days.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TravelDesignTokens.primary.withValues(alpha: 0.15),
                          borderRadius: TravelDesignTokens.borderRadiusSmall,
                        ),
                        child: Text(
                          '${d.dayNumber ?? 0}',
                          style: TravelDesignTokens.caption(
                            TravelDesignTokens.primary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (d.title != null)
                              Text(
                                d.title!,
                                style: TravelDesignTokens.body(null).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (d.description != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                d.description!,
                                style: TravelDesignTokens.caption(
                                  AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ] else if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            TravelOutlineButton(
              label: l10n.plannerCustomItinerary,
              onPressed: onGenerate,
            ),
        ],
      ),
    );
  }
}
