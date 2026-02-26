import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/order_repository_provider.dart';

/// 订单创建页：参考客户示例图，采用亮绿头部 + 分块表单 + 底部提交栏
class OrderCreatePage extends ConsumerStatefulWidget {
  const OrderCreatePage({
    super.key,
    this.packageId,
    this.packageTitle,
    this.unitPrice,
  });

  final String? packageId;
  final String? packageTitle;
  final int? unitPrice;

  @override
  ConsumerState<OrderCreatePage> createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends ConsumerState<OrderCreatePage> {
  static const int _defaultAdultPrice = 4080;

  int _adultCount = 1;
  bool _submitting = false;
  String _paymentMethod = 'WECHAT';

  int get _adultPrice => widget.unitPrice ?? _defaultAdultPrice;
  String get _productTitle => widget.packageTitle ?? '旅行套餐';
  String? get _packageId => widget.packageId;

  int get _totalAmount => _adultCount * _adultPrice;

  @override
  void dispose() => super.dispose();

  void _changeAdultCount(int delta) {
    setState(() {
      _adultCount = (_adultCount + delta).clamp(1, 9);
    });
  }

  Future<void> _submitOrder() async {
    if (_packageId == null || _packageId!.isEmpty) {
      _showError('请从套餐详情页进入下单，系统将自动携带商品信息');
      return;
    }
    setState(() => _submitting = true);
    try {
      final repo = ref.read(orderRepositoryProvider);
      final dto = await repo.create(
        items: [
          {
            'item_type': 'PACKAGE',
            'ref_id': _packageId,
            'quantity': _adultCount,
            'unit_price': _adultPrice,
            'title': _productTitle,
          },
        ],
        paymentMethod: _paymentMethod,
      );
      if (!mounted) return;
      ref.invalidate(ordersListProvider);
      final amount =
          dto.totalAmount > 0 ? dto.totalAmount.toStringAsFixed(0) : _totalAmount.toString();
      final uri = Uri(
        path: '/payment',
        queryParameters: {
          'orderId': dto.id,
          'amount': amount,
          'title': _productTitle,
        },
      );
      context.push(uri.toString());
    } catch (e) {
      if (!mounted) return;
      _showError('创建订单失败：$e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n?.tourOrderTitle ?? '填写订单'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.iconOutlineOnLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 96.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductSummary(),
                  SizedBox(height: 10.h),
                  _buildCountSection(),
                  SizedBox(height: 10.h),
                  _buildOrderMetaSection(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProductSummary() {
    return Container(
      width: double.infinity,
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _productTitle,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _DateCell(
                  label: '出发日期',
                  value: '02月19日 周四',
                  alignEnd: false,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '7天6晚',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: _DateCell(
                  label: '结束日期',
                  value: '02月25日 周三',
                  alignEnd: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '行程套餐：[多巴胺南疆-盖冰城2]冬季拼车7日',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '24小时内确认：本产品付款后可快速确认，放心期待您的旅行',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF3FAF6C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountSection() {
    return Container(
      width: double.infinity,
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '出行人数',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '仅剩6个名额',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '成人 12周岁以上',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '¥$_adultPrice/人',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.price,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _CountStepper(
                valueText: '$_adultCount',
                onDecrease: () => _changeAdultCount(-1),
                onIncrease: () => _changeAdultCount(1),
                canDecrease: _adultCount > 1,
                canIncrease: _adultCount < 9,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            '需选1成人出游',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '请务必保障填写项与出游所持证件一致',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_rounded,
                size: 18.sp,
                color: AppColors.iconOutlineOnLight,
              ),
              label: Text(
                '添加出行人',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.iconOutlineOnLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide.none,
                backgroundColor: AppColors.primary,
                shape: const StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderMetaSection() {
    return Container(
      width: double.infinity,
      color: AppColors.card,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '订单信息',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Text(
                  '商品',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Text(
                    _productTitle,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<String>(
            value: _paymentMethod,
            decoration: const InputDecoration(labelText: '支付方式'),
            items: const [
              DropdownMenuItem(value: 'WECHAT', child: Text('微信支付')),
              DropdownMenuItem(value: 'ALIPAY', child: Text('支付宝')),
              DropdownMenuItem(value: 'CARD', child: Text('银行卡')),
              DropdownMenuItem(value: 'WALLET', child: Text('钱包')),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() => _paymentMethod = v);
            },
          ),
          if (_packageId == null || _packageId!.isEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              '请从套餐详情页点击“立即预订”进入本页',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h + bottomInset),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: AppShadow.heavy,
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: '总金额：'),
                  TextSpan(
                    text: '¥${_totalAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.priceLarge.copyWith(
                      color: AppColors.price,
                      fontSize: 30.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 166.w,
            height: 44.h,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.iconOutlineOnLight,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: _submitting
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '提交订单',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.label,
    required this.value,
    required this.alignEnd,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CountStepper extends StatelessWidget {
  const _CountStepper({
    required this.valueText,
    required this.onDecrease,
    required this.onIncrease,
    required this.canDecrease,
    required this.canIncrease,
  });

  final String valueText;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool canDecrease;
  final bool canIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(
          icon: Icons.remove_rounded,
          onTap: canDecrease ? onDecrease : null,
        ),
        SizedBox(width: 12.w),
        Text(
          valueText,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 12.w),
        _StepperButton(
          icon: Icons.add_rounded,
          onTap: canIncrease ? onIncrease : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: disabled ? AppColors.border : AppColors.primary,
            width: 1.2,
          ),
          color: AppColors.card,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: disabled ? AppColors.textDisabled : AppColors.primaryDark,
        ),
      ),
    );
  }
}
