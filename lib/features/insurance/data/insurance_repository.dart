import '../../catalog/data/catalog_repository.dart';
import '../domain/insurance_detail.dart';
import '../domain/insurance_item.dart';

class InsuranceListResponse {
  const InsuranceListResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<InsuranceItem> items;
  final int total;
  final int page;
  final int pageSize;
}

/// Insurance repository backed by catalog API (GET /api/catalog/insurance, GET /api/catalog/insurance/:id).
class InsuranceRepository {
  InsuranceRepository(this._catalog);

  final CatalogRepository _catalog;

  Future<InsuranceListResponse> getList({
    int page = 1,
    int pageSize = 20,
    String? insuranceType,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    final res = await _catalog.getInsuranceList(
      page: page,
      pageSize: pageSize,
      insuranceType: insuranceType,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
    );
    final items = res.items.map(_mapToItem).toList();
    return InsuranceListResponse(
      items: items,
      total: res.total,
      page: res.page,
      pageSize: res.pageSize,
    );
  }

  Future<InsuranceDetail> getDetail(String id) async {
    final json = await _catalog.getInsurance(id);
    return _mapToDetail(json);
  }

  static InsuranceItem _mapToItem(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'])?.toString() ?? '';
    final name = json['name'] as String? ?? '旅行保险';
    final price = (json['price'] as num?)?.toDouble() ?? 0;
    return InsuranceItem(
      id: id,
      name: name,
      price: price,
      insuranceType: json['insurance_type'] as String?,
      validityDays: (json['validity_days'] as num?)?.toInt(),
      coverageAmount: (json['coverage_amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );
  }

  static InsuranceDetail _mapToDetail(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'])?.toString() ?? '';
    final name = json['name'] as String? ?? '旅行保险';
    final price = (json['price'] as num?)?.toDouble() ?? 0;
    final validityDays = (json['validity_days'] as num?)?.toInt() ?? 1;
    return InsuranceDetail(
      id: id,
      name: name,
      price: price,
      validityDays: validityDays,
      description: json['description'] as String?,
      insuranceType: json['insurance_type'] as String?,
      coverageAmount: (json['coverage_amount'] as num?)?.toDouble(),
    );
  }
}
