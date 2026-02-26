import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/authenticated_dio.dart';
import '../domain/tour_detail.dart';
import '../domain/tour_item.dart';
import 'tour_repository.dart';

final tourRepositoryProvider = Provider<TourRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return TourRepository(dio);
});

/// 旅行团列表（分页 + 筛选）
final tourListProvider = FutureProvider.family<TourListResponse, TourListParams>((ref, params) async {
  final repo = ref.watch(tourRepositoryProvider);
  return repo.getList(
    page: params.page,
    pageSize: params.pageSize,
    minPrice: params.minPrice,
    maxPrice: params.maxPrice,
    minDays: params.minDays,
    maxDays: params.maxDays,
    region: params.region,
    sort: params.sort,
  );
});

class TourListParams {
  const TourListParams({
    this.page = 1,
    this.pageSize = 20,
    this.minPrice,
    this.maxPrice,
    this.minDays,
    this.maxDays,
    this.region,
    this.sort,
  });
  final int page;
  final int pageSize;
  final double? minPrice;
  final double? maxPrice;
  final int? minDays;
  final int? maxDays;
  final String? region;
  final String? sort;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TourListParams &&
            other.page == page &&
            other.pageSize == pageSize &&
            other.minPrice == minPrice &&
            other.maxPrice == maxPrice &&
            other.minDays == minDays &&
            other.maxDays == maxDays &&
            other.region == region &&
            other.sort == sort);
  }

  @override
  int get hashCode => Object.hash(
    page,
    pageSize,
    minPrice,
    maxPrice,
    minDays,
    maxDays,
    region,
    sort,
  );
}

/// 旅行团详情
final tourDetailProvider = FutureProvider.family<TourDetail, String>((ref, id) async {
  final repo = ref.watch(tourRepositoryProvider);
  return repo.getDetail(id);
});
