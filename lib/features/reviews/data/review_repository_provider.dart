import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/authenticated_dio.dart';
import 'review_repository.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return ReviewRepository(dio);
});

final myReviewsListProvider = FutureProvider<ReviewListResponse>((ref) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.listMy(page: 1, pageSize: 50);
});
