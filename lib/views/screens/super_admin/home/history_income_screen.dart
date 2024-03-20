import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank-account_provider.dart';
import 'package:admin_hanaang/models/bank_history.dart';
import 'package:admin_hanaang/views/components/card_income.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryIncomeScreen extends ConsumerStatefulWidget {
  final String bankAccountdId;
  const HistoryIncomeScreen(this.bankAccountdId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HistoryIncomeScreenState();
}

class _HistoryIncomeScreenState extends ConsumerState<HistoryIncomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    Future.microtask(() {
      ref.read(bankHistoryIncomeNotifier.notifier).getHistoy(
          categoryName: "Pemasukan", bankAccountId: widget.bankAccountdId);
      ref.read(bankHistoryOutcomeNotifier.notifier).getHistoy(
          categoryName: "Pengeluaran", bankAccountId: widget.bankAccountdId);
    });
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stateIncome = ref.watch(bankHistoryIncomeNotifier);
    final stateOutcome = ref.watch(bankHistoryOutcomeNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        // actions: [
        //   PopupMenuButton(
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10)),
        //       icon: const Icon(Icons.filter_alt),
        //       itemBuilder: (_) {
        //         return [
        //           const PopupMenuItem(
        //               child: Text(
        //             "Besar ke Kecil",
        //           )),
        //           const PopupMenuItem(
        //               child: Text(
        //             "Kecil ke besar",
        //           )),
        //         ];
        //       })
        // ],
        title: const Text("Riwayat Keuangan"),
        bottom: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(child: Text("Pemasukan")),
            Tab(child: Text("Pengeluaran")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ///[TAB BAR VIEW INCOME HISTORY]
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                ref.read(bankHistoryIncomeNotifier.notifier).refresh(
                    categoryName: "Pemasukan",
                    bankAccountId: widget.bankAccountdId);
              });
            },
            child: Builder(builder: (_) {
              if (stateIncome.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateIncome.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber, size: 50),
                      Text(stateIncome.error!),
                    ],
                  ),
                );
              } else if (stateIncome.data == null ||
                  stateIncome.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money, size: 50),
                      Text("Data Tidak ada"),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 70.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: stateIncome.isLoadingMore
                    ? stateIncome.data!.length + 1
                    : stateIncome.data!.length,
                itemBuilder: (_, i) {
                  BankHistory history = stateIncome.data![i];
                  if (stateIncome.isLoadingMore) {
                    return Center(
                      child: LoadingInButton(color: Theme.of(context).colorScheme.primary),
                    );
                  }
                  return CardIncome(
                    historyBankId: history.id!,
                    isIncome: true,
                    type: history.type ?? "-",
                    nominal: history.nominal ?? "0",
                    createdAt: history.createdAt ?? "",
                  );
                },
                separatorBuilder: (_, i) => const SizedBox(height: 5),
              );
            }),
          ),

          ///[TAB BAR VIEW OUTCOME HISTORY]
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                ref.read(bankHistoryOutcomeNotifier.notifier).refresh(
                    categoryName: "Pengeluaran",
                    bankAccountId: widget.bankAccountdId);
              });
            },
            child: Builder(builder: (_) {
              if (stateOutcome.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateOutcome.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber, size: 50),
                      Text(stateOutcome.error!),
                    ],
                  ),
                );
              } else if (stateOutcome.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money, size: 50),
                      Text("Data Tidak ada"),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 70.0),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: stateOutcome.isLoadingMore
                    ? stateOutcome.data!.length + 1
                    : stateOutcome.data!.length,
                itemBuilder: (_, i) {
                  BankHistory history = stateOutcome.data![i];
                  if (stateOutcome.isLoadingMore) {
                    return Center(
                      child: LoadingInButton(color: Theme.of(context).colorScheme.primary),
                    );
                  }
                  return CardIncome(
                    historyBankId: history.id!,
                    isIncome: false,
                    type: history.type ?? "-",
                    nominal: history.nominal ?? "0",
                    createdAt: history.createdAt ?? "",
                  );
                },
                separatorBuilder: (_, i) => const SizedBox(height: 5),
              );
            }),
          ),
        ],
      ),
    );
  }
}
