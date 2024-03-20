import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/suplayer/data/suplayer_api.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_notifier.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/suplayer.dart';

final suplayerNotifier =
    StateNotifierProvider<SuplayerNotifier, SuplayerState>((ref) {
  return SuplayerNotifier(ref.watch(suplayerProvider));
});

final createSuplayerNotifier =
    StateNotifierProvider<CreateSuplayerNotifier, States>((ref) {
  return CreateSuplayerNotifier(ref.watch(suplayerProvider), ref);
});

final deleteSuplayerNotifier =
    StateNotifierProvider<DeleteSuplayerNotifier, States>((ref) {
  return DeleteSuplayerNotifier(ref.watch(suplayerProvider), ref);
});

final suplayerByIdNotifier =
    StateNotifierProvider<SuplayerByIdNotifier, States<Suplayer>>((ref) {
  return SuplayerByIdNotifier(ref.watch(suplayerProvider));
});
