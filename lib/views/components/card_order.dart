import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../utils/helper/checkStatusLabel.dart';
import 'label.dart';

class CardOrder extends StatefulWidget {
  final OrderData orderData;
  const CardOrder({
    super.key,
    required this.orderData,
  });

  @override
  State<CardOrder> createState() => _CardOrderState();
}

class _CardOrderState extends State<CardOrder> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        nextPage(context, "${AppRoutes.sa}/order-list/detail",
            argument: widget.orderData.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        color: Theme.of(context).colorScheme.surface,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/foto_produk.png",
                    height: 80,
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${widget.orderData.orderNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            Text(
                              widget.orderData.createdAt!.timeFormat(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        // Spacer(),
                        RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                              const TextSpan(
                                text: "Quantity: ",
                                style: TextStyle(fontSize: 12),
                              ),
                              TextSpan(
                                  text: "${widget.orderData.totalOrder}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 25,
                          child: Label(
                            status:
                                checkStatus(widget.orderData.paymentStatus!),
                            title: checkNamed(widget.orderData.paymentStatus!),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 25,
                          child: Label(
                            status: checkStatus(
                                widget.orderData.orderTakingStatus!),
                            title:
                                checkNamed(widget.orderData.orderTakingStatus!),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.orderData.totalPrice?.convertToIdr(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
