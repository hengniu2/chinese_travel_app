import 'package:flutter/material.dart';

/// 点击缩放动效（premium：200ms，easeInOut）
/// 用于可点击卡片、列表项、按钮；可选 hover 放大（桌面/Web）
class AppTapScale extends StatefulWidget {
  const AppTapScale({
    super.key,
    required this.child,
    this.onTap,
    this.enableHover = false,
    /// 按下时的缩放比例，默认 0.98；酒店等强调触感可用 0.96
    this.pressedScale = 0.98,
  });

  final Widget child;
  final VoidCallback? onTap;
  /// 桌面/Web 悬停时轻微放大（1.02）
  final bool enableHover;
  final double pressedScale;

  @override
  State<AppTapScale> createState() => _AppTapScaleState();
}

class _AppTapScaleState extends State<AppTapScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1, end: widget.pressedScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    if (widget.onTap != null) {
      content = GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    content = Listener(
      onPointerDown: (_) => _controller.forward(),
      onPointerUp: (_) => _controller.reverse(),
      onPointerCancel: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, c) => Transform.scale(
          scale: _scale.value,
          child: c,
        ),
        child: widget.enableHover
            ? MouseRegion(
                onEnter: (_) {},
                onExit: (_) {},
                child: content,
              )
            : content,
      ),
    );
    return content;
  }
}
