import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../state/travel_filter_state.dart';

/// Premium full-screen bottom sheet: Price Range, Duration, Themes, Group Size,
/// Departure City, Accommodation Level, Transportation Type. Reset + Apply sticky bottom.
class DiscoveryFilterSheet extends StatefulWidget {
  const DiscoveryFilterSheet({
    super.key,
    required this.filter,
    required this.onApply,
    required this.onClear,
    required this.onDismiss,
    required this.l10n,
  });

  final TravelFilterState filter;
  final void Function(TravelFilterState) onApply;
  final VoidCallback onClear;
  final VoidCallback onDismiss;
  final AppLocalizations l10n;

  @override
  State<DiscoveryFilterSheet> createState() => _DiscoveryFilterSheetState();
}

class _DiscoveryFilterSheetState extends State<DiscoveryFilterSheet> {
  static const double _priceMinDefault = 0;
  static const double _priceMaxDefault = 50000;

  late TextEditingController _departureController;
  late RangeValues _priceRange;
  late List<String> _selectedDurationRanges;
  late List<String> _selectedThemes;
  late List<String> _selectedGroupSizes;
  late List<String> _selectedAccommodationLevels;
  late List<String> _selectedTransportTypes;

  static const List<String> _themeOptions = [
    '文化', '自然', '古镇', '亲子', '摄影', '历史', '探险', '周边',
  ];

  @override
  void initState() {
    super.initState();
    _departureController = TextEditingController(text: widget.filter.departureCity ?? '');
    _priceRange = RangeValues(
      widget.filter.priceMin ?? _priceMinDefault,
      widget.filter.priceMax ?? _priceMaxDefault,
    );
    _selectedDurationRanges = List<String>.from(widget.filter.selectedDurationRanges);
    if (_selectedDurationRanges.isEmpty &&
        (widget.filter.durationDaysMin != null || widget.filter.durationDaysMax != null)) {
      if (widget.filter.durationDaysMin != null && widget.filter.durationDaysMax != null) {
        if (widget.filter.durationDaysMin! <= 3 && widget.filter.durationDaysMax! <= 3) {
          _selectedDurationRanges.add('1-3');
        } else if (widget.filter.durationDaysMin! >= 4 && widget.filter.durationDaysMax! <= 7) {
          _selectedDurationRanges.add('4-7');
        } else if (widget.filter.durationDaysMin! >= 8 && widget.filter.durationDaysMax! <= 14) {
          _selectedDurationRanges.add('8-14');
        } else if (widget.filter.durationDaysMin! >= 15) {
          _selectedDurationRanges.add('15+');
        }
      }
    }
    _selectedThemes = List<String>.from(widget.filter.themes);
    _selectedGroupSizes = List<String>.from(widget.filter.selectedGroupSizes);
    if (_selectedGroupSizes.isEmpty && widget.filter.groupSize != null && widget.filter.groupSize!.isNotEmpty) {
      _selectedGroupSizes = List<String>.from(widget.filter.selectedGroupSizes);
    }
    _selectedAccommodationLevels = List<String>.from(widget.filter.selectedAccommodationLevels);
    if (_selectedAccommodationLevels.isEmpty && widget.filter.accommodationLevel != null) {
      _selectedAccommodationLevels = [widget.filter.accommodationLevel!];
    }
    _selectedTransportTypes = List<String>.from(widget.filter.transportationTypes);
  }

  @override
  void dispose() {
    _departureController.dispose();
    super.dispose();
  }

  void _apply() {
    final dep = _departureController.text.trim();
    final priceMin = _priceRange.start > _priceMinDefault ? _priceRange.start : null;
    final priceMax = _priceRange.end < _priceMaxDefault ? _priceRange.end : null;

    final next = TravelFilterState(
      departureCity: dep.isEmpty ? null : dep,
      priceMin: priceMin,
      priceMax: priceMax,
      selectedDurationRanges: _selectedDurationRanges,
      themes: _selectedThemes,
      selectedGroupSizes: _selectedGroupSizes,
      selectedAccommodationLevels: _selectedAccommodationLevels,
      transportationTypes: _selectedTransportTypes,
    );
    widget.onApply(next);
  }

