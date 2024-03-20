import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/penerimaan_barang/provider/penerimaan_barang_provider.dart';
import 'package:admin_hanaang/features/penerimaan_barang/provider/penerimaan_barang_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/penerimaan_barang/detail_penerimaan_barang.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/penerimaan_barang_api.dart';

class PenerimaanBarangNotifier extends StateNotifier<PenerimaanBarangState> {
  final PenerimaanBarangApi _penerimaanBarangApi;

  PenerimaanBarangNotifier(this._penerimaanBarangApi)
      : super(const PenerimaanBarangState());

  Future<void> getData({int? initPage, bool? makeLoading}) async {
    try {
      if (makeLoading != null && makeLoading) {
        state = state.copyWith(isLoading: true);
      }
      final result = await _penerimaanBarangApi.getData(page: initPage ?? state.page);
      result.fold(
        (error) =>
            state = state.copyWith(errorMessage: error, isLoading: false),
        (response) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: null,
            data: response['data'],
            page: response['current_page'],
            totalPage: response['last_page'],
          );
        },
      );
    } catch (exception) {
      state =
          state.copyWith(errorMessage: exceptionTomessage(exception), isLoading: false);
    }
  }

  loadMoreData() async {
    state = state.copyWith(isLoadingMore: true);
    final result = await _penerimaanBarangApi.getData(page: state.page);
    result.fold(
      (error) => state = state.copyWith(isLoadMoreError: true),
      (response) => state = state.copyWith(
        page: state.page! + 1,
        data: [...state.data!, ...response['data']],
        isLoadingMore: false,
      ),
    );
  }

  Future<void> refresh({bool? makeLoading}) async {
    getData(initPage: 1, makeLoading: makeLoading);
  }
}

class DetailPenerimaanBarangNotifier
    extends StateNotifier<BaseState<DetailPenerimaanBarang>> {
  final PenerimaanBarangApi _penerimaanBarangApi;
  DetailPenerimaanBarangNotifier(this._penerimaanBarangApi)
      : super(const BaseState());

  Future<void> getDetailData(String barangId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _penerimaanBarangApi.getDetailData(barangId);
      result.fold(
        (error) => state = state.copyWith(error: error, isLoading: false),
        (data) =>
            state = state.copyWith(data: data, isLoading: false, error: null),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    }
  }
}

class CreatePenerimaanBarangNotifier extends StateNotifier<States> {
  final PenerimaanBarangApi _penerimaanBarangApi;
  final Ref ref;
  CreatePenerimaanBarangNotifier(this._penerimaanBarangApi, this.ref)
      : super(States.noState());

  Future<bool> createData({
    required List<String> rawMaterialId,
    required List<int> prices,
    required List<int> quantities,
  }) async {
    state = States.loading();
    try {
      final result = await _penerimaanBarangApi.createData(
        rawMaterialId: rawMaterialId,
        prices: prices,
        quantities: quantities,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (data) {
          ref.watch(penerimaanBarangNotifier.notifier).getData();
          state = States.noState();
          return true;
        },
      );
    } catch(exception){
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class DataNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  DataNotifier() : super([]);

  addData(Map<String, dynamic> data) {
    state = [data, ...state];
    log(state.toString());
  }

  editData(String id, {required Map<String, dynamic> data}) {
    List<Map<String, dynamic>> oldData = state;
    int index = oldData.indexWhere((element) => element['id'] == id);
    oldData[index] = data;
    state = [];
    state = oldData;
  }

  removeData(String id) {
    state = state.where((element) => element['id'] != id).toList();
  }
}
