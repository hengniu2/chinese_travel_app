import 'package:flutter/material.dart';

import 'hotels_list_page.dart';

/// 酒店壳页（展示酒店列表 + 筛选）
class HotelsShellPage extends StatelessWidget {
  const HotelsShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HotelsListPage();
  }
}
