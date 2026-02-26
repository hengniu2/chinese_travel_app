import '../../catalog/data/catalog_repository.dart';
import '../domain/ticket_detail.dart';
import '../domain/ticket_item.dart';

/// Paginated list response for tickets.
class TicketListResponse {
  const TicketListResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<TicketItem> items;
  final int total;
  final int page;
  final int pageSize;
}

/// Ticket repository backed by catalog API (GET /api/catalog/tickets, GET /api/catalog/tickets/:id).
class TicketRepository {
  TicketRepository(this._catalog);

  final CatalogRepository _catalog;

  Future<TicketListResponse> getList({
    int page = 1,
    int pageSize = 20,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? ticketType,
    String? sort,
  }) async {
    final res = await _catalog.getTickets(
      page: page,
      pageSize: pageSize,
      location: location,
      minPrice: minPrice,
      maxPrice: maxPrice,
      ticketType: ticketType,
      sort: sort,
    );
    final items = res.items.map(_mapToItem).toList();
    return TicketListResponse(
      items: items,
      total: res.total,
      page: res.page,
      pageSize: res.pageSize,
    );
  }

  Future<TicketDetail> getDetail(String id) async {
    final json = await _catalog.getTicket(id);
    return _mapToDetail(json);
  }

  static TicketItem _mapToItem(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'])?.toString() ?? '';
    final name = json['attraction_name'] as String? ?? '景区门票';
    final price = (json['price'] as num?)?.toDouble() ?? 0;
    final location = json['location'] as String?;
    final ticketType = json['ticket_type'] as String?;
    final validityDays = (json['validity_days'] as num?)?.toInt();
    final description = json['description'] as String?;
    return TicketItem(
      id: id,
      attractionName: name,
      price: price,
      location: location,
      ticketType: ticketType,
      validityDays: validityDays,
      description: description,
    );
  }

  static TicketDetail _mapToDetail(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'])?.toString() ?? '';
    final name = json['attraction_name'] as String? ?? '景区门票';
    final price = (json['price'] as num?)?.toDouble() ?? 0;
    return TicketDetail(
      id: id,
      attractionName: name,
      price: price,
      description: json['description'] as String?,
      location: json['location'] as String?,
      ticketType: json['ticket_type'] as String?,
      validityDays: (json['validity_days'] as num?)?.toInt(),
    );
  }
}
