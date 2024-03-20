import 'dart:io';

import 'package:admin_hanaang/features/material/provider/material_provider.dart';
import 'package:admin_hanaang/features/material/provider/material_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/material_detail.dart';
import 'package:admin_hanaang/models/material_model.dart';
import 'package:admin_hanaang/models/penerimaan_barang/history_penerimaan_barang.dart';
import 'package:admin_hanaang/models/suplayer.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/material_api.dart';

class MaterialsNotifier extends StateNotifier<MaterialState<MaterialModel>> {
  final MaterialApi _materialApi;

  MaterialsNotifier(this._materialApi) : super(MaterialState.noState());

  Future<void> getMaterials() async {
    state = MaterialState.loading();
    try {
      final result = await _materialApi.getMaterials();
      result.fold(
        (error) => state = MaterialState.error(error),
        (data) => state = MaterialState.finished(data: data),
      );
    } catch (exception){
      state = MaterialState.error(exceptionTomessage(exception));
    }
  }
}

class SearchMaterialsNotifier extends StateNotifier<List<MaterialModel>> {
  SearchMaterialsNotifier() : super([]);

  void searchByQuery(List<MaterialModel> data, {required String query}){
    List<MaterialModel> temp = [];
    if(query.isEmpty){
      temp = data;
    }else{
      for(MaterialModel material in data){
        if(material.name!.toLowerCase().contains(query.toLowerCase())){
          temp.add(material);
        }
      }
    }
    state = temp;
  }
}

class MaterialNotifier extends StateNotifier<States<MaterialDetail>> {
  final MaterialApi _materialApi;

  MaterialNotifier(this._materialApi) : super(States.noState());

  Future<void> getMaterial(String materialId) async {
    state = States.loading();
    try {
      final result = await _materialApi.getMaterial(materialId);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class DetailSuplayerNotifier extends StateNotifier<BaseState<Suplayer>> {
  final MaterialApi _materialApi;
  DetailSuplayerNotifier(this._materialApi) : super(const BaseState());

  getDetail(String materialId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _materialApi.getDetailSuplayer(materialId);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (data) =>
            state = state.copyWith(isLoading: false, error: null, data: data),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Sistem dalam masalah");
    }
  }
}

class HistoryPenerimaanBarangNotifier
    extends StateNotifier<BaseState<List<HistoryPenerimaanBarang>>> {
  final MaterialApi _materialApi;
  HistoryPenerimaanBarangNotifier(this._materialApi) : super(const BaseState());

  getHistory(String materialId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _materialApi.getHistoryPenerimaanBarang(materialId,
          page: state.page);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (response) => state = state.copyWith(
          isLoading: false,
          error: null,
          data: response['data'],
          page: response['current_page'],
          lastPage: response['last_page'],
        ),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Sistem dalam masalah");
    }
  }

  loadDataMore(String materialId) async {
    state = state.copyWith(isLoadingMore: true, page: state.page + 1);
    try {
      final result = await _materialApi.getHistoryPenerimaanBarang(materialId,
          page: state.page);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (response) => state = state.copyWith(
          isLoading: false,
          error: null,
          data: [...state.data!, ...response['data']],
          page: response['current_page'],
          lastPage: response['last_page'],
        ),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Sistem dalam masalah");
    }
  }

  refrest(String materialId) async {
    state = state.copyWith(page: 1);
    getHistory(materialId);
  }
}

class CreateMaterialNotifier extends StateNotifier<MaterialState> {
  final MaterialApi _materialApi;
  final Ref ref;

  CreateMaterialNotifier(this._materialApi, this.ref)
      : super(MaterialState.noState());

  Future<bool> createMaterial({
    required String suplayerId,
    required String name,
    required String unitId,
    required String stock,
    required String unitPrice,
  }) async {
    state = MaterialState.loading();
    try {
      final result = await _materialApi.createMaterial(
          suplayerId: suplayerId,
          name: name,
          unitId: unitId,
          stock: stock,
          unitPrice: unitPrice);
      return result.fold(
        (error) {
          state = MaterialState.error(error);
          return false;
        },
        (data) {
          ref.watch(materialsNotifier.notifier).getMaterials();
          state = MaterialState.finished();
          return true;
        },
      );
    } on SocketException {
      state = MaterialState.error("Tidak ada internet");
      return false;
    }
  }
}

class UpdateMaterialNotifier extends StateNotifier<States> {
  final MaterialApi _materialApi;
  final Ref ref;

  UpdateMaterialNotifier(this._materialApi, this.ref) : super(States.noState());

  Future<bool> updateMaterial(
    String materialId, {
    required String name,
    required String unitId,
    required String unitPrice,
  }) async {
    state = States.loading();
    try {
      final result = await _materialApi.updateMaterial(
        materialId,
        name: name,
        unitId: unitId,
        unitPrice: unitPrice,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (data) {
          ref.read(materialNotifier.notifier).getMaterial(materialId);
          state = States.noState();
          return true;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class DeleteMaterialNotifier extends StateNotifier<MaterialState> {
  final MaterialApi _materialApi;
  final Ref ref;

  DeleteMaterialNotifier(this._materialApi, this.ref)
      : super(MaterialState.noState());

  Future<bool> deleteMaterial(String materialId) async {
    state = MaterialState.loading();
    try {
      final result = await _materialApi.deleteMaterial(materialId);
      return result.fold(
        (error) {
          state = MaterialState.error(error);
          return false;
        },
        (data) {
          ref.read(materialsNotifier.notifier).getMaterials();
          state = MaterialState.finished();
          return true;
        },
      );
    } catch (e) {
      state = MaterialState.error(e.toString());
      return false;
    }
  }
}
