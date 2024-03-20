import 'dart:developer';

import 'package:admin_hanaang/features/retur/data/retur_api.dart';
import 'package:admin_hanaang/features/retur/provider/retur_state.dart';
import 'package:admin_hanaang/models/retur.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';
import 'retur_provider.dart';

class ReturProcessNotifier extends StateNotifier<BaseState<List<Retur>>> {
  final ReturApi _returApi;

  ReturProcessNotifier(this._returApi) : super(const BaseState());

  Future getRetur({bool? makeLoading}) async {
    state = state.copyWith(page: 1);
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final dataProcess = await _returApi.getRetur("Diproses", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: response['data'],
          page: response['current_page'],
          total: response['total'],
          lastPage: response['last_page'],
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: exceptionTomessage(e));
    }
  }

  loadMore() async {
    try {
      state = state.copyWith(page: state.page + 1);
      final dataProcess = await _returApi.getRetur("Diproses", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: [...response['data'], ...state.data!],
          page: response['current_page'],
          total: response['total'],
          lastPage: response['last_page'],
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  refresh() async {
    state = state.copyWith(page: 1);
    getRetur();
  }
}

class TotalReturNotifier extends StateNotifier<States<int>> {
  final ReturApi _returApi;
  TotalReturNotifier(this._returApi) : super(States.noState());

  Future<void> getTotal() async {
    state = States.loading();
    try {
      final result = await _returApi.searchRetur('');
      result.fold(
            (error) => state = States.error(error),
            (response) => state = States.finished(response.total),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class SearchReturNotifier extends StateNotifier<States<List<Retur>>> {
  final ReturApi _returApi;

  SearchReturNotifier(this._returApi) : super(States.noState());

  Future<void> search(String query) async {
    state = States.loading();
    try {
      final result = await _returApi.searchRetur(query);
      result.fold(
        (error) => state = States.error(error),
        (response) => state = States.finished(response.data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class ReturAcceptNotifier extends StateNotifier<ReturStates> {
  final ReturApi _returApi;

  ReturAcceptNotifier(this._returApi) : super(const ReturStates());

  Future getRetur({bool? makeLoading}) async {
    state = state.copyWith(page: 1);
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final dataProcess = await _returApi.getRetur("Disetujui", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: response['data'],
          page: response['current_page'],
          totalPage: response['last_page'],
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  loadMore() async {
    try {
      state = state.copyWith(page: state.page + 1);
      final dataProcess = await _returApi.getRetur("Disetujui", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: [...response['data'], ...state.data!],
          page: response['current_page'],
          totalPage: response['last_page'],
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  refresh() async {
    state = state.copyWith(page: 1);
    getRetur();
  }
}

class ReturRejectNotifier extends StateNotifier<ReturStates> {
  final ReturApi _returApi;

  ReturRejectNotifier(this._returApi) : super(const ReturStates());

  Future getRetur({bool? makeLoading}) async {
    state = state.copyWith(page: 1);
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final dataProcess = await _returApi.getRetur("Ditolak", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: response['data'],
          page: response['current_page'],
          totalPage: response['last_page'],
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  loadMore() async {
    try {
      state = state.copyWith(page: state.page + 1);
      final dataProcess = await _returApi.getRetur("Ditolak", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: [...response['data'], ...state.data!],
          page: response['current_page'],
          totalPage: response['last_page'],
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  refresh() async {
    state = state.copyWith(page: 1);
    getRetur();
  }
}

class ReturFinishNotifier extends StateNotifier<ReturStates> {
  final ReturApi _returApi;

  ReturFinishNotifier(this._returApi) : super(const ReturStates());

  Future getRetur({bool? makeLoading}) async {
    state = state.copyWith(page: 1);
    if (makeLoading != null && makeLoading) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final dataProcess = await _returApi.getRetur("Selesai", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: response['data'],
          page: response['current_page'],
          totalPage: response['last_page'],
          isLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  loadMore() async {
    try {
      state = state.copyWith(page: state.page + 1);
      final dataProcess = await _returApi.getRetur("Selesai", state.page);
      dataProcess.fold(
        (error) => state = state.copyWith(error: error),
        (response) => state = state.copyWith(
          data: [...response['data'], ...state.data!],
          page: response['current_page'],
          totalPage: response['last_page'],
          error: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  refresh() async {
    state = state.copyWith(page: 1);
    getRetur();
  }
}

class CreateAcceptReturNotifier extends StateNotifier<ReturState> {
  final ReturApi _returApi;
  final Ref ref;

  CreateAcceptReturNotifier(this._returApi, this.ref)
      : super(ReturState.noState());

  Future<bool> createAcceptRetur(String returId) async {
    state = ReturState.loading();
    final result = await _returApi.createAcceptRetur(returId);
    return result.fold(
      (error) {
        log(error);
        state = ReturState.error(error);
        return false;
      },
      (r) {
        ref.watch(returProcessNotifier.notifier).getRetur();
        ref.watch(returAcceptNotifier.notifier).getRetur();
        state = ReturState.finished();
        return true;
      },
    );
  }
}

class RejectReturNotifier extends StateNotifier<States> {
  final ReturApi _returApi;
  final Ref ref;

  RejectReturNotifier(this._returApi, this.ref) : super(States.noState());

  Future<bool> rejectRetur(String returId,
      {required String messageReject}) async {
    state = States.loading();
    final result = await _returApi.createRejectRetur(returId,
        messageReject: messageReject);
    return result.fold(
      (error) {
        log(error);
        state = States.error(error);
        return false;
      },
      (status) {
        ref.watch(returProcessNotifier.notifier).getRetur();
        ref.watch(returRejectNotifier.notifier).getRetur();
        state = States.noState();
        return status;
      },
    );
  }
}

class TakingReturNotifier extends StateNotifier<ReturState> {
  final ReturApi _returApi;
  final Ref ref;

  TakingReturNotifier(this._returApi, this.ref) : super(ReturState.noState());

  Future<bool> takingRetur(String returId, {required String quantity}) async {
    state = ReturState.loading();
    final result = await _returApi.takingRetur(returId, quantity: quantity);
    return result.fold(
      (error) {
        log(error);
        state = ReturState.error(error);
        return false;
      },
      (status) {
        ref.read(returAcceptNotifier.notifier).getRetur();
        ref.read(returFinishNotifier.notifier).getRetur();
        state = ReturState.noState();
        return status;
      },
    );
  }
}
