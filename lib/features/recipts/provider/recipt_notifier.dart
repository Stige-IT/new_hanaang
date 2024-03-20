import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/recipts/provider/recipt_provider.dart';
import 'package:admin_hanaang/models/recipt.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/item_reciept.dart';
import '../../../models/recipt_detail.dart';
import '../../state.dart';
import '../data/recipt_api.dart';

class ReciptsNotifier extends StateNotifier<BaseState<List<Recipt>>> {
  final ReciptApi _reciptApi;

  ReciptsNotifier(this._reciptApi) : super(const BaseState());

  Future getRecipts({int? page}) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _reciptApi.getRecipts(page: page ?? state.page);
      result.fold((error) {
        state = state.copyWith(isLoading: false, error: error);
      },
          (response) => state = state.copyWith(
                isLoading: false,
                error: null,
                data: response['data'],
                page: response['current_page'],
                lastPage: response['last_page'],
              ));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: exceptionTomessage(e));
    }
  }

  void refresh() {
    state = state.copyWith(page: 1);
    getRecipts();
  }

  void getMore() async {
    state = state.copyWith(isLoadingMore: true, page: state.page + 1);
    try {
      final result = await _reciptApi.getRecipts(page: state.page);
      result.fold((error) {
        log(error);
        state = state.copyWith(isLoading: false, error: error);
      },
          (response) => state = state.copyWith(
                isLoadingMore: false,
                error: null,
                data: [...state.data!, ...response['data']],
                page: response['current_page'],
                lastPage: response['last_page'],
              ));
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    } catch (e) {
      log(e.toString());
      state = state.copyWith(isLoading: false, error: "Masalah pada sistem");
    }
  }
}

class ReciptNotifier extends StateNotifier<States<ReciptDetail>> {
  final ReciptApi _reciptApi;

  ReciptNotifier(this._reciptApi) : super(States.noState());

  Future getRecipt(String reciptId) async {
    state = States.loading();
    try {
      final result = await _reciptApi.getRecipt(reciptId);
      result.fold(
        (error) {
          state = States.error(error);
          throw Exception(error);
        },
        (data) => state = States.finished(data),
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
    } catch (e) {
      log(e.toString());
      state = States.error("Masalah pada sistem");
    }
  }
}

class CreateReciptNotifier extends StateNotifier<States> {
  final ReciptApi _reciptApi;
  final Ref ref;

  CreateReciptNotifier(this._reciptApi, this.ref) : super(States.noState());

  Future<bool> createRecipt(List<ItemRecipt> recipt) async {
    state = States.loading();
    try {
      final result = await _reciptApi.createRecipt(recipt);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          ref.read(reciptsNotifer.notifier).getRecipts();
          state = States.noState();
          return status;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      log(e.toString());
      state = States.error("Masalah pada sistem");
      return false;
    }
  }
}

class DataNotifier extends StateNotifier<List<ItemRecipt>> {
  DataNotifier() : super([]);

  addData(ItemRecipt data) {
    state = [data, ...state];
  }

  editData(String id, {required ItemRecipt data}) {
    List<ItemRecipt> oldData = state;
    int index = oldData.indexWhere((element) => element.id == id);
    oldData[index] = data;
    state = [];
    state = oldData;
  }

  removeData(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}

class DataItemNotifier extends StateNotifier<List<ItemMaterial>> {
  DataItemNotifier() : super([]);

  addData(ItemMaterial data) {
    state = [...state, data];
  }

  editData(String id, {required ItemMaterial data}) {
    List<ItemMaterial> oldData = state;
    int index = oldData.indexWhere((element) => element.id == id);
    oldData[index] = data;
    state = [];
    state = oldData;
  }

  removeData(String id) {
    state = state.where((element) => element.id != id).toList();
  }
}
