import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/review_repository_provider.dart';

/// 提交评价 — POST /api/reviews
/// targetType: COMPANION, MERCHANT, PACKAGE, HOTEL, TICKET
class SubmitReviewPage extends ConsumerStatefulWidget {
  const SubmitReviewPage({
    super.key,
    required this.targetType,
    required this.targetId,
    this.orderId,
    this.targetName,
  });

  final String targetType;
  final String targetId;
  final String? orderId;
  final String? targetName;

  @override
  ConsumerState<SubmitReviewPage> createState() => _SubmitReviewPageState();
}

class _SubmitReviewPageState extends ConsumerState<SubmitReviewPage> {
  int _rating = 5;
  final _contentController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() { _error = null; _loading = true; });
    try {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.create(
        targetType: widget.targetType,
        targetId: widget.targetId,
        rating: _rating,
        orderId: widget.orderId,
        content: _contentController.text.trim().isEmpty ? null : _contentController.text.trim(),
      );
      if (!mounted) return;
      ref.invalidate(myReviewsListProvider);
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.targetName ?? '服务';
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: Text('评价$name'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('评分', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final star = i + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = star),
                  icon: Icon(
                    star <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 40.sp,
                    color: AppColors.accentGold,
                  ),
                );
              }),
            ),
            SizedBox(height: 24.h),
            Text('评价内容（选填）', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary)),
            SizedBox(height: 8.h),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '分享您的体验...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                filled: true,
                fillColor: AppColors.card,
              ),
            ),
            if (_error != null) ...[
              SizedBox(height: 16.h),
              Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ],
            SizedBox(height: 32.h),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.iconOutlineOnLight, padding: EdgeInsets.symmetric(vertical: 14.h)),
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.iconOutlineOnLight))
                  : const Text('提交评价'),
            ),
          ],
        ),
      ),
    );
  }
}
