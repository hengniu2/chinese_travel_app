import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/design_system/app_text_styles.dart';
import '../../../../shared/design_system/app_top_bar.dart';

/// 用户协议页 / 隐私政策页（根据 type 参数展示不同内容）
class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key, this.type = 'user'});

  final String type;

  bool get _isPrivacy => type == 'privacy';

  String get _title => _isPrivacy ? '隐私政策' : '用户协议';

  @override
  Widget build(BuildContext context) {
    final appName = AppLocalizations.of(context)?.appTitle ?? '凌行天下旅行';
    return Scaffold(
      backgroundColor: AppColors.backgroundCard,
      appBar: AppTopBar(
        title: _title,
        onLeadingTap: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isPrivacy ? '$appName隐私政策' : '$appName用户协议',
                style: AppTextStyles.headlineMedium,
              ),
              SizedBox(height: 8.h),
              Text(
                '更新日期：2025年1月',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
              ),
              SizedBox(height: 24.h),
              ..._paragraphs.map((e) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      e.replaceAll('享梦游', appName),
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<String> get _paragraphs => _isPrivacy ? _privacyContent : _agreementContent;

  static const List<String> _agreementContent = [
    '欢迎您使用享梦游旅行服务。在使用我们的服务前，请您务必审慎阅读、充分理解本协议各条款。',
    '一、服务说明\n享梦游为您提供旅行线路预订、酒店预订、攻略内容等一站式旅行服务。您注册或使用本服务即视为同意本协议。',
    '二、账号注册\n您应提供真实、准确的手机号等信息。您需妥善保管账号与密码，因您保管不善导致的损失由您自行承担。',
    '三、用户行为规范\n您在使用服务时须遵守法律法规，不得发布违法违规信息、侵犯他人权益或干扰平台正常运营。',
    '四、知识产权\n本平台所载内容（包括但不限于文字、图片、界面设计等）的知识产权归享梦游或相关权利人所有。',
    '五、协议变更\n我们可能适时修订本协议，修订后将在应用内公示。若您继续使用服务，即视为接受修订后的协议。',
  ];

  static const List<String> _privacyContent = [
    '享梦游（以下简称「我们」）非常重视您的个人信息与隐私保护。本政策适用于享梦游 App 及相关服务。',
    '一、我们收集的信息\n为向您提供预订、客服、个性化推荐等服务，我们可能收集：手机号、昵称、行程信息、设备信息等。',
    '二、信息使用\n我们仅将您的信息用于：履行订单、改进产品、安全保障、法律要求等目的，不会出售您的个人信息。',
    '三、信息共享\n我们可能与合作伙伴共享必要信息以完成服务（如酒店、景区），并严格要求其保护您的信息。',
    '四、您的权利\n您有权查询、更正、删除您的个人信息，也可通过设置关闭部分权限或注销账号。',
    '五、政策更新\n我们可能更新本政策，更新后会通过应用内通知等方式告知您。',
  ];
}
