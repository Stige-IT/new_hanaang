import 'package:admin_hanaang/features/penerimaan_barang/data/penerimaan_barang_api.dart';
import 'package:admin_hanaang/features/penerimaan_barang/provider/penerimaan_barang_notifier.dart';
import 'package:admin_hanaang/features/penerimaan_barang/provider/penerimaan_barang_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/penerimaan_barang/detail_penerimaan_barang.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final penerimaanBarangNotifier =
    StateNotifierProvider<PenerimaanBarangNotifier, PenerimaanBarangState>(
        (ref) {
  return PenerimaanBarangNotifier(ref.watch(penerimaanBarangProvider));
});

final detailPenerimaanBarangNotifier = StateNotifierProvider<
    DetailPenerimaanBarangNotifier, BaseState<DetailPenerimaanBarang>>((ref) {
  return DetailPenerimaanBarangNotifier(ref.watch(penerimaanBarangProvider));
});

final createPenerimaanBarangNotifier =
    StateNotifierProvider<CreatePenerimaanBarangNotifier, States>((ref) {
  return CreatePenerimaanBarangNotifier(
      ref.watch(penerimaanBarangProvider), ref);
});

final dataNotifier =
StateNotifierProvider.autoDispose<DataNotifier, List<Map<String, dynamic>>>(
        (ref) {
      return DataNotifier();
    });