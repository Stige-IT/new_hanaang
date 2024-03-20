import 'package:admin_hanaang/features/manage_access_warehouse/data/manage_access_api.dart';
import 'package:admin_hanaang/features/manage_access_warehouse/provider/manage_accces_provider.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/manage_access.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageAccessNotifier extends StateNotifier<States<List<ManageAccess>>> {
  final ManageAccessApi _manageAccessApi;

  ManageAccessNotifier(this._manageAccessApi) : super(States.noState());

  Future<void> getData({String? typeId, bool? makeLoading}) async {
    if(makeLoading != null && makeLoading){
      state = States.loading();
    }
    try {
      final result = await _manageAccessApi.getDataManageAccess(typeId: typeId);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class DetailManageAccessNotifier extends StateNotifier<States<ManageAccess>> {
  final ManageAccessApi _manageAccessApi;

  DetailManageAccessNotifier(this._manageAccessApi) : super(States.noState());

  Future<void> getDetail({String? manageAccessId}) async {
    state = States.loading();
    try {
      final result = await _manageAccessApi.getDetailDataManageAccess(
        manageAccessId: manageAccessId,
      );
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class UpdateManageAccessNotifier extends StateNotifier<States> {
  final ManageAccessApi _manageAccessApi;
  final Ref ref;

  UpdateManageAccessNotifier(this._manageAccessApi, this.ref)
      : super(States.noState());

  Future<bool> updateData(
      String id,
    String manageAccessId, {
    required String create,
    required String read,
    required String update,
    required String delete,
  }) async {
    state = States.loading();
    try {
      final result = await _manageAccessApi.updateManageAccess(
        manageAccessId,
        create: create,
        read: read,
        update: update,
        delete: delete,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (success) {
          ref.read(manageAccessNotifier.notifier).getData(typeId: id);
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
