import 'package:admin_hanaang/models/penerimaan_barang/detail_penerimaan_barang.dart';
import 'package:admin_hanaang/models/penerimaan_barang/penerimaan_barang.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'penerimaan_barang_state.freezed.dart';

@freezed
class PenerimaanBarangState with _$PenerimaanBarangState {
  const factory PenerimaanBarangState({
    @Default(false) bool? isLoading,
    @Default(false) bool? isLoadMoreError,
    @Default(false) bool? isLoadingMore,
    @Default(false) bool? isLoadingCreate,
    @Default(1) int? page,
    String? errorMessage,
    String? errorCreateMessage,
    int? totalPage,
    List<PenerimaanBarang>? data,
    DetailPenerimaanBarang? detailData,
  }) = _PenerimaanBarangState;
}
