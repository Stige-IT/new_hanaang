import 'package:admin_hanaang/features/recipts/data/recipt_api.dart';
import 'package:admin_hanaang/features/recipts/provider/recipt_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/item_reciept.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/material_model.dart';
import '../../../models/recipt.dart';
import '../../../models/recipt_detail.dart';

/*
    State Provider
*/

final selectMaterialProvider =
    StateProvider.autoDispose<MaterialModel?>((ref) => null);

final indexProvider = StateProvider.autoDispose<int>((ref) => 0);
final dataNotifier =
    StateNotifierProvider<DataNotifier, List<ItemRecipt>>((ref) {
  return DataNotifier();
});
final dataItemNotifier =
    StateNotifierProvider.autoDispose<DataItemNotifier, List<ItemMaterial>>(
        (ref) {
  return DataItemNotifier();
});

final reciptSelectedProvider =
    StateProvider.autoDispose<Recipt?>((ref) => null);

/*
    State Notifier
 */

final reciptsNotifer =
    StateNotifierProvider<ReciptsNotifier, BaseState<List<Recipt>>>((ref) {
  return ReciptsNotifier(ref.watch(reciptProvider));
});

final reciptNotifer =
    StateNotifierProvider<ReciptNotifier, States<ReciptDetail>>((ref) {
  return ReciptNotifier(ref.watch(reciptProvider));
});

final createReciptNotifer =
    StateNotifierProvider<CreateReciptNotifier, States>((ref) {
  return CreateReciptNotifier(ref.watch(reciptProvider), ref);
});
