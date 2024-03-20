import 'package:admin_hanaang/features/price_product/data/price_product_api.dart';
import 'package:admin_hanaang/features/price_product/provider/price_product_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/price_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typePriceProductProvider =
    StateProvider.autoDispose<String>((ref) => "Default");
/*
 GET PROVIDER NOTIFER
 */
final priceProductNotifier = StateNotifierProvider.autoDispose<
    PriceProductNotifier, States<List<PriceProduct>>>((ref) {
  return PriceProductNotifier(ref.watch(priceProdcutProvider));
});

final priceProductDefaultNotifier = StateNotifierProvider<
    PriceProductDefaultNotifier, States<List<PriceProduct>>>((ref) {
  return PriceProductDefaultNotifier(ref.watch(priceProdcutProvider));
});

final priceProductAgenNotifier =
    StateNotifierProvider<PriceProductAgenNotifier, States<List<PriceProduct>>>(
        (ref) {
  return PriceProductAgenNotifier(ref.watch(priceProdcutProvider));
});

final priceProductDistributorNotifier = StateNotifierProvider<
    PriceProductDistributorNotifier, States<List<PriceProduct>>>((ref) {
  return PriceProductDistributorNotifier(ref.watch(priceProdcutProvider));
});

final priceProductKeluargaNotifier = StateNotifierProvider<
    PriceProductKeluargaNotifier, States<List<PriceProduct>>>((ref) {
  return PriceProductKeluargaNotifier(ref.watch(priceProdcutProvider));
});

final priceProductWargaNotifier =
    StateNotifierProvider<PriceProductWargaNotifier, States<List<PriceProduct>>>(
        (ref) {
  return PriceProductWargaNotifier(ref.watch(priceProdcutProvider));
});

/*
Check price product
*/
final checkPriceNotifier =
    StateNotifierProvider<CheckPriceProductNotifier, States<int>>((ref) {
  return CheckPriceProductNotifier(ref.watch(priceProdcutProvider));
});

/*
CREATE NOTIFER
 */

final createPriceProdcutNotifier =
    StateNotifierProvider<CreatePriceProductNotifier, States>((ref) {
  return CreatePriceProductNotifier(ref.watch(priceProdcutProvider), ref);
});

/*
UPDATE NOTIFER PROVIDER
 */

final updatePriceProdcutNotifier =
    StateNotifierProvider<UpdatePriceProductNotifier, States>((ref) {
  return UpdatePriceProductNotifier(ref.watch(priceProdcutProvider), ref);
});

/*
DELETE NOTIFER
 */

final deletePriceProdcutNotifier =
    StateNotifierProvider<DeletePriceProductNotifier, States>((ref) {
  return DeletePriceProductNotifier(ref.watch(priceProdcutProvider), ref);
});
