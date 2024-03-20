import 'package:admin_hanaang/features/bank-account/provider/bank-account_provider.dart';
import 'package:admin_hanaang/features/banner/provider/banner_provider.dart';
import 'package:admin_hanaang/features/hutang/provider/hutang_provider.dart';
import 'package:admin_hanaang/features/pre-order/provider/pre_order_provider.dart';
import 'package:admin_hanaang/views/components/remove_glow.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:admin_hanaang/views/screens/super_admin/home/widgets/card_bank_saldo_widget.dart';
import 'package:admin_hanaang/views/screens/super_admin/home/widgets/carousel_banner_widget.dart';
import 'package:admin_hanaang/views/screens/super_admin/home/widgets/open_pre_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/appbar.dart';
import '../../../components/dialog_loading.dart';

final isActiveProvider = StateProvider.autoDispose<bool>((ref) => true);
final carouselIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  final today = DateTime.now();

  @override
  void initState() {
    Future.microtask(() {
      ref.read(bankSaldoNotifier.notifier).getBankSaldo();
      ref.read(bannersNotifierProvider.notifier).getBannerData();
      ref.read(preOrderNotifierProvider.notifier).getPreOrder();
      ref.read(totalHutangNotifier.notifier).getTotalHutang();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(preOrderNotifierProvider, (previous, next) {
      if (next.data != null) {
        final expired = DateTime.parse(next.data!.end!);
        final startedDatetime = DateTime.parse(next.data!.start!);
        int sisa = next.data!.sisaStockPo!;
        if (sisa == 0 ||
            expired.isBefore(today) ||
            today.isBefore(startedDatetime)) {
          /*
          label non-aktif
          - expired
          - remaining stock == 0
          - before start open pre order
          */
          ref.watch(isActiveProvider.notifier).state = false;
          showSnackbar(context, "Pre Order Tidak Aktif", isWarning: true);
        } else {
          ref.watch(isActiveProvider.notifier).state = true;
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async =>
                await Future.delayed(const Duration(seconds: 1), () {
              ref.watch(preOrderNotifierProvider.notifier).getPreOrder();
              ref.watch(bannersNotifierProvider.notifier).getBannerData();
              ref.watch(bankSaldoNotifier.notifier).getBankSaldo();
              ref.read(totalHutangNotifier.notifier).getTotalHutang();
            }),
            child: ScrollConfiguration(
              behavior: RemoveScrollGlow(),
              child: CustomScrollView(
                slivers: [
                  const AppBarSliver(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        /// [bankSaldo]
                        const CardBankSaldoWidget(),

                        /// [openPreOrderInformation]
                        const OpenPreOrderWidget(),

                        /// [carouselBanner]
                        const CarouselBannerWidget(),
                        const SizedBox(height: 100)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (ref.watch(openPreOrderNotifierProvider).isLoading ||
              ref.watch(createBannerNotifier).isLoading ||
              ref.watch(deleteBannerNotifier).isLoading)
            const DialogLoading()
        ],
      ),
    );
  }
}
