import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/data/catalog_repository_provider.dart';
import '../domain/ticket_detail.dart';
import 'ticket_repository.dart';

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  final catalog = ref.watch(catalogRepositoryProvider);
  return TicketRepository(catalog);
});

final ticketListProvider = FutureProvider.family<TicketListResponse, TicketListQuery>((ref, query) async {
  final repo = ref.watch(ticketRepositoryProvider);
  return repo.getList(
    page: query.page,
    pageSize: query.pageSize,
    location: query.location,
    minPrice: query.minPrice,
    maxPrice: query.maxPrice,
    ticketType: query.ticketType,
    sort: query.sort,
  );
});

class TicketListQuery {
  const TicketListQuery({
    this.page = 1,
    this.pageSize = 20,
    this.location,
    this.minPrice,
    this.maxPrice,
    this.ticketType,
    this.sort,
  });
  final int page;
  final int pageSize;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final String? ticketType;
  final String? sort;
}

final ticketDetailProvider = FutureProvider.family<TicketDetail, String>((ref, id) async {
  final repo = ref.watch(ticketRepositoryProvider);
  return repo.getDetail(id);
});
