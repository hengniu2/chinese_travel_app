import 'package:flutter/material.dart';

import 'search_bar_yellow.dart';

/// Stateful wrapper for [SearchBarYellow] that shows clear button when text is not empty.
/// Use this when you don't control [TextEditingController] from parent.
class SearchBarYellowStateful extends StatefulWidget {
  const SearchBarYellowStateful({
    super.key,
    this.controller,
    this.hintText = '搜索酒店、目的地',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.leadingIcon = Icons.search_rounded,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final IconData leadingIcon;

  @override
  State<SearchBarYellowStateful> createState() => _SearchBarYellowStatefulState();
}

class _SearchBarYellowStatefulState extends State<SearchBarYellowStateful> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(SearchBarYellowStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_onTextChanged);
      _controller = widget.controller!;
      _controller.addListener(_onTextChanged);
      _hasText = _controller.text.isNotEmpty;
    }
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBarYellow(
      controller: _controller,
      hintText: widget.hintText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      leadingIcon: widget.leadingIcon,
      suffixIcon: _hasText
          ? SearchBarYellowClearButton(onPressed: _clear)
          : null,
    );
  }
}
