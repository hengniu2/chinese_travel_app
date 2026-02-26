import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../../catalog/data/catalog_repository.dart';
import '../../catalog/data/catalog_repository_provider.dart';
import '../models/companion_list_item.dart';
import 'companion_api_mapper.dart';

/// Companion list from catalog API. Optional location filter.
final companionListFromApiProvider = FutureProvider.family<List<CompanionListItem>, String?>((ref, location) async {
  try {
    final repo = ref.read(catalogRepositoryProvider);
    final res = await repo.getCompanions(
      page: 1,
      pageSize: 50,
      location: location?.isNotEmpty == true ? location : null,
    );
    return res.items.map((e) => companionListItemFromApi(e)).toList();
  } catch (_) {
    return [];
  }
});
