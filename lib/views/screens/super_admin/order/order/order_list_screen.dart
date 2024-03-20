import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/empty_widget.dart';
import 'package:admin_hanaang/views/components/failure_widget.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../features/order/order.dart';
import '../../../../components/card_order.dart';

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderListScreenState();
}

final isShowSearchProvider = StateProvider.autoDispose<bool>((ref) => false);

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  Map statusPayment = {
    "Semua": "all",
    "Belum dibayar": "Belum Dibayar",
    "Sebagian dibayar": "Dibayar Sebagian",
    "Sudah dibayar": "Sudah Dibayar",
  };

  Map statusTakeOrder = {
    "Semua": "all",
    "Belum diambil": "Belum Diambil",
    "Sebagian diambil": "Diambil Sebagian",
    "Sudah diambil": "Sudah Diambil",
  };

  late TextEditingController _searchCtrl;
  late ScrollController _scrollCtrl;

  void _getData() => ref.watch(orderNotifier.notifier).refresh();

  @override
  void initState() {
    _searchCtrl = TextEditingController();
    _scrollCtrl = ScrollController();
    Future.microtask(() => _getData());

    _scrollCtrl.addListener(() async {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        if (ref.watch(orderNotifier).page !=
            ref.watch(orderNotifier).lastPage) {
          await ref.watch(orderNotifier.notifier).nextOrders();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(orderNotifier).data;
    final isShowSearch = ref.watch(isShowSearchProvider);
    final paymentStatusvalue = ref.watch(paymentStatusProvider);
    final takeOrderStatusValue = ref.watch(takeOrderStatusProvider);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: isShowSearch
              ? TextField(
                  autofocus: true,
                  controller: _searchCtrl,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                      hintText: "Masukkan Kode Pesanan",
                      hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                      border: UnderlineInputBorder()),
                  onChanged: (value) async {
                    await ref
                        .watch(orderNotifier.notifier)
                        .searchOrders(query: value);
                  },
                )
              : const Text("Daftar Pesanan"),
          actions: [
            IconButton(
              onPressed: () async {
                if (isShowSearch) {
                  _searchCtrl.clear();
                }
                ref.watch(isShowSearchProvider.notifier).state = !isShowSearch;
                ref.invalidate(paymentStatusProvider);
                ref.invalidate(takeOrderStatusProvider);
                ref.watch(orderNotifier.notifier).refresh();
              },
              icon: isShowSearch
                  ? const Icon(Icons.close_rounded)
                  : const Icon(Icons.search),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () => _getData());
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: DropdownContainer(
                        title: "Status Pembayaran",
                        value: paymentStatusvalue,
                        items: statusPayment
                            .map(
                              (key, value) => MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(key),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                        onChanged: (value) async {
                          ref.watch(paymentStatusProvider.notifier).state =
                              value!;
                          ref.watch(orderNotifier.notifier).refresh();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownContainer(
                        title: "Status Pengambilan",
                        value: takeOrderStatusValue,
                        items: statusTakeOrder
                            .map(
                              (key, value) => MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(key),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                        onChanged: (value) async {
                          ref.watch(takeOrderStatusProvider.notifier).state =
                              value!;
                          ref.watch(orderNotifier.notifier).refresh();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                if (ref.watch(orderNotifier).isLoading) {
                  return const CircularLoading();
                } else if (ref.watch(orderNotifier).error != null) {
                  return FailureWidget(
                    error: ref.watch(orderNotifier).error!,
                    onPressed: () => _getData(),
                  );
                } else if (data == null || data.isEmpty) {
                  return const EmptyWidget();
                }
                return Expanded(
                  child: Scrollbar(
                    radius: const Radius.circular(10),
                    controller: _scrollCtrl,
                    interactive: true,
                    thickness: 6,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 70.0),
                      controller: _scrollCtrl,
                      itemCount: ref.watch(orderNotifier).isLoadingMore
                          ? data.length + 1
                          : data.length,
                      itemBuilder: (_, i) {
                        if (ref.watch(orderNotifier).isLoadingMore &&
                            i == data.length) {
                          return Center(
                              child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
                        }
                        return CardOrder(orderData: data[i]);
                      },
                      separatorBuilder: (_, i) => const SizedBox(height: 10),
                    ),
                  ),
                );
              })
            ],
          ),
        ));
  }
}
