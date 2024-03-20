import 'package:admin_hanaang/features/unit/data/unit_api.dart';
import 'package:admin_hanaang/features/unit/provider/unit_notifier.dart';
import 'package:admin_hanaang/features/unit/provider/unit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unitsNotifier = StateNotifierProvider<UnitsNotifier, UnitState>((ref) {
  return UnitsNotifier(ref.watch(unitsProvider));
});

final unitNotifier = StateNotifierProvider<UnitNotifier, UnitState>((ref) {
  return UnitNotifier(ref.watch(unitsProvider));
});

final createUnitNotifier =
    StateNotifierProvider<CreateUnitNotifier, UnitState>((ref) {
  return CreateUnitNotifier(ref.watch(unitsProvider), ref);
});

final updateUnitNotifier =
    StateNotifierProvider<UpdateUnitNotifier, UnitState>((ref) {
  return UpdateUnitNotifier(ref.watch(unitsProvider), ref);
});

final deleteUnitNotifier =
    StateNotifierProvider<DeleteUnitNotifier, UnitState>((ref) {
  return DeleteUnitNotifier(ref.watch(unitsProvider), ref);
});
