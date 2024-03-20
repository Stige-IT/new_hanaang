import 'package:admin_hanaang/features/fcm/fcm_api.dart';
import 'package:admin_hanaang/features/pre-order/data/pre_order_api.dart';
import 'package:admin_hanaang/features/pre-order/provider/pre_order_provider.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/pre_order.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/helper/failure_exception.dart';

class PreOrderNotifier extends StateNotifier<States> {
  final PreOrderApi preOrderApi;

  PreOrderNotifier(this.preOrderApi) : super(States.noState());

  Future getPreOrder() async {
    state = States.loading();
    try {
      final result = await preOrderApi.getPreOrder();
      state = result.fold(
        (l) => States.error(l),
        (r) => States.finished(r),
      );
    } catch (e) {
      state = States.error("Error $e");
    }
  }
}

class OpenPreOrderNotifier extends StateNotifier<States<PreOrder>> {
  final Ref ref;
  final PreOrderApi preOrderApi;
  final FcmApi _fcmApi;

  OpenPreOrderNotifier(this.preOrderApi, this._fcmApi, this.ref)
      : super(States.noState());

  Future<bool> updatePreOrder({
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String totalProduct,
  }) async {
    state = States.loading();
    try {
      final result = await preOrderApi.updatePreorder(
        startDateTime,
        endDateTime,
        totalProduct,
      );

      state = result.fold(
        (error) => States.error(error),
        (status) {
          _fcmApi.sendNotificationToUser(
            title: "Pre Order Hanaang",
            body:
                "Sedia $totalProduct Cup \nSampai dengan ${endDateTime.toString().timeFormat()} WIB. \nPesan Sekarang juga 🙌",
          );
          ref.read(preOrderNotifierProvider.notifier).getPreOrder();
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
