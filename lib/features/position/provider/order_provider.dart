import 'package:admin_hanaang/features/position/data/postion_api.dart';
import 'package:admin_hanaang/features/position/provider/order_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_state.dart';

final positionNotifier =
    StateNotifierProvider<PositionNotifier, PositionState>((ref) {
  return PositionNotifier(ref.watch(positionProvider));
});

final positionByIdNotifier =
    StateNotifierProvider<PositionByIdNotifier, PositionState>((ref) {
  return PositionByIdNotifier(ref.watch(positionProvider));
});
