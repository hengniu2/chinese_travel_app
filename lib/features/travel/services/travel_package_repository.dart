import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import 'travel_package_data_source.dart';

/// Repository for travel packages. Fetches from data source; can apply filter in future.
class TravelPackageRepository {
  TravelPackageRepository(this._dataSource);

  final TravelPackageDataSource _dataSource;

  Future<List<TravelPackage>> getPackages() => _dataSource.getPackages();

  Future<TravelPackage?> getPackageById(String id) =>
      _dataSource.getPackageById(id);
}

final travelPackageRepositoryProvider = Provider<TravelPackageRepository>((ref) {
  final dataSource = ref.watch(travelPackageDataSourceProvider);
  return TravelPackageRepository(dataSource);
});
