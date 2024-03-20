import 'package:admin_hanaang/features/material/data/material_api.dart';
import 'package:admin_hanaang/features/material/provider/material_notifier.dart';
import 'package:admin_hanaang/features/material/provider/material_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/penerimaan_barang/history_penerimaan_barang.dart';
import 'package:admin_hanaang/models/suplayer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/material_detail.dart';
import '../../../models/material_model.dart';
import '../../../models/unit.dart';

///[* save value dropdown]
final dropdownValueUnit = StateProvider.autoDispose<UnitModel?>((ref) => null);
final dropdownValueSuplayer = StateProvider.autoDispose<String?>((ref) => null);


final materialsNotifier =
    StateNotifierProvider<MaterialsNotifier, MaterialState>((ref) {
  return MaterialsNotifier(ref.watch(materialProvider));
});

final searchMaterialsNotifier =
    StateNotifierProvider<SearchMaterialsNotifier, List<MaterialModel>>((ref) {
  return SearchMaterialsNotifier();
});

final materialNotifier =
    StateNotifierProvider<MaterialNotifier, States<MaterialDetail>>((ref) {
  return MaterialNotifier(ref.watch(materialProvider));
});

final detailSuplayerNotifier =
    StateNotifierProvider<DetailSuplayerNotifier, BaseState<Suplayer>>((ref) {
  return DetailSuplayerNotifier(ref.watch(materialProvider));
});

final historyPenerimaanBarangNotifier = StateNotifierProvider<
    HistoryPenerimaanBarangNotifier,
    BaseState<List<HistoryPenerimaanBarang>>>((ref) {
  return HistoryPenerimaanBarangNotifier(ref.watch(materialProvider));
});

final createMaterialNotifier =
    StateNotifierProvider<CreateMaterialNotifier, MaterialState>((ref) {
  return CreateMaterialNotifier(ref.watch(materialProvider), ref);
});

final updateMaterialNotifier =
    StateNotifierProvider<UpdateMaterialNotifier, States>((ref) {
  return UpdateMaterialNotifier(ref.watch(materialProvider), ref);
});

final deleteMaterialsNotifier =
    StateNotifierProvider<DeleteMaterialNotifier, MaterialState>((ref) {
  return DeleteMaterialNotifier(ref.watch(materialProvider), ref);
});
