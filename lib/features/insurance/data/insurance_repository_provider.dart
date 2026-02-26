import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/data/catalog_repository_provider.dart';
import '../domain/insurance_detail.dart';
import 'insurance_repository.dart';

final insuranceRepositoryProvider = Provider<InsuranceRepository>((ref) {
  final catalog = ref.watch(catalogRepositoryProvider);
  return InsuranceRepository(catalog);
});

final insuranceListProvider = FutureProvider<InsuranceListResponse>((ref) async {
  final repo = ref.watch(insuranceRepositoryProvider);
  return repo.getList(page: 1, pageSize: 30);
});

final insuranceDetailProvider = FutureProvider.family<InsuranceDetail, String>((ref, id) async {
  final repo = ref.watch(insuranceRepositoryProvider);
  return repo.getDetail(id);
});
