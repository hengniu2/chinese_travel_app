import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/chat_message.dart';

/// 单条消息气泡（文本 / 图片 / 订单卡片）
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onOrderCardTap,
  });

  final ChatMessage message;
  final VoidCallback? onOrderCardTap;

  static String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: message.isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isFromMe) const Spacer(),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildContent(context),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(message.time),
                  style: AppTextStyles.label.copyWith(color: AppColors.textTertiary, fontSize: 11.sp),
                ),
              ],
            ),
          ),
          if (!message.isFromMe) const Spacer(),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (message.type) {
      case ChatMessageType.text:
        return _textBubble();
      case ChatMessageType.image:
        return _imageBubble();
      case ChatMessageType.orderCard:
        return _orderCardBubble();
    }
  }

  Widget _textBubble() {
    final bg = message.isFromMe ? AppColors.primary : AppColors.surface;
    final fg = message.isFromMe ? Colors.white : AppColors.textPrimary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: message.isFromMe ? Radius.circular(16.r) : Radius.circular(4.r),
          bottomRight: message.isFromMe ? Radius.circular(4.r) : Radius.circular(16.r),
        ),
      ),
      child: Text(
        message.text ?? '',
        style: AppTextStyles.bodyMedium.copyWith(color: fg),
      ),
    );
  }

  Widget _imageBubble() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
        bottomLeft: message.isFromMe ? Radius.circular(16.r) : Radius.circular(4.r),
        bottomRight: message.isFromMe ? Radius.circular(4.r) : Radius.circular(16.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 240.w, maxHeight: 180.h),
        child: message.imageUrl != null && message.imageUrl!.isNotEmpty
            ? Image.network(
                message.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(),
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 160.w,
      height: 120.h,
      color: AppColors.surface,
      child: Icon(Icons.image_not_supported_rounded, size: 40.sp, color: AppColors.textTertiary),
    );
  }

  Widget _orderCardBubble() {
    final card = message.orderCard!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOrderCardTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 260.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadow.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long_rounded, size: 18.sp, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Text('订单', style: AppTextStyles.label.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                card.title,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (card.subtitle != null && card.subtitle!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(card.subtitle!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 12.sp)),
                      Text(card.amount.toStringAsFixed(0), style: AppTextStyles.price.copyWith(fontSize: 16.sp)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(card.statusText, style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 11.sp)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
