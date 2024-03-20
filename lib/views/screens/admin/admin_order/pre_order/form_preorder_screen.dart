import 'dart:io';

import 'package:admin_hanaang/features/pre-order/provider/pre_order_provider.dart';
import 'package:admin_hanaang/features/pre_order_users/provider/pre_order_user_provider.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/modal_bottom_image_picker_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../../features/bonus/provider/bonus_provider.dart';
import '../../../../../features/cashback/provider/cashback_provider.dart';
import '../../../../../features/image_picker/image_picker.dart';
import '../../../../../models/pre_order_user.dart';
import '../../../../../utils/helper/formatted_currency.dart';
import '../../../../components/form_input.dart';
import '../../../../components/snackbar.dart';
import '../../../../components/tile_result.dart';

class FormPreOrderScreenAO extends ConsumerStatefulWidget {
  final PreOrderUser dataUser;

  const FormPreOrderScreenAO(this.dataUser, {super.key});

  @override
  ConsumerState createState() => _FormPreOrderScreenAOState();
}

class _FormPreOrderScreenAOState extends ConsumerState<FormPreOrderScreenAO> {
  File? image;
  late TextEditingController _quantityOrderCtrl;
  late TextEditingController _nominalCtrl;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() {
      final quantity = (widget.dataUser.quantity!);
      ref.watch(quantityNotifier.notifier).state = quantity;
    });
    _quantityOrderCtrl = TextEditingController(text: widget.dataUser.quantity!.toString());
    _nominalCtrl = TextEditingController(text: "0");
    super.initState();
  }

  @override
  void dispose() {
    _quantityOrderCtrl.dispose();
    _nominalCtrl.dispose();
    ref.invalidate(checkBonusNotifierProvider);
    ref.invalidate(checkCashbackNotifierProvider);
    super.dispose();
  }

  Map items = {
    "Cash": "e103202b-f615-46ba-9e66-7efe8bc568b6",
    "Transfer": "a9e653ea-3a35-4473-9bb2-1fab7e67c970",
  };

  @override
  Widget build(BuildContext context) {
    ref.listen(checkBonusNotifierProvider, (previous, next) {
      if (next > 0) {
        showSnackbar(
            context, "Berhasil mendapatkan bonus $next Cup, harap dicek");
      }
    });

    ref.listen(checkCashbackNotifierProvider, (previous, next) {
      final cashback = next.data ?? 0;
      if ( cashback > 0) {
        showSnackbar(context,
            "Berhasil mendapatkan Cashback sebesar ${cashback.convertToIdr()}");
      }
    });

    bool toogleIsEnable = ref.watch(togglePaidProvider);
    final methodPaidKey = ref.watch(dropdownMethodPainNotifier);
    final quantity = ref.watch(quantityNotifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Form Pesanan"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          ///[*Form quantity take order]
                          _quantityTotal(),

                          ///[*Toggle Switch payment]
                          _toggleIsPayment(toogleIsEnable),
                          const Text(
                            "* Jika melakukan pembayaran sekarang maka akan terhitung bonus",
                            style:
                                TextStyle(color: Colors.black26, fontSize: 10),
                          ),

                          ///[*From payment when toggle is active]
                          _formPayment(toogleIsEnable, methodPaidKey, items),
                          const SizedBox(height: 200),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    Expanded(
                      child: summaryWidget(quantity),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _quantityTotal() {
    final int totalBonus = ref.watch(checkBonusNotifierProvider);
    int total = (widget.dataUser.quantity!) + totalBonus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Jumlah pengambilan : "),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityOrderCtrl,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffix: Text('/ $total Cup'),
                      ),
                      validator: (value) {
                        if (int.parse(value!) > total) {
                          return "Melebihi Total Pesanan";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (int.parse(value) <= total) {
                            ref.watch(quantityNotifier.notifier).state =
                                int.parse(value);
                          } else {
                            ref.watch(quantityNotifier.notifier).state = total;
                            _quantityOrderCtrl.text = total.toString();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _handleQuantity(false),
              icon: const Icon(Icons.remove_circle),
            ),
            IconButton(
              onPressed: () => _handleQuantity(true),
              icon: const Icon(Icons.add_circle),
            )
          ],
        ),
      ],
    );
  }

  Row _toggleIsPayment(bool toogleIsEnable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (_quantityOrderCtrl.text.isNotEmpty) {
              if (!toogleIsEnable) {
                ref.watch(checkCashbackNotifierProvider.notifier).checkCashback(
                      widget.dataUser.user!.id!,
                      (widget.dataUser.quantity!),
                    );
              } else {
                ref.invalidate(checkBonusNotifierProvider);
                ref.invalidate(checkCashbackNotifierProvider);
              }
              ref.watch(togglePaidProvider.notifier).state = !toogleIsEnable;
            } else {
              showSnackbar(context, "Harap isi Quantity", isWarning: true);
            }
          },
          icon: Icon(
            toogleIsEnable ? Icons.toggle_on : Icons.toggle_off_outlined,
            size: 40,
            color: toogleIsEnable ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
        const Text("Lakukan Pembayaran"),
      ],
    );
  }

  Visibility _formPayment(
      bool toogleIsEnable, String? methodPaidKey, Map<dynamic, dynamic> items) {
    return Visibility(
      visible: toogleIsEnable,
      child: Column(
        children: [
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 2,
                      color: Colors.black12),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  hint: const Text("Pilih Metode Pembayaran"),
                  value: methodPaidKey,
                  items: items
                      .map((key, value) => MapEntry(
                            key,
                            DropdownMenuItem(
                              value: value,
                              child: Text(key),
                            ),
                          ))
                      .values
                      .toList(),
                  onChanged: (value) {
                    ref.watch(dropdownMethodPainNotifier.notifier).state =
                        value.toString();
                  },
                ),
              ),
            ),
          ),
          FieldInput(
            prefixText: "RP. ",
            title: "Nominal",
            hintText: "0",
            controller: _nominalCtrl,
            textValidator: "",
            keyboardType: TextInputType.number,
            obsecureText: false,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            onTap: () {
              if (_nominalCtrl.text == "0") {
                _nominalCtrl.clear();
              }
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                value = formatNumber(value.replaceAll('.', ''));
                _nominalCtrl.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                );
                int nominal = int.parse(value.replaceAll(".", ""));
                if (nominal >= _totalPrice()) {
                  ref.watch(checkBonusNotifierProvider.notifier).checkBonus(
                        widget.dataUser.user!.id!,
                        int.parse(_quantityOrderCtrl.text),
                      );
                  ref.read(isMoreThanTotalPriceProvider.notifier).state = true;
                } else {
                  ref.invalidate(isMoreThanTotalPriceProvider);
                  ref.invalidate(checkBonusNotifierProvider);
                }
              }
            },
            validator: (value) {
              if (value!.isEmpty || value == "0") {
                return "Harap di isi";
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            title: const Text(
              "Bukti Pembayaran",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: image == null
                ? OutlinedButton.icon(
                    onPressed: () async => await _handleGetImage(),
                    label: const Text("Tambahkan gambar"),
                    icon: const Icon(Icons.add),
                  )
                : InkWell(
                    onTap: () async => await _handleGetImage(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  bool isMoreThanTotalPrice() {
    if (_nominalCtrl.text.isNotEmpty) {
      final nominal = int.parse(_nominalCtrl.text.replaceAll(".", ""));
      if (nominal >= _totalPrice()) {
        return true;
      }
    }
    return false;
  }

  Container summaryWidget(int quantity) {
    final totalBonus = ref.watch(checkBonusNotifierProvider);
    final methodId = ref.watch(dropdownMethodPainNotifier);
    final isMoreThan = ref.watch(isMoreThanTotalPriceProvider);
    final cashback = ref.watch(checkCashbackNotifierProvider);
    return Container(
      // height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Ringkasan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(thickness: 2),
          TileResult(
            title: "Jumlah Pengambilan",
            value: "$quantity Cup",
          ),
          TileResult(
            title: "Bonus",
            value: "$totalBonus Cup",
          ),
          TileResult(
            title: "Cashback",
            value: int.parse((cashback.data ?? "0").toString()).convertToIdr(),
          ),
          TileResult(
            title: "Harga satuan",
            value: "${(widget.dataUser.price!).convertToIdr()}/Cup",
          ),
          TileResult(
            title: "total Pesanan",
            value: "${widget.dataUser.quantity!} Cup",
          ),
          Row(
            children: [
              const Expanded(child: Divider(thickness: 2)),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.refresh_rounded))
            ],
          ),
          TileResult(
            isHeading: true,
            title: "total Bayar",
            value: _totalPrice().convertToIdr(),
          ),
          TileResult(
            isHeading: true,
            title: "Bayar",
            value: int.parse(_nominalCtrl.text.isEmpty
                    ? "0"
                    : _nominalCtrl.text.replaceAll('.', ''))
                .convertToIdr(),
          ),
          TileResult(
            isHeading: true,
            title: isMoreThan ? "Kembalian" : "Sisa",
            value: (isMoreThan
                    ? _totalPrice() -
                        int.parse(
                          (_nominalCtrl.text.isEmpty ? "0" : _nominalCtrl.text)
                              .replaceAll('.', ''),
                        )
                    : 0)
                .convertToIdr(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              PanaraConfirmDialog.show(
                context,
                message: "Anda akan melakukan transaksi",
                panaraDialogType: PanaraDialogType.warning,
                cancelButtonText: 'Kembali',
                confirmButtonText: 'Simpan',
                onTapCancel: Navigator.of(context).pop,
                onTapConfirm: () {
                  if (!ref.watch(updatePreOrderUsersNotifier).isLoading) {
                    Navigator.of(context).pop();
                    if (_globalKey.currentState!.validate()) {
                      int nominal =
                          int.parse(_nominalCtrl.text.replaceAll(".", ""));
                      if (isMoreThanTotalPrice()) {
                        nominal = _totalPrice();
                      }
                      ref
                          .watch(updatePreOrderUsersNotifier.notifier)
                          .updateToOrder(
                            widget.dataUser.id!,
                            widget.dataUser.user!.id!,
                            orderTaken: quantity,
                            nominal: nominal,
                            proofOfPayment: image,
                            paymentMethodId: methodId,
                          )
                          .then((success) {
                        if (success) {
                          Navigator.of(context).pop();
                          showSnackbar(context, 'Berhasil menjadikan pesanan');
                        } else {
                          final err =
                              ref.watch(updatePreOrderUsersNotifier).error;
                          showSnackbar(context, err!, isWarning: true);
                        }
                      });
                    }
                  }
                },
              );
            },
            child: ref.watch(updatePreOrderUsersNotifier).isLoading
                ? const LoadingInButton()
                : const Text("Simpan"),
          ),
          if (ref.watch(updatePreOrderUsersNotifier).isLoading)
            const LinearProgressIndicator()
        ],
      ),
    );
  }

  int _totalPrice() {
    int total = (widget.dataUser.totalPrice!);
    int cashback = ref.watch(checkCashbackNotifierProvider).data ?? 0;
    int result = total - cashback;
    return result;
  }

  _handleGetImage() async {
    File? newImage;
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        context: context,
        builder: (_) {
          return ModalBottomOptionImagePicker(
            onTapCamera: () async {
              newImage = await ref
                  .watch(imagePickerProvider.notifier)
                  .getFromGallery(source: ImageSource.camera);
              if (!mounted) return;
              Navigator.pop(context);
            },
            onTapGalery: () async {
              newImage = await ref
                  .watch(imagePickerProvider.notifier)
                  .getFromGallery(source: ImageSource.gallery);
              if (!mounted) return;
              Navigator.pop(context);
            },
          );
        });
    if (newImage != null) {
      setState(() {
        image = newImage;
      });
    }
  }

  _handleQuantity(bool isIsncrement) {
    int quantity = int.parse(_quantityOrderCtrl.text);
    final int totalBonus = ref.watch(checkBonusNotifierProvider);
    int total = (widget.dataUser.quantity!) + totalBonus;
    if (isIsncrement && int.parse(_quantityOrderCtrl.text) < total) {
      ref.watch(quantityNotifier.notifier).state++;
      quantity++;
    } else if (!isIsncrement && int.parse(_quantityOrderCtrl.text) > 0) {
      ref.watch(quantityNotifier.notifier).state--;
      quantity--;
    }
    _quantityOrderCtrl.text = quantity.toString();
  }
}
