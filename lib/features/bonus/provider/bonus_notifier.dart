import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/bonus/data/bonus_api.dart';
import 'package:admin_hanaang/features/bonus/provider/bonus_provider.dart';
import 'package:admin_hanaang/models/bonus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';

class BonusNotifier extends StateNotifier<States<List<Bonus>>> {
  BonusNotifier(this.api) : super(States.noState());

  final BonusApi api;

  Future getBonus({String? title, bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = States.loading();
    }
    try {
      final result = await api.getBonus(title: title);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      log(e.toString());
      return false;
    }
  }
}

class CreateBonusNotifier extends StateNotifier<States> {
  CreateBonusNotifier(this.api, this.ref) : super(States.noState());

  final BonusApi api;
  final Ref ref;

  Future<bool> createBonus({
    required String bonusType,
    required String minimumOrder,
    required String numberOfBonus,
  }) async {
    state = States.loading();
    try {
      final result = await api.createBonus(
        bonusType: bonusType,
        minimumOrder: minimumOrder,
        numberOfBonus: numberOfBonus,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final typeBonus = ref.read(typeIdBonusProvider);
          ref.read(bonusNotifierProvider.notifier).getBonus(title: typeBonus);
          state = States.noState();
          return true;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      log(e.toString());
      return false;
    }
  }
}

class UpdateBonusNotifier extends StateNotifier<States> {
  UpdateBonusNotifier(this.api, this.ref) : super(States.noState());

  final BonusApi api;
  final Ref ref;

  Future<bool> updateBonus(
    String id, {
    required String bonusType,
    required String minimumOrder,
    required String numberOfBonus,
  }) async {
    state = States.loading();
    try {
      final result = await api.updateBonusById(
        id,
        bonusType: bonusType,
        minimumOrder: minimumOrder,
        numberOfBonus: numberOfBonus,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final typeBonus = ref.read(typeIdBonusProvider);
          ref.read(bonusNotifierProvider.notifier).getBonus(title: typeBonus);
          state = States.noState();
          return true;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      log(e.toString());
      return false;
    }
  }
}

class DeleteBonusNotifier extends StateNotifier<States> {
  DeleteBonusNotifier(this.api, this.ref) : super(States.noState());

  final BonusApi api;
  final Ref ref;

  Future<bool> deleteBonus(String id) async {
    state = States.loading();
    try {
      final result = await api.deleteBonus(id);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final typeBonus = ref.read(typeIdBonusProvider);
          ref.read(bonusNotifierProvider.notifier).getBonus(title: typeBonus);
          state = States.noState();
          return true;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      log(e.toString());
      return false;
    }
  }
}

class CheckBonusNotifier extends StateNotifier<int> {
  CheckBonusNotifier(this.api) : super(0);

  final BonusApi api;

  Future checkBonus(String userId, int quantity) async {
    final result = await api.checkBonus(userId, quantity);
    result.fold(
      (l) => state = 0,
      (r) => state = r,
    );
  }
}
