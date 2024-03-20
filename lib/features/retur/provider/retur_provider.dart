import 'package:admin_hanaang/features/retur/data/retur_api.dart';
import 'package:admin_hanaang/features/retur/provider/retur_notifier.dart';
import 'package:admin_hanaang/features/retur/provider/retur_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/retur.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final returProcessNotifier =
    StateNotifierProvider<ReturProcessNotifier, BaseState<List<Retur>>>((ref) {
  return ReturProcessNotifier(ref.watch(returProvider));
});
final returAcceptNotifier =
    StateNotifierProvider<ReturAcceptNotifier, ReturStates>((ref) {
  return ReturAcceptNotifier(ref.watch(returProvider));
});
final returRejectNotifier =
    StateNotifierProvider<ReturRejectNotifier, ReturStates>((ref) {
  return ReturRejectNotifier(ref.watch(returProvider));
});
final returFinishNotifier =
    StateNotifierProvider<ReturFinishNotifier, ReturStates>((ref) {
  return ReturFinishNotifier(ref.watch(returProvider));
});

final createAcceptReturNotifier =
    StateNotifierProvider<CreateAcceptReturNotifier, ReturState>((ref) {
  return CreateAcceptReturNotifier(ref.watch(returProvider), ref);
});

final rejectReturNotifier =
    StateNotifierProvider<RejectReturNotifier, States>((ref) {
  return RejectReturNotifier(ref.watch(returProvider), ref);
});

final takingReturNotifier =
    StateNotifierProvider<TakingReturNotifier, ReturState>((ref) {
  return TakingReturNotifier(ref.watch(returProvider), ref);
});

final totalReturNotifier = StateNotifierProvider<TotalReturNotifier,States<int>>((ref) {
  return TotalReturNotifier(ref.watch(returProvider));
});


final searchReturNotifier =
    StateNotifierProvider<SearchReturNotifier, States<List<Retur>>>((ref) {
  return SearchReturNotifier(ref.watch(returProvider));
});
