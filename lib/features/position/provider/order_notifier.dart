import 'package:admin_hanaang/features/position/provider/order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/postion_api.dart';

class PositionNotifier extends StateNotifier<PositionState> {
  PositionNotifier(this.api) : super(PositionState.noState());

  final PositionApi api;

  Future getPostions() async {
    state = PositionState.loading();
    final result = await api.getPostions();
    result.fold(
      (l) => state = PositionState.error(l),
      (r) => state = PositionState.finished(r),
    );
  }

  Future createPostions({required String name}) async {
    state = PositionState.loading();
    final result = await api.createPosition(name: name);
    bool status = false;
    result.fold(
      (l) => state = PositionState.error(l),
      (r) {
        status = true;
        getPostions();
      },
    );
    return status;
  }

  Future deletePosition({required String positionId}) async {
    state = PositionState.loading();
    final result = await api.deletePosition(positionId);
    bool status = false;
    result.fold(
      (l) => state = PositionState.error(l),
      (r) {
        status = true;
        getPostions();
      },
    );
    return status;
  }
}

class PositionByIdNotifier extends StateNotifier<PositionState> {
  final PositionApi api;

  PositionByIdNotifier(this.api) : super(PositionState.noState());

  Future getPosition(String positionId) async {
    state = PositionState.loading();
    final result = await api.getPostion(positionId);
    bool status = false;
    result.fold(
      (l) => state = PositionState.error(l),
      (r) {
        status = true;
        state = PositionState.finished([r]);
      },
    );

    return status;
  }

  Future updatePostions(String positionId, {required String name}) async {
    state = PositionState.loading();
    final result = await api.updatePosition(positionId, name: name);
    bool status = false;
    result.fold(
      (l) => state = PositionState.error(l),
      (r) {
        status = true;
        getPosition(positionId);
      },
    );
    return status;
  }
}
