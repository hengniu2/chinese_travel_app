import 'package:flutter/material.dart';

/// 出行服务 - 机票 | 火车 | 接送机
class TravelServicePage extends StatefulWidget {
  const TravelServicePage({super.key});

  @override
  State<TravelServicePage> createState() => _TravelServicePageState();
}

class _TravelServicePageState extends State<TravelServicePage>
    with SingleTickerProviderStateMixin {
  static const Color _yellowAccent = Color(0xFFFFEE58);
  static const Color _unselectedGrey = Color(0xFF9E9E9E);

  static const Duration _entranceDuration = Duration(milliseconds: 400);
  static const Offset _slideBegin = Offset(0, 0.1);

  late final AnimationController _entranceController;
  late final Animation<double> _entranceOpacity;
  late final Animation<Offset> _entranceSlide;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: _entranceDuration,
      vsync: this,
    );
    final curved = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _entranceOpacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _entranceSlide = Tween<Offset>(
      begin: _slideBegin,
      end: Offset.zero,
    ).animate(curved);
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (entrance animation)
            FadeTransition(
              opacity: _entranceOpacity,
              child: SlideTransition(
                position: _entranceSlide,
                child: _buildHeader(),
              ),
            ),
            // Tabs (entrance animation)
            FadeTransition(
              opacity: _entranceOpacity,
              child: SlideTransition(
                position: _entranceSlide,
                child: Material(
                  color: const Color(0xFFFFFDF5),
                  child: TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: _unselectedGrey,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: _yellowAccent,
                        width: 3,
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: '单程'),
                      Tab(text: '往返'),
                      Tab(text: '多程'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF7F9FC),
                  child: TabBarView(
                    children: [
                      _buildOneWayTab(),
                      _buildEmptyTabChild(),
                      _buildEmptyTabChild(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF176),
            Color(0xFFFFEE58),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '出行服务',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '机票 · 火车 · 接送机 · 包车',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 单程 tab: search form card (with entrance animation).
  Widget _buildOneWayTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeTransition(
              opacity: _entranceOpacity,
              child: SlideTransition(
                position: _entranceSlide,
                child: _buildSearchFormCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// White card: search form fields (UI only).
  static Widget _buildSearchFormCard() {
    const double fieldHeight = 56;
    const double fieldRadius = 14;
    const Color fieldBg = Color(0xFFF5F5F5); // #F5F5F5
    const double gap = 16;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _formField(
            height: fieldHeight,
            radius: fieldRadius,
            bg: fieldBg,
            icon: Icons.flight_takeoff_rounded,
            label: '出发',
            trailing: Icon(Icons.swap_vert_rounded, size: 22, color: Colors.grey[600]),
          ),
          SizedBox(height: gap),
          _formField(
            height: fieldHeight,
            radius: fieldRadius,
            bg: fieldBg,
            icon: Icons.flight_land_rounded,
            label: '到达',
            trailing: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey[600]),
          ),
          SizedBox(height: gap),
          _formField(
            height: fieldHeight,
            radius: fieldRadius,
            bg: fieldBg,
            icon: Icons.calendar_today_rounded,
            label: '日期',
            trailing: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey[600]),
          ),
          SizedBox(height: gap),
          _formField(
            height: fieldHeight,
            radius: fieldRadius,
            bg: fieldBg,
            icon: Icons.person_outline_rounded,
            label: '成人/儿童',
            trailing: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey[600]),
          ),
          SizedBox(height: gap),
          _formField(
            height: fieldHeight,
            radius: fieldRadius,
            bg: fieldBg,
            icon: Icons.airline_seat_recline_extra_rounded,
            label: '舱位',
            trailing: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey[600]),
          ),
          SizedBox(height: gap),
          _formField(
            height: fieldHeight,
            radius: fieldRadius,
            bg: fieldBg,
            icon: Icons.flight_rounded,
            label: '航司',
            trailing: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const _SearchButton(),
        ],
      ),
    );
  }

  static Widget _formField({
    required double height,
    required double radius,
    required Color bg,
    required IconData icon,
    required String label,
    required Widget trailing,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  /// Empty scrollable container per tab.
  static Widget _buildEmptyTabChild() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [],
        ),
      ),
    );
  }
}

/// Search button with gradient, shadow and tap scale animation.
class _SearchButton extends StatefulWidget {
  const _SearchButton();

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  bool _pressed = false;

  static const Color _gradientStart = Color(0xFFFFD54F);
  static const Color _gradientEnd = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // Search action (no logic yet)
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_gradientStart, _gradientEnd],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _gradientEnd.withValues(alpha: 0.3),
                offset: const Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            '搜索',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
