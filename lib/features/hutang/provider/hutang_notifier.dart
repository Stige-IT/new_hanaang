import 'package:admin_hanaang/features/hutang/provider/hutang_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/detail_hutang.dart';
import 'package:admin_hanaang/models/hutang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/hutang_api.dart';

class HutangNotifier extends StateNotifier<HutangState<Hutang>> {
  final HutangApi _hutangApi;

  HutangNotifier(this._hutangApi) : super(HutangState.noState());

  Future<void> getHutang() async {
    state = HutangState.loading();
    final result = await _hutangApi.getHutang();
    result.fold(
      (error) => state = HutangState.error(error),
      (data) => state = HutangState<Hutang>.finished(data),
    );
  }
}

class TotalHutangNotifier extends StateNotifier<States<int>> {
  final HutangApi _hutangApi;

  TotalHutangNotifier(this._hutangApi) : super(States.noState());

  Future<void> getTotalHutang() async {
    state = States.loading();
    final result = await _hutangApi.getTotalHutang();
    result.fold(
      (error) => state = States.error(error),
      (data) => state = States.finished(data),
    );
  }
}

class DetailHutangNotifier extends StateNotifier<HutangState<DetailHutang>> {
  final HutangApi _hutangApi;

  DetailHutangNotifier(this._hutangApi) : super(HutangState.noState());

  Future<void> getDetailHutang(String hutangId) async {
    state = HutangState.loading();
    final result = await _hutangApi.getDetailHutang(hutangId);
    result.fold(
      (error) => state = HutangState.error(error),
      (data) => state = HutangState<DetailHutang>.finished(data),
    );
  }
}
