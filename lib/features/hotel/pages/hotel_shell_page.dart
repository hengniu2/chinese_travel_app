import 'package:flutter/material.dart';

import 'hotel_list_page.dart';

/// Shell for hotel flow (list + filter).
class HotelShellPage extends StatelessWidget {
  const HotelShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HotelListPage();
  }
}
