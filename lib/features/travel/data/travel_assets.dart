import 'package:flutter/material.dart';

/// Travel Planner asset paths. Must be distinct from Home header (header_cartoon_spring_travel.png).
const String kPlannerHeaderImageAsset = 'assets/header_planner_ai.png';

/// Theme-based destination recommendations for adaptive UI.
class ThemeDestinations {
  ThemeDestinations._();

  /// 海岛 → Maldives, Bali, Phuket first
  static const List<String> island = ['马尔代夫', '巴厘岛', '普吉岛', '日本', '泰国', '厦门', '海南'];

  /// 亲子 → Disneyland, Sanya, Singapore first
  static const List<String> family = ['迪士尼', '三亚', '新加坡', '北京', '杭州', '成都', '广州'];

  /// 探险 → Xinjiang, Tibet, Iceland first
  static const List<String> adventure = ['新疆', '西藏', '冰岛', '云南', '西安', '桂林', '稻城'];

  /// Default/fallback destinations
  static const List<String> defaultList = ['杭州', '成都', '云南', '北京', '厦门', '日本', '泰国', '新疆'];

  /// Get destinations ordered by selected themes. Priority: 海岛 > 亲子 > 探险.
  static List<String> forThemes(List<String> themes) {
    if (themes.contains('海岛')) return island;
    if (themes.contains('亲子')) return family;
    if (themes.contains('探险')) return adventure;
    return defaultList;
  }

  /// Hero gradient overlay colors per theme (for dynamic hero background).
  static List<Color> heroGradientForTheme(List<String> themes) {
    if (themes.contains('海岛')) return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
    if (themes.contains('亲子')) return [const Color(0xFFFFB347), const Color(0xFFFFCC80)];
    if (themes.contains('探险')) return [const Color(0xFF8D6E63), const Color(0xFFA1887F)];
    return [const Color(0xFF7CB87C), const Color(0xFFB8E06C)];
  }
}
