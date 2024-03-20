import 'package:admin_hanaang/features/shopping/data/shopping_api.dart';
import 'package:admin_hanaang/features/shopping/provider/shopping_notifier.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/shopping.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[STATE PROVIDER]
final indexSelectedProvider = StateProvider.autoDispose<String?>((ref) => null);

///[NOTIFIER PROVIDER]
final shoppingsNotifier =
    StateNotifierProvider<ShoppingsNotifier, BaseState<List<Shopping>>>((ref) {
  return ShoppingsNotifier(ref.watch(shoppingProvider));
});

final shoppingDetailNotifier =
    StateNotifierProvider<ShoppingDetailNotifier, States<Shopping>>((ref) {
  return ShoppingDetailNotifier(ref.watch(shoppingProvider));
});

final createShoppingNotifier =
    StateNotifierProvider<CreateShoppingNotifier, States>((ref) {
  return CreateShoppingNotifier(ref.watch(shoppingProvider), ref);
});

final cartShoppingNotifier =
    StateNotifierProvider.autoDispose<CartShoppingNotifier, List<ShoppingItem>>(
        (ref) {
  return CartShoppingNotifier();
});
