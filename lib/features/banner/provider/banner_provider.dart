import 'package:admin_hanaang/features/banner/data/banner_api.dart';
import 'package:admin_hanaang/features/banner/provider/banner_notifier.dart';
import 'package:admin_hanaang/features/banner/provider/banner_state.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bannersNotifierProvider =
    StateNotifierProvider<BannerDataNotifier, BannerState>((ref) {
  return BannerDataNotifier(ref.watch(bannerProvider));
});

final createBannerNotifier =
    StateNotifierProvider<CreateBannerNotifier, States>((ref) {
  return CreateBannerNotifier(ref.watch(bannerProvider), ref);
});


final updateBannerNotifier =
StateNotifierProvider<UpdateBannerNotifier, States>((ref) {
  return UpdateBannerNotifier(ref.watch(bannerProvider), ref);
});
final bannerNotifierProvider =
    StateNotifierProvider<BannerDataByIdNotifier, BannerByIdState>((ref) {
  return BannerDataByIdNotifier(ref.watch(bannerProvider));
});

final deleteBannerNotifier =
    StateNotifierProvider<DeleteBannerNotifier, States>((ref) {
  return DeleteBannerNotifier(ref.watch(bannerProvider), ref);
});
