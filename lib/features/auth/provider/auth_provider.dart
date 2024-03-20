import 'package:admin_hanaang/features/auth/data/auth_api.dart';
import 'package:admin_hanaang/features/auth/provider/auth_notifier.dart';
import 'package:admin_hanaang/features/storage/provider/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';

final authNotifier = StateNotifierProvider<AuthNotifier, States<String>>((ref) {
  return AuthNotifier(ref.watch(authApiProvider), ref.watch(storageProvider));
});
