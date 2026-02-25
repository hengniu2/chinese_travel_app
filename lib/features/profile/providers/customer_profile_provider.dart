import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../data/customer_profile_repository.dart';
import '../data/customer_profile_repository_provider.dart';

/// Customer profile from API. Only valid when authenticated.
final customerProfileProvider = FutureProvider<CustomerProfileDto?>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return null;
  try {
    final repo = ref.read(customerProfileRepositoryProvider);
    return repo.getProfile();
  } catch (_) {
    return null;
  }
});

/// Call this after updating profile to refresh [customerProfileProvider].
void invalidateCustomerProfile(Ref ref) {
  ref.invalidate(customerProfileProvider);
}
