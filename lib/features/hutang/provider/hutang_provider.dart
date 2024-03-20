import 'package:admin_hanaang/features/hutang/data/hutang_api.dart';
import 'package:admin_hanaang/features/hutang/provider/hutang_notifier.dart';
import 'package:admin_hanaang/features/hutang/provider/hutang_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/detail_hutang.dart';
import 'package:admin_hanaang/models/hutang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hutangNotifier =
    StateNotifierProvider<HutangNotifier, HutangState<Hutang>>((ref) {
  return HutangNotifier(ref.watch(hutangProvider));
});

final totalHutangNotifier =
    StateNotifierProvider<TotalHutangNotifier, States<int>>((ref) {
  return TotalHutangNotifier(ref.watch(hutangProvider));
});

final detailHutangNotifier =
    StateNotifierProvider<DetailHutangNotifier, HutangState<DetailHutang>>(
        (ref) {
  return DetailHutangNotifier(ref.watch(hutangProvider));
});
