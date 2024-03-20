import 'dart:developer';

import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../enums/print_enums.dart';
import '../models/print_request.dart';

class PrintThermal {
  BlueThermalPrinter print = BlueThermalPrinter.instance;

  Future<bool> start(String? id, {required PrintRequest data}) async {
    try {
      ///base image logo from File path
      String filename = 'logo_hanaang.png';

      ///image from Asset
      ByteData bytesAsset =
          await rootBundle.load("assets/components/$filename");
      Uint8List imageBytesFromAsset = bytesAsset.buffer.asUint8List(
        bytesAsset.offsetInBytes,
        bytesAsset.lengthInBytes,
      );

      /// Address Company
      const String address =
          "Perum Ranca Indah 1 Blok A4 No 1, Jelegong Kec.Rancaekek Bandung, 40394";

      /// datetime now
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      /// Sisa Quantity
      String sisaQuantity =
          ((data.totalQuantity ?? 0) - int.parse(data.quantity!))
              .toString();
      String sisaQuantityFormatted = formatNumber(sisaQuantity);

      /// Sisa Price
      String sisaPrice = ((data.totalPrice ?? 0) - int.parse(data.price!))
          .toString();
      String sisaPriceFormatted = formatNumber(sisaPrice);

      print.isConnected.then((isConnected) {
        if (isConnected == true) {
          /// HEADER
          print.printCustom(
            "Hanaang",
            SizePrint.boldMedium.val,
            Align.center.val,
          );
          print.printCustom(address, SizePrint.medium.val, Align.center.val);
          // bluetooth.printImageBytes(imageBytesFromAsset); //image from Asset
          print.printNewLine();
          // User admin detail name
          print.printLeftRight(
            "Admin: ",
            "Admin order #1",
            SizePrint.medium.val,
          );
          print.printNewLine();
          print.printCustom(
            formattedDate,
            SizePrint.medium.val,
            Align.center.val,
          );
          print.printCustom(
            "================================",
            SizePrint.medium.val,
            Align.center.val,
          );

          /// BODY
          print.printCustom(
            "Order ID: $id",
            SizePrint.bold.val,
            Align.left.val,
          );
          print.printNewLine();

          print.printLeftRight(
            "Pengambilan:",
            "${data.quantity} Cup",
            SizePrint.medium.val,
          );
          print.printLeftRight(
            "Jmlh Bayar:",
            "Rp.${formatNumber(data.price!)}",
            SizePrint.medium.val,
          );

          /// SUMMARY
          print.printNewLine();
          print.printCustom(
            "================================",
            SizePrint.medium.val,
            Align.center.val,
          );
          // Ringkasan pengambilan
          print.printCustom(
            "Ringkasan pengambilan",
            SizePrint.bold.val,
            Align.left.val,
          );
          print.printLeftRight(
            "Total Pesan:",
            "${data.totalQuantity} Cup",
            SizePrint.bold.val,
          );
          print.printLeftRight(
            "Sudah diambil:",
            "$sisaQuantityFormatted Cup",
            SizePrint.bold.val,
          );
          print.printCustom(
            "--------------------------------",
            SizePrint.medium.val,
            Align.center.val,
          );
          print.printNewLine();
          print.printCustom(
            "Ringkasan pembayaran",
            SizePrint.bold.val,
            Align.left.val,
          );
          print.printLeftRight(
            "Sisa belum:",
            "${data.sisaQuantity} Cup",
            SizePrint.bold.val,
          );

          // Ringkasan pembayaran
          print.printLeftRight(
            "Total Harga:",
            "Rp.${formatNumber(data.totalPrice?.toString() ?? "0")}",
            SizePrint.bold.val,
          );
          print.printLeftRight(
            "Sudah Bayar:",
            "Rp.${formatNumber(data.price!)}",
            SizePrint.bold.val,
          );
          print.printCustom(
            "--------------------------------",
            SizePrint.medium.val,
            Align.center.val,
          );
          print.printLeftRight(
            "Sisa Bayar:",
            "Rp.$sisaPriceFormatted",
            SizePrint.bold.val,
          );

          /// FOOTER
          print.printNewLine();
          print.printCustom(
            "================================",
            SizePrint.medium.val,
            Align.center.val,
          );
          print.printCustom(
            "Terima kasih",
            SizePrint.bold.val,
            Align.center.val,
          );
          print.printCustom(
            "Simpan struk ini sebagai bukti  transaksi",
            SizePrint.bold.val,
            Align.center.val,
          );
          print.printCustom(
            "www.hanaang.com",
            SizePrint.bold.val,
            Align.center.val,
          );
          print.printNewLine();
          print.printNewLine();
          print.paperCut(); //some printer not supported
          print.drawerPin2(); // or you can use bluetooth.drawerPin5();
        }
      });
      return true;
    } catch (e) {
      log(e.toString(), name: 'PrintThermal LOG');
      return false;
    }
  }
}
