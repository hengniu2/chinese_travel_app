import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/authenticated_dio.dart';
import 'customer_profile_repository.dart';

final customerProfileRepositoryProvider = Provider<CustomerProfileRepository>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return CustomerProfileRepository(dio);
});