  void _reset() {
    setState(() {
      _departureController.text = '';
      _priceRange = const RangeValues(_priceMinDefault, _priceMaxDefault);
      _selectedDurationRanges = [];
      _selectedThemes = [];
      _selectedGroupSizes = [];
      _selectedAccommodationLevels = [];
      _selectedTransportTypes = [];
    });
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final l10n = widget.l10n;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.discoveryAdvancedFilters,
                    style: TravelDesignTokens.titleXL(null),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(l10n.discoveryFilterPriceRange),
                  RangeSlider(
                    values: _priceRange,
                    min: _priceMinDefault,
                    max: _priceMaxDefault,
                    divisions: 50,
                    activeColor: TravelDesignTokens.primary,
                    labels: RangeLabels(
                      '¥${_priceRange.start.toStringAsFixed(0)}',
                      '¥${_priceRange.end.toStringAsFixed(0)}',
                    ),
                    onChanged: (v) => setState(() => _priceRange = v),
                  ),
                  Text(
                    '¥${_priceRange.start.toStringAsFixed(0)} – ¥${_priceRange.end.toStringAsFixed(0)}',
                    style: TravelDesignTokens.caption(AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(l10n.discoveryFilterDuration),
                  _buildMultiSelectChips(
                    optionIds: kDurationRangeIds,
                    selectedIds: _selectedDurationRanges,
                    labelForId: (id) {
                      switch (id) {
                        case '1-3': return l10n.discoveryFilterDuration1to3;
                        case '4-7': return l10n.discoveryFilterDuration4to7;
                        case '8-14': return l10n.discoveryFilterDuration8to14;
                        case '15+': return l10n.discoveryFilterDuration15Plus;
                        default: return id;
                      }
                    },
                    onToggle: (id) {
                      setState(() {
                        if (_selectedDurationRanges.contains(id)) {
                          _selectedDurationRanges.remove(id);
                        } else {
                          _selectedDurationRanges.add(id);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(l10n.discoveryFilterThemes),
                  _buildThemeGrid(),
                  const SizedBox(height: 20),
                  _sectionTitle(l10n.discoveryFilterGroupSize),
                  _buildMultiSelectChips(
                    optionIds: kGroupSizeIds,
                    selectedIds: _selectedGroupSizes,
                    labelForId: (id) {
                      switch (id) {
                        case 'solo': return l10n.discoveryFilterGroupSolo;
                        case '2-4': return l10n.discoveryFilterGroup2to4;
                        case '5-9': return l10n.discoveryFilterGroup5to9;
                        case '10+': return l10n.discoveryFilterGroup10Plus;
                        default: return id;
                      }
                    },
                    onToggle: (id) {
                      setState(() {
                        if (_selectedGroupSizes.contains(id)) {
                          _selectedGroupSizes.remove(id);
                        } else {
                          _selectedGroupSizes.add(id);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(l10n.discoveryFilterDepartureCity),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _departureController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.discoveryFilterDepartureHint,
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      isDense: true,
                    ),
                    style: TravelDesignTokens.body(AppColors.textPrimary).copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(l10n.discoveryFilterAccommodation),
                  _buildMultiSelectChips(
                    optionIds: kAccommodationLevelIds,
                    selectedIds: _selectedAccommodationLevels,
                    labelForId: (id) {
                      switch (id) {
                        case 'economy': return l10n.discoveryFilterAccomEconomy;
                        case 'comfort': return l10n.discoveryFilterAccomComfort;
                        case 'premium': return l10n.discoveryFilterAccomPremium;
                        case 'luxury': return l10n.discoveryFilterAccomLuxury;
                        default: return id;
                      }
                    },
                    onToggle: (id) {
                      setState(() {
                        if (_selectedAccommodationLevels.contains(id)) {
                          _selectedAccommodationLevels.remove(id);
                        } else {
                          _selectedAccommodationLevels.add(id);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle(l10n.discoveryFilterTransportation),
                  _buildMultiSelectChips(
                    optionIds: kTransportationTypeIds,
                    selectedIds: _selectedTransportTypes,
                    labelForId: (id) {
                      switch (id) {
                        case 'flight': return l10n.discoveryFilterTransportFlight;
                        case 'train': return l10n.discoveryFilterTransportTrain;
                        case 'bus': return l10n.discoveryFilterTransportBus;
                        case 'self_drive': return l10n.discoveryFilterTransportSelfDrive;
                        default: return id;
                      }
                    },
                    onToggle: (id) {
                      setState(() {
                        if (_selectedTransportTypes.contains(id)) {
                          _selectedTransportTypes.remove(id);
                        } else {
                          _selectedTransportTypes.add(id);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildStickyButtons(bottomPadding, l10n),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TravelDesignTokens.caption(AppColors.textSecondary).copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildMultiSelectChips({
    required List<String> optionIds,
    required List<String> selectedIds,
    required String Function(String id) labelForId,
    required void Function(String id) onToggle,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: optionIds.map((id) {
        final selected = selectedIds.contains(id);
        return FilterChip(
          label: Text(labelForId(id)),
          selected: selected,
          onSelected: (_) => onToggle(id),
          selectedColor: TravelDesignTokens.primary.withValues(alpha: 0.2),
          checkmarkColor: TravelDesignTokens.primary,
          side: BorderSide(
            color: selected ? TravelDesignTokens.primary : AppColors.border,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThemeGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _themeOptions.map((t) {
        final selected = _selectedThemes.contains(t);
        return FilterChip(
          label: Text(t),
          selected: selected,
          onSelected: (_) {
            setState(() {
              if (selected) {
                _selectedThemes.remove(t);
              } else {
                _selectedThemes.add(t);
              }
            });
          },
          selectedColor: TravelDesignTokens.primary.withValues(alpha: 0.2),
          checkmarkColor: TravelDesignTokens.primary,
          side: BorderSide(
            color: selected ? TravelDesignTokens.primary : AppColors.border,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStickyButtons(double bottomPadding, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TravelOutlineButton(
                label: l10n.discoveryFilterReset,
                onPressed: _reset,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TravelPrimaryButton(
                label: l10n.discoveryApplyFilters,
                onPressed: _apply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
