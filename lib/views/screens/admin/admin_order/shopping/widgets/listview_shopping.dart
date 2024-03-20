import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../features/shopping/provider/shopping_provider.dart';
import '../../../../../../models/shopping.dart';
import '../../../../../components/empty_widget.dart';
import '../../../../../components/error_button_widget.dart';
import '../../../../../components/loading_in_button.dart';

class ListViewShopping extends ConsumerWidget {
  const ListViewShopping({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final state = ref.watch(shoppingsNotifier);
    final shoppings = state.data;
    final selected = ref.watch(indexSelectedProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1), () {
          ref.read(shoppingsNotifier.notifier).refresh();
        });
      },
      child: SizedBox(
        width: size.width * 0.35,
        child: Builder(builder: (_) {
          if (state.isLoading) {
            /// when loading fetch api
            return Center(
              child:
                  LoadingInButton(color: Theme.of(context).colorScheme.primary),
            );
          } else if (state.error != null) {
            /// when error
            return ErrorButtonWidget(
              errorMsg: state.error!,
              onTap: () {
                ref.read(shoppingsNotifier.notifier).getData();
              },
            );
          } else if (state.data == null || state.data!.isEmpty) {
            // when empty data or error data
            return const EmptyWidget();
          }
          //success data show list view in card item
          return Column(
            children: [
              const ListTile(
                  title: Text(
                "Riwayat pengeluaran",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 70.0),
                    itemBuilder: (_, i) {
                      if (state.isLoadingMore && i == shoppings.length) {
                        return Center(
                          child: LoadingInButton(
                              color: Theme.of(context).colorScheme.primary),
                        );
                      }
                      Shopping shopping = shoppings[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          selected: selected == shopping.id,
                          onTap: () {
                            ref.read(indexSelectedProvider.notifier).state =
                                shopping.id;
                            ref
                                .read(shoppingDetailNotifier.notifier)
                                .getDetail(shopping.id!);
                          },
                          title: Text(
                            int.parse(shopping.totalPrice ?? "0")
                                .convertToIdr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(shopping.createdAt!.timeFormat()),
                          trailing: Text(shopping.createdBy?.name ?? "-"),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemCount: state.isLoadingMore
                        ? shoppings!.length + 1
                        : shoppings!.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
