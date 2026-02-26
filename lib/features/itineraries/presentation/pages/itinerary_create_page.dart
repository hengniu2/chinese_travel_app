import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/itinerary_repository_provider.dart';

/// 新建行程 — POST /api/itineraries
class ItineraryCreatePage extends ConsumerStatefulWidget {
  const ItineraryCreatePage({super.key});

  @override
  ConsumerState<ItineraryCreatePage> createState() => _ItineraryCreatePageState();
}

class _ItineraryCreatePageState extends ConsumerState<ItineraryCreatePage> {
  final _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() { _error = null; _loading = true; });
    try {
      final repo = ref.read(itineraryRepositoryProvider);
      await repo.create(
        name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
      );
      if (!mounted) return;
      ref.invalidate(itineraryListProvider);
      context.go('/profile/itineraries');
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('新建行程'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('行程名称', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: 8.h),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '例如：杭州三日游',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                filled: true,
                fillColor: AppColors.card,
              ),
            ),
            SizedBox(height: 24.h),
            Text('开始日期', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: 8.h),
            ListTile(
              title: Text(_startDate == null ? '选择日期' : '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.calendar_today_rounded),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              tileColor: AppColors.card,
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _startDate = d);
              },
            ),
            SizedBox(height: 16.h),
            Text('结束日期', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: 8.h),
            ListTile(
              title: Text(_endDate == null ? '选择日期' : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'),
              trailing: const Icon(Icons.calendar_today_rounded),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              tileColor: AppColors.card,
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _startDate ?? DateTime.now(), firstDate: _startDate ?? DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _endDate = d);
              },
            ),
            if (_error != null) ...[
              SizedBox(height: 16.h),
              Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ],
            SizedBox(height: 32.h),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.iconOutlineOnLight, padding: EdgeInsets.symmetric(vertical: 14.h)),
              child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.iconOutlineOnLight)) : const Text('创建行程'),
            ),
          ],
        ),
      ),
    );
  }
}
