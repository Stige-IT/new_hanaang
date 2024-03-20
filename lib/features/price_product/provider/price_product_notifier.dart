import 'dart:io';

import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/price_product.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/price_product_api.dart';
import 'price_product_provider.dart';

class PriceProductNotifier extends StateNotifier<States<List<PriceProduct>>> {
  final PriceProductApi priceProductApi;

  PriceProductNotifier(this.priceProductApi) : super(States.noState());

  Future getPrice(String type, {bool? makeLoading}) async {
    if (makeLoading != null && makeLoading) {
      state = States.loading();
    }
    try {
      final result = await priceProductApi.getPriceProduct(type);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
    } catch (e) {
      state = States.error("Harap coba kembali");
    }
  }
}

class CheckPriceProductNotifier extends StateNotifier<States<int>> {
  final PriceProductApi priceProductApi;

  CheckPriceProductNotifier(this.priceProductApi) : super(States.noState());

  Future getPrice(String userId, int quantity) async {
    state = States.loading();
    try {
      final result = await priceProductApi.checkPriceProduct(userId, quantity);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (error) {
      state = States.error(exceptionTomessage(error));
      throw Exception(error);
    }
  }
}

class PriceProductDefaultNotifier
    extends StateNotifier<States<List<PriceProduct>>> {
  final PriceProductApi priceProductApi;

  PriceProductDefaultNotifier(this.priceProductApi) : super(States.noState());

  Future getPrice() async {
    state = States.loading();
    final result = await priceProductApi.getPriceProduct("Default");
    result.fold(
      (error) => state = States.error(error),
      (data) => state = States.finished(data),
    );
  }
}

class PriceProductAgenNotifier
    extends StateNotifier<States<List<PriceProduct>>> {
  final PriceProductApi priceProductApi;

  PriceProductAgenNotifier(this.priceProductApi) : super(States.noState());

  Future getPrice() async {
    state = States.loading();
    final result = await priceProductApi.getPriceProduct("Agen");
    result.fold(
      (error) => state = States.error(error),
      (data) => state = States.finished(data),
    );
  }
}

class PriceProductDistributorNotifier
    extends StateNotifier<States<List<PriceProduct>>> {
  final PriceProductApi priceProductApi;

  PriceProductDistributorNotifier(this.priceProductApi)
      : super(States.noState());

  Future getPrice() async {
    state = States.loading();
    final result = await priceProductApi.getPriceProduct("Distributor");
    result.fold(
      (error) => state = States.error(error),
      (data) => state = States.finished(data),
    );
  }
}

class PriceProductKeluargaNotifier
    extends StateNotifier<States<List<PriceProduct>>> {
  final PriceProductApi priceProductApi;

  PriceProductKeluargaNotifier(this.priceProductApi) : super(States.noState());

  Future getPrice() async {
    state = States.loading();
    final result = await priceProductApi.getPriceProduct("Keluarga");
    result.fold(
      (error) => state = States.error(error),
      (data) => state = States.finished(data),
    );
  }
}

class PriceProductWargaNotifier
    extends StateNotifier<States<List<PriceProduct>>> {
  final PriceProductApi priceProductApi;

  PriceProductWargaNotifier(this.priceProductApi) : super(States.noState());

  Future getPrice() async {
    state = States.loading();
    final result = await priceProductApi.getPriceProduct("Warga");
    result.fold(
      (error) => state = States.error(error),
      (data) => state = States.finished(data),
    );
  }
}

/*
CREATE NOTIFER
 */

class CreatePriceProductNotifier extends StateNotifier<States> {
  final PriceProductApi priceProductApi;
  final Ref ref;

  CreatePriceProductNotifier(this.priceProductApi, this.ref)
      : super(States.noState());

  Future<bool> createPrice({
    required String namePriceType,
    required String price,
    required String minimumOrder,
  }) async {
    state = States.loading();
    final result = await priceProductApi.createPriceProduct(
        namePriceType: namePriceType, price: price, minimumOrder: minimumOrder);

    return result.fold(
      (error) {
        state = States.error(error);
        return false;
      },
      (status) {
        final type = ref.read(typePriceProductProvider);
        ref.read(priceProductNotifier.notifier).getPrice(type);
        state = States.noState();
        return status;
      },
    );
  }
}

/*
UPDATE NOTIFER
 */

class UpdatePriceProductNotifier extends StateNotifier<States> {
  final PriceProductApi priceProductApi;
  final Ref ref;

  UpdatePriceProductNotifier(this.priceProductApi, this.ref)
      : super(States.noState());

  Future<bool> updatePrice(
    priceProductId, {
    required String namePriceType,
    required String price,
    required String minimumOrder,
  }) async {
    state = States.loading();
    final result = await priceProductApi.updatePriceProduct(priceProductId,
        namePriceType: namePriceType, price: price, minimumOrder: minimumOrder);
    return result.fold(
      (error) {
        state = States.error(error);
        return false;
      },
      (status) {
        final type = ref.read(typePriceProductProvider);
        ref.read(priceProductNotifier.notifier).getPrice(type);
        state = States.noState();
        return status;
      },
    );
  }
}

/*
DELETE NOTIFER
 */

class DeletePriceProductNotifier extends StateNotifier<States> {
  final PriceProductApi priceProductApi;
  final Ref ref;

  DeletePriceProductNotifier(this.priceProductApi, this.ref)
      : super(States.noState());

  Future<bool> deletePrice(String priceProductId) async {
    state = States.loading();
    try {
      final result =
          await priceProductApi.deletePriceProduct(priceId: priceProductId);
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (status) {
          final type = ref.read(typePriceProductProvider);
          ref.read(priceProductNotifier.notifier).getPrice(type);
          state = States.noState();
          return status;
        },
      );
    } on SocketException {
      state = States.error("Tidak ada internet");
      return false;
    } catch (e) {
      state = States.error("Masalah pada sistem");
      return false;
    }
  }
}
