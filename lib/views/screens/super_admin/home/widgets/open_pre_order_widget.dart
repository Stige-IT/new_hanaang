import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../features/pre-order/provider/pre_order_provider.dart';
import '../../../../../models/pre_order.dart';
import '../../../../../utils/extensions/start_to_end_time.dart';
import '../../../../../utils/helper/formatted_currency.dart';
import '../../../../components/empty_preorder.dart';
import '../home_screen.dart';
import 'dialog_pre_order.dart';

class OpenPreOrderWidget extends ConsumerWidget {
  const OpenPreOrderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preOrderNotifierProvider);
    final isActive = ref.watch(isActiveProvider);
    final PreOrder? preOrderData = state.data;
    final isLoading = state.isLoading;
    return Column(
      children: [
        ListTile(
          title: Text(
            "Pre Order",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontFamily: "Kaushan",
                ),
          ),
          trailing: Chip(
            backgroundColor:
                preOrderData != null && isActive ? Colors.green : Colors.red,
            label: Text(
              preOrderData != null && isActive ? "Aktif" : "Tidak Aktif",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.background,
                  ),
            ),
          ),
        ),
        if (state.isLoading)
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              width: double.infinity,
              height: 130.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.grey,
              ),
            ),
          )
        else if (preOrderData != null)
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              width: double.infinity,
              height: 130.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/banner.png"),
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        trailing: Text(
                          "${formatNumber(preOrderData.sisaStockPo!.toString())}/${formatNumber(preOrderData.stockPo!.toString())} Cup",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Waktu :",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                        subtitle: Text(
                            timeStartToEnd(
                                preOrderData.start!, preOrderData.end!),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                )),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(preOrderData.start!.dateFormat(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      decoration: TextDecoration.underline,
                                    )),
                            Text(preOrderData.end!.dateFormat(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        else
          const EmptyPreOrder(),
        Padding(
          padding: EdgeInsets.all(10.r),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isLoading) return;
                showDialog(
                  context: context,
                  builder: (_) => const DialogPreOrder(),
                );
              },
              child: isLoading
                  ? const Text("Loading ...")
                  : const Text("Setting Pre Order"),
            ),
          ),
        ),
      ],
    );
  }
}
