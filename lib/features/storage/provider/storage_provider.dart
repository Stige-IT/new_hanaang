import 'package:admin_hanaang/features/storage/service/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});
