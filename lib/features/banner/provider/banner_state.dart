import 'package:admin_hanaang/models/banner_data.dart';

class BannerState {
  final List<BannerData>? data;
  final bool isLoading;
  final String? error;

  BannerState({this.data, required this.isLoading, this.error});

  factory BannerState.noState() => BannerState(isLoading: false);
  factory BannerState.loading() => BannerState(isLoading: true);
  factory BannerState.error() => BannerState(isLoading: false, data: null);

  factory BannerState.finished(List<BannerData> data) {
    return BannerState(data: data, isLoading: false);
  }
}

class BannerByIdState {
  final BannerData? data;
  final bool? isLoading;
  final String? error;

  BannerByIdState({this.data, this.isLoading, this.error});

  factory BannerByIdState.noState() => BannerByIdState(isLoading: false);
  factory BannerByIdState.loading() => BannerByIdState(isLoading: true);
  factory BannerByIdState.error() =>
      BannerByIdState(isLoading: false, data: null);

  factory BannerByIdState.finished(BannerData data) {
    return BannerByIdState(data: data, isLoading: false);
  }
}
