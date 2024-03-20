import 'dart:io';

import 'package:admin_hanaang/features/market/data/market_api.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/detail_market.dart';
import 'package:admin_hanaang/models/market.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketsNotifier extends StateNotifier<BaseState<List<Market>>> {
  final MarketApi _marketApi;
  MarketsNotifier(this._marketApi) : super(const BaseState());

  getData({String? idUser, bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final result =
          await _marketApi.getMarkets(page: state.page, idUser: idUser);
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
      state = state.copyWith(isLoading: false, error: "Tidak ada Internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Masalah pada sistem");
    }
  }

  void refresh({String? userId}) async {
    state = state.copyWith(page: 1);
    getData(idUser: userId, makeLoading: true);
  }

  getDataMore({String? idUser}) async {
    state = state.copyWith(page: state.page + 1, isLoadingMore: true);
    final result =
        await _marketApi.getMarkets(page: state.page, idUser: idUser);
    try {
      result.fold(
        (error) => state = state.copyWith(
            isLoading: false, error: error, isLoadingMore: false),
        (response) => state = state.copyWith(
          isLoading: false,
          error: null,
          data: [...state.data!, ...response['data']],
          page: response['current_page'],
          lastPage: response['last_page'],
        ),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada Internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Masalah pada sistem");
    }
  }

  searchByQuery(String query, {String? idUser}) async {
    try {
      final result = await _marketApi.searchMarket(query, idUser: idUser);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (data) =>
            state = state.copyWith(isLoading: false, error: null, data: data),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada Internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Masalah pada sistem");
    }
  }
}

class DetailMarketNotifier extends StateNotifier<BaseState<DetailMarket>> {
  final MarketApi _marketApi;
  DetailMarketNotifier(this._marketApi) : super(const BaseState());

  getDetail(String marketId) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _marketApi.getDetailMarket(marketId);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (data) =>
            state = state.copyWith(isLoading: false, error: null, data: data),
      );
    } on SocketException {
      state = state.copyWith(isLoading: false, error: "Tidak ada Internet");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Masalah pada sistem");
    }
  }
}
