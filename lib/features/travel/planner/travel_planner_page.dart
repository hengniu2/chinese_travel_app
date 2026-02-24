import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../widgets/ai_branding.dart';
import 'planner_guided_steps.dart';
import '../services/planner_service.dart';
import '../state/state.dart';

const double _kSectionPaddingH = 14;
const double _kSectionPadV = 10;
const double _kContentCardRadius = 20;

// Section colors aligned with Home screen (different background per step)
const Color _kSectionWarm = Color(0xFFFFF3E0);
const Color _kSectionLavender = Color(0xFFF3E5F5);
const Color _kSectionMint = Color(0xFFE0F2F1);

/// Multi-step guided planner flow — AI-style wizard.
class TravelPlannerPage extends ConsumerStatefulWidget {
  const TravelPlannerPage({super.key});

  @override
  ConsumerState<TravelPlannerPage> createState() => _TravelPlannerPageState();
}

class _TravelPlannerPageState extends ConsumerState<TravelPlannerPage> {
  bool _promoBannerVisible = true;
  late PageController _pageController;
  int _currentPage = 0;
  static const int _kTotalSteps = 6;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.hasClients && _pageController.page != null
        ? _pageController.page!.round()
        : 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(plannerFormStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: Column(
        children: [
          _buildHeader(context, l10n),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.homeSearchCapsule,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(_kContentCardRadius)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, -2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (_promoBannerVisible) _buildPromoBanner(),
                  _buildProgressIndicator(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _kTotalSteps,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            final page = _pageController.hasClients ? (_pageController.page ?? index.toDouble()) : index.toDouble();
                            final delta = (page - index).abs().clamp(0.0, 1.0);
                            final t = (1.0 - delta).clamp(0.0, 1.0);
                            final opacity = Curves.easeOutCubic.transform(t);
                            return Opacity(
                              opacity: opacity,
                              child: child,
                            );
                          },
                          child: _buildStepSection(index, formState),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (formState.submitError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                formState.submitError!,
                style: const TextStyle(fontSize: 12, color: AppColors.error),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          _buildNextButton(context, l10n, formState),
        ],
      ),
    );
  }

  static const double _kHeaderHeight = 100;

  Color _sectionColorForStep(int index) {
    switch (index % 6) {
      case 0:
        return AppColors.homeSectionGreen;
      case 1:
        return AppColors.homeSectionYellow;
      case 2:
        return AppColors.homeSectionBlueStart;
      case 3:
        return _kSectionWarm;
      case 4:
        return _kSectionLavender;
      case 5:
        return _kSectionMint;
      default:
        return AppColors.homeSectionGreen;
    }
  }

  Widget _buildStepSection(int index, dynamic formState) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _sectionColorForStep(index),
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(_kSectionPaddingH, _kSectionPadV, _kSectionPaddingH, _kSectionPadV),
      child: _buildStepAt(index, formState),
    );
  }

  Widget _buildStepAt(int index, dynamic formState) {
    final request = formState.request;
    final notifier = ref.read(plannerFormStateProvider.notifier);
    switch (index) {
      case 0:
        return PlannerStepDestination(request: request, onChanged: (r) => notifier.updateRequest(r));
      case 1:
        return PlannerStepDates(request: request, onChanged: (r) => notifier.updateRequest(r));
      case 2:
        return PlannerStepBudget(request: request, onChanged: (r) => notifier.updateRequest(r));
      case 3:
        return PlannerStepPreferences(request: request, onChanged: (r) => notifier.updateRequest(r));
      case 4:
        return PlannerStepTravelers(request: request, onChanged: (r) => notifier.updateRequest(r));
      case 5:
        return PlannerStepGenerate(
          request: request,
          formState: formState,
          onGenerate: () => _submitAndNavigate(context, ref),
        );
      default:
        return PlannerStepDestination(request: request, onChanged: (r) => notifier.updateRequest(r));
    }
  }

  static const double _kHeaderRadius = 12;

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final topPadding = MediaQuery.of(context).padding.top;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(_kHeaderRadius),
        bottomRight: Radius.circular(_kHeaderRadius),
      ),
      child: Container(
        height: _kHeaderHeight + topPadding,
        padding: EdgeInsets.fromLTRB(14, topPadding + 8, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.homeSearchCapsule,
          border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryPale,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.plannerFormCta,
                style: TravelTypography.sectionTitle(AppColors.textPrimary, fontSize: 18),
              ),
            ),
            AiBranding(compact: true, iconSize: 12, fontSize: 9),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, _) {
              final page = _pageController.hasClients ? (_pageController.page ?? 0) : 0.0;
              final progress = (page / (_kTotalSteps - 1)).clamp(0.0, 1.0);
              return Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: width * progress,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TravelDesignTokens.primary,
                          AppColors.primaryDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, AppLocalizations l10n, dynamic formState) {
    final isLastStep = _currentPage >= _kTotalSteps - 1;
    final isSubmitting = formState.isSubmitting as bool;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmBackground,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
            onPressed: isSubmitting
                ? null
                : () {
                    if (isLastStep) {
                      _submitAndNavigate(context, ref);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: TravelDesignTokens.primary,
              foregroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A1A1A)),
                  )
                : Text(
                    isLastStep ? l10n.plannerGetPlan : '下一步',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
      if (context.mounted) context.push('/planner/planner/ai-result');
    } catch (e) {
      notifier.setSubmitError(e.toString());
    }
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_kSectionPaddingH, 8, _kSectionPaddingH, 0),
      child: _PromoBanner(
        onClose: () => setState(() => _promoBannerVisible = false),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Promotional banner — gradient, compact, closeable
// ─────────────────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFFF8E53),
            Color(0xFFFFB347),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.35),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(
                  '🎉 新用户立减 ¥300',
                  style: TravelTypography.content(Colors.white, fontSize: 14)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: Colors.white.withValues(alpha: 0.9)),
                  onPressed: onClose,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
