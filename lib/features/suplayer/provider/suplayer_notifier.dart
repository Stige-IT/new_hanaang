import 'dart:io';

import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/features/suplayer/data/suplayer_api.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_provider.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_state.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/suplayer.dart';

class SuplayerNotifier extends StateNotifier<SuplayerState> {
  SuplayerNotifier(this.api) : super(SuplayerState.noState());
  final SuplayerApi api;

  getSuplayer() async {
    state = SuplayerState.loading();
    final result = await api.getSuplayerData();
    result.fold(
      (l) => state = SuplayerState.error(l),
      (r) => state = SuplayerState.finished(r),
    );
  }
}

class CreateSuplayerNotifier extends StateNotifier<States> {
  final Ref ref;
  final SuplayerApi _suplayerApi;

  CreateSuplayerNotifier(this._suplayerApi, this.ref) : super(States.noState());

  Future<bool> createSuplayer(
    bool isActiveAddress, {
    File? image,
    String? name,
    String? phoneNumber,
    int? idProvince,
    int? idRegency,
    int? idDistrict,
    int? idVillage,
    String? detail,
  }) async {
    state = States.loading();
    try {
      final result = await _suplayerApi.createSuplayer(
        isActiveAddress,
        image: image,
        name: name,
        phoneNumber: phoneNumber,
        idProvince: idProvince,
        idRegency: idRegency,
        idDistrict: idDistrict,
        idVillage: idVillage,
        detail: detail,
      );
      state = result.fold(
        (error) => States.error(error),
        (pass) {
          ref.watch(suplayerNotifier.notifier).getSuplayer();
          return States.noState();
        },
      );
      return result.isRight();
    } catch(e){
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }

  Future<bool> updateSuplayer(
    String suplayerId, {
    File? image,
    String? name,
    String? phoneNumber,
    int? idProvince,
    int? idRegency,
    int? idDistrict,
    int? idVillage,
    String? detail,
  }) async {
    state = States.loading();
    try {
      final result = await _suplayerApi.updateSuplayer(
        suplayerId,
        image: image,
        name: name,
        phoneNumber: phoneNumber,
        idProvince: idProvince,
        idRegency: idRegency,
        idDistrict: idDistrict,
        idVillage: idVillage,
        detail: detail,
      );
      state = result.fold(
        (error) => States.error(error),
        (pass) {
          ref.watch(suplayerByIdNotifier.notifier).getSuplayer(suplayerId);
          return States.noState();
        },
      );
      return result.isRight();
    } catch(e) {
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}

class SuplayerByIdNotifier extends StateNotifier<States<Suplayer>> {
  SuplayerByIdNotifier(this.api) : super(States.noState());
  final SuplayerApi api;

  getSuplayer(String suplayerId) async {
    state = States.loading();
    try {
      final result = await api.getSuplayerDataById(suplayerId);
      result.fold(
        (error) => state = States.error(error),
        (suplayer) => state = States.finished(suplayer),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class DeleteSuplayerNotifier extends StateNotifier<States> {
  final Ref ref;
  final SuplayerApi _suplayerApi;
  DeleteSuplayerNotifier(this._suplayerApi, this.ref) : super(States.noState());

  Future<bool> deleteSuplayer(String idSuplayer) async {
    state = States.loading();
    try {
      final result = await _suplayerApi.deleteSuplayer(idSuplayer);
      state = result.fold(
        (error) => States.error(error),
        (succes) {
          ref.read(suplayerNotifier.notifier).getSuplayer();
          ref.read(suplayerByIdNotifier.notifier).getSuplayer(idSuplayer);
          return States.noState();
        },
      );
      return result.isRight();
    } catch (e) {
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}
