import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';
import '../../domain/companion_order.dart';

/// 单条随行人员/入住人信息卡（姓名、身份证、手机号）
class TravelerFormCard extends StatefulWidget {
  const TravelerFormCard({
    super.key,
    required this.traveler,
    required this.index,
    required this.onChanged,
    this.onRemove,
    this.canRemove = true,
    this.labelPrefix = '随行人员',
  });

  final TravelerInfo traveler;
  final int index;
  final ValueChanged<TravelerInfo> onChanged;
  final VoidCallback? onRemove;
  final bool canRemove;
  /// 标题前缀，如「随行人员」「入住人」
  final String labelPrefix;

  @override
  State<TravelerFormCard> createState() => _TravelerFormCardState();
}

class _TravelerFormCardState extends State<TravelerFormCard> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.traveler.name);
    _idController = TextEditingController(text: widget.traveler.idCard);
    _phoneController = TextEditingController(text: widget.traveler.phone);
    _nameController.addListener(_notify);
    _idController.addListener(_notify);
    _phoneController.addListener(_notify);
  }

  @override
  void didUpdateWidget(TravelerFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.traveler != widget.traveler && widget.traveler.name == _nameController.text && widget.traveler.idCard == _idController.text && widget.traveler.phone == _phoneController.text) {
      // parent replaced traveler ref, sync if needed
    }
  }

  void _notify() {
    widget.onChanged(TravelerInfo(
      name: _nameController.text,
      idCard: _idController.text,
      phone: _phoneController.text,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.labelPrefix} ${widget.index + 1}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              if (widget.canRemove && widget.onRemove != null)
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, size: 22, color: AppColors.error),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
            ],
          ),
          SizedBox(height: 12),
          AuthInputField(
            controller: _nameController,
            label: '姓名',
            hint: '请输入真实姓名',
            onChanged: (_) {},
          ),
          SizedBox(height: 12),
          AuthInputField(
            controller: _idController,
            label: '身份证',
            hint: '请输入身份证号',
            keyboardType: TextInputType.text,
            maxLength: 18,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9Xx]'))],
            onChanged: (_) {},
          ),
          SizedBox(height: 12),
          AuthInputField(
            controller: _phoneController,
            label: '手机号',
            hint: '请输入手机号',
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}
