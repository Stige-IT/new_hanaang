import 'dart:io';

import 'package:admin_hanaang/features/banner/data/banner_api.dart';
import 'package:admin_hanaang/features/banner/provider/banner_provider.dart';
import 'package:admin_hanaang/features/banner/provider/banner_state.dart';
import 'package:admin_hanaang/models/banner_data.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state.dart';

class BannerDataNotifier extends StateNotifier<BannerState> {
  BannerDataNotifier(this.api) : super(BannerState.noState());

  final BannerApi api;

  Future getBannerData() async {
    state = BannerState.loading();
    final result = await api.getBannerdata();
    result.fold(
      (l) => state = BannerState.error(),
      (r) => state = BannerState.finished(r),
    );
  }
}

class CreateBannerNotifier extends StateNotifier<States> {
  CreateBannerNotifier(this.api, this.ref) : super(States.noState());

  final BannerApi api;
  final Ref ref;

  Future<bool> createBanner(
      {required String detail, required File image}) async {
    state = States.loading();
    try {
      final result = await api.createBannerdata(detail: detail, image: image);
      state = result.fold(
        (error) => States.error(error),
        (succes) {
          ref.read(bannersNotifierProvider.notifier).getBannerData();
          return States.noState();
        },
      );
      return result.isRight();
    } catch(e){
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}


class UpdateBannerNotifier extends StateNotifier<States> {
  UpdateBannerNotifier(this.api, this.ref) : super(States.noState());

  final BannerApi api;
  final Ref ref;

  Future<bool> updateBanner(
      BannerData data, {
        required String detail,
        File? image,
      }) async {
    state = States.loading();
    try {
      final result = await api.updateBannerdata(data, detail: detail, image: image);
      state = result.fold(
            (error) => States.error(error),
            (succes) {
          ref.read(bannersNotifierProvider.notifier).getBannerData();
          return States.noState();
        },
      );
      return result.isRight();
    } catch(e){
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}

class BannerDataByIdNotifier extends StateNotifier<BannerByIdState> {
  BannerDataByIdNotifier(this.api) : super(BannerByIdState.noState());

  final BannerApi api;

  Future getBannerDataById(BannerData data) async {
    state = BannerByIdState.loading();
    final result = await api.getBannerdataById(data);
    result.fold(
      (l) => state = BannerByIdState.error(),
      (r) => state = BannerByIdState.finished(r),
    );
  }
}

class DeleteBannerNotifier extends StateNotifier<States> {
  DeleteBannerNotifier(this.api, this.ref) : super(States.noState());

  final BannerApi api;
  final Ref ref;

  Future<bool> deleteBanner(BannerData banner) async {
    state = States.loading();
    try {
      final result = await api.deleteBannerdata(banner);
      state =  result.fold(
        (error) => States.error(error),
        (succes) {
          ref.read(bannersNotifierProvider.notifier).getBannerData();
          return States.noState();
        },
      );
      return result.isRight();
    } catch(e){
      state = States.error(exceptionTomessage(e));
      return false;
    }
  }
}
