import 'dart:io';

import 'package:admin_hanaang/features/unit/provider/unit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/unit_api.dart';
import 'unit_provider.dart';

class UnitsNotifier extends StateNotifier<UnitState> {
  final UnitApi _unitApi;

  UnitsNotifier(this._unitApi) : super(UnitState.noState());

  Future<void> getUnits() async {
    state = UnitState.loading();
    final result = await _unitApi.getUnits();
    result.fold(
      (error) => state = UnitState.error(error),
      (data) => state = UnitState.finished(data: data),
    );
  }
}

class UnitNotifier extends StateNotifier<UnitState> {
  final UnitApi _unitApi;

  UnitNotifier(this._unitApi) : super(UnitState.noState());

  Future<void> getUnit(String unitId) async {
    state = UnitState.loading();
    final result = await _unitApi.getUnit(unitId);
    result.fold(
      (error) => state = UnitState.error(error),
      (data) => state = UnitState.finished(data: [data]),
    );
  }
}

class CreateUnitNotifier extends StateNotifier<UnitState> {
  final UnitApi _unitApi;
  final Ref ref;

  CreateUnitNotifier(this._unitApi, this.ref) : super(UnitState.noState());

  Future<bool> createUnit({required String name}) async {
    state = UnitState.loading();
    final result = await _unitApi.createUnit(name: name);
    return result.fold(
      (error) {
        state = UnitState.error(error);
        return false;
      },
      (status) {
        ref.watch(unitsNotifier.notifier).getUnits();
        state = UnitState.finished();
        return true;
      },
    );
  }
}

class UpdateUnitNotifier extends StateNotifier<UnitState> {
  final UnitApi _unitApi;
  final Ref ref;

  UpdateUnitNotifier(this._unitApi, this.ref) : super(UnitState.noState());

  Future<bool> updateUnit(String unitId, {required String name}) async {
    state = UnitState.loading();
    final result = await _unitApi.updateUnit(unitId, name: name);
    return result.fold(
      (error) {
        state = UnitState.error(error);
        return false;
      },
      (status) {
        ref.watch(unitsNotifier.notifier).getUnits();
        state = UnitState.finished();
        return true;
      },
    );
  }
}

class DeleteUnitNotifier extends StateNotifier<UnitState> {
  final UnitApi _unitApi;
  final Ref ref;

  DeleteUnitNotifier(this._unitApi, this.ref) : super(UnitState.noState());

  Future<bool> deleteeUnit(String unitId) async {
    state = UnitState.loading();
    try {
      final result = await _unitApi.deleteUnit(unitId);
      return result.fold(
        (error) {
          state = UnitState.error(error);
          return false;
        },
        (status) {
          ref.watch(unitsNotifier.notifier).getUnits();
          state = UnitState.finished();
          return true;
        },
      );
    } on SocketException {
      state = UnitState.error("Tidak ada internet");
      return false;
    }
  }
}
