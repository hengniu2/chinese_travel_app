import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../domain/chat_message.dart';

/// 气泡圆角（中国主流 IM：尾巴侧小圆角）
class _BubbleRadius {
  static const double tail = 4;
  static const double normal = 14;
  static Radius get tailR => const Radius.circular(tail);
  static Radius get normalR => const Radius.circular(normal);

  /// 自己发的：尾巴在右下
  static BorderRadius get fromMe => BorderRadius.only(
        topLeft: normalR,
        topRight: normalR,
        bottomLeft: normalR,
        bottomRight: tailR,
      );
  /// 对方发的：尾巴在左下
  static BorderRadius get fromOther => BorderRadius.only(
        topLeft: normalR,
        topRight: normalR,
        bottomLeft: tailR,
        bottomRight: normalR,
      );
}

/// 单条消息气泡（文本 / 图片 / 订单卡片），含头像、时间
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.partnerAvatarUrl,
    this.showAvatar = true,
    this.onOrderCardTap,
  });

  final ChatMessage message;
  final String? partnerAvatarUrl;
  /// 是否显示对方头像（仅对来自对方的消息有效）
  final bool showAvatar;
  final VoidCallback? onOrderCardTap;

  static String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isFromMe = message.isFromMe;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isFromMe) const SizedBox.shrink(),
          if (!isFromMe) _buildAvatar(context),
          if (!isFromMe) SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildContent(context),
                SizedBox(height: 2.h),
                Text(
                  _formatTime(message.time),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (!showAvatar || message.isFromMe) return const SizedBox.shrink();
    final size = 42.w;
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: AppColors.primaryPale,
        backgroundImage: partnerAvatarUrl != null && partnerAvatarUrl!.isNotEmpty
            ? NetworkImage(partnerAvatarUrl!)
            : null,
        child: partnerAvatarUrl == null || partnerAvatarUrl!.isEmpty
            ? Text(
                '客',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              )
            : null,
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
        return _orderCardBubble(context);
    }
  }

  Widget _textBubble() {
    final isFromMe = message.isFromMe;
    final bg = isFromMe ? const Color(0xFF95EC69) : Colors.white;
    final fg = isFromMe ? AppColors.textPrimary : AppColors.textPrimary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: isFromMe ? _BubbleRadius.fromMe : _BubbleRadius.fromOther,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Text(
        message.text ?? '',
        style: AppTextStyles.bodyMedium.copyWith(color: fg, height: 1.4),
      ),
    );
  }

  Widget _imageBubble() {
    final isFromMe = message.isFromMe;
    return ClipRRect(
      borderRadius: isFromMe ? _BubbleRadius.fromMe : _BubbleRadius.fromOther,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 240.w, maxHeight: 180.h),
          child: message.imageUrl != null && message.imageUrl!.isNotEmpty
              ? AppNetworkImage(
                  imageUrl: message.imageUrl!,
                  width: 240.w,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorWidget: _imagePlaceholder(),
                )
              : _imagePlaceholder(),
        ),
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

  Widget _orderCardBubble(BuildContext context) {
    final card = message.orderCard!;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOrderCardTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 272.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryPale.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long_rounded, size: 18.sp, color: AppColors.primary),
                    SizedBox(width: 6.w),
                    Text(
                      l10n?.orderCardOrder ?? '订单',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (card.subtitle != null && card.subtitle!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        card.subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 10.h),
                    Divider(height: 1, color: AppColors.divider),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '¥',
                              style: AppTextStyles.priceLarge.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.price,
                              ),
                            ),
                            Text(
                              card.amount.toStringAsFixed(0),
                              style: AppTextStyles.priceLarge.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.price,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPale,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            card.statusText,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
