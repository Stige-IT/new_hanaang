import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../models/payment.dart';
import '../../utils/constant/base_url.dart';

class TilePaymentDetail extends StatelessWidget {
  const TilePaymentDetail({
    super.key,
    required this.payment,
  });

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final image = payment.proofOfPayment;

    return Card(
      child: ExpansionTile(
        textColor: Colors.black,
        leading: const Icon(
          Icons.attach_money_rounded,
          color: Colors.green,
        ),
        trailing: Text(
          "${payment.createdAt!.timeFormat()} WIB",
          style: const TextStyle(fontSize: 10),
        ),
        title: Text(
          "${int.parse(payment.nominal!).convertToIdr()}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "oleh: ${payment.createdBy!.name}",
        ),
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
                image: payment.proofOfPayment == null
                    ? null
                    : DecorationImage(
                        onError: (exception, stackTrace) {},
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "$BASE/${payment.proofOfPayment}",
                        ),
                      )),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black26,
              ),
              child: InkWell(
                onTap: image == null
                    ? () {}
                    : () {
                        Size size = MediaQuery.of(context).size;
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  titleTextStyle:
                                      const TextStyle(color: Colors.white),
                                  insetPadding: EdgeInsets.zero,
                                  content: SizedBox(
                                    width: size.width,
                                    child: PhotoView(
                                      backgroundDecoration: const BoxDecoration(
                                          color: Colors.transparent),
                                      imageProvider: NetworkImage(
                                        "$BASE/${payment.proofOfPayment}",
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("kembali",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                ));
                      },
                child: Text(
                  image == null
                      ? "Tidak ada Bukti Pembayaran"
                      : "Klik untuk melihat",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
