import 'package:admin_hanaang/features/shopping/data/shopping_api.dart';
import 'package:admin_hanaang/features/shopping/provider/shopping_provider.dart';
import 'package:admin_hanaang/features/state.dart';
import 'package:admin_hanaang/models/shopping.dart';
import 'package:admin_hanaang/utils/helper/failure_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingsNotifier extends StateNotifier<BaseState<List<Shopping>>> {
  final ShoppingApi _shoppingApi;
  ShoppingsNotifier(this._shoppingApi) : super(const BaseState());

  Future<void> getData() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _shoppingApi.getShoppingData(page: state.page);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (response) => state = state.copyWith(
          data: response['data'],
          page: response['current_page'],
          lastPage: response['last_page'],
          total: response['total'],
          isLoading: false,
          error: null,
        ),
      );
    } catch (exception) {
      state = state.copyWith(
          isLoading: false, error: exceptionTomessage(exception));
    }
  }

  void loadMore() async {
    state = state.copyWith(isLoadingMore: true, page: state.page + 1);
    try {
      final result = await _shoppingApi.getShoppingData(page: state.page);
      result.fold(
        (error) => state = state.copyWith(isLoadingMore: false, error: error),
        (response) => state = state.copyWith(
          data: [...response['data'], ...state.data!],
          page: response['current_page'],
          lastPage: response['last_page'],
          total: response['total'],
          isLoadingMore: false,
          error: null,
        ),
      );
    } catch (exception) {
      state = state.copyWith(
          isLoadingMore: false, error: exceptionTomessage(exception));
    }
  }

  void refresh() {
    state = state.copyWith(page: 1);
    getData();
  }
}

class ShoppingDetailNotifier extends StateNotifier<States<Shopping>> {
  final ShoppingApi _shoppingApi;
  ShoppingDetailNotifier(this._shoppingApi) : super(States.noState());

  Future<void> getDetail(String shoppingId) async {
    state = States.loading();
    try {
      final result = await _shoppingApi.getShoppingDetail(shoppingId);
      result.fold(
        (error) => state = States.error(error),
        (data) => state = States.finished(data),
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
    }
  }
}

class CreateShoppingNotifier extends StateNotifier<States<Shopping>> {
  final ShoppingApi _shoppingApi;
  final Ref ref;
  CreateShoppingNotifier(this._shoppingApi, this.ref) : super(States.noState());

  Future<bool> create({
    required List<String> itemsName,
    required List<int> quantities,
    required List<int> prices,
  }) async {
    state = States.loading();
    try {
      final result = await _shoppingApi.createShoppingData(
        itemsName: itemsName,
        quantities: quantities,
        prices: prices,
      );
      return result.fold(
        (error) {
          state = States.error(error);
          return false;
        },
        (data) {
          ref.read(shoppingsNotifier.notifier).getData();
          state = States.noState();
          return true;
        },
      );
    } catch (exception) {
      state = States.error(exceptionTomessage(exception));
      return false;
    }
  }
}

class CartShoppingNotifier extends StateNotifier<List<ShoppingItem>> {
  CartShoppingNotifier() : super([]);

  addItem(ShoppingItem item) {
    state = [...state, item];
  }

  removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  clear() {
    state = [];
  }
}
