import 'dart:io';

import 'package:admin_hanaang/features/image_picker/image_picker.dart';
import 'package:admin_hanaang/features/price_product/provider/price_product_provider.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/helper/formatted_role.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/modal_bottom_image_picker_option.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../features/order/order.dart';
import '../../../../../utils/helper/formatted_currency.dart';

final userSelectedProvider =
    StateProvider.autoDispose<UsersHanaang?>((ref) => null);
final paymentMethodProvider = StateProvider.autoDispose<String>(
    (ref) => "e103202b-f615-46ba-9e66-7efe8bc568b6");
final imageSelectedProvider = StateProvider.autoDispose<File?>((ref) => null);

final totalPriceProvider = StateProvider.autoDispose<String>((ref) => "Rp.0");
final priceProvider = StateProvider.autoDispose<String>((ref) => "0");
final isShowSearchaProvider = StateProvider.autoDispose<bool>((ref) => false);
final isShowFormPayment = StateProvider.autoDispose<bool>((ref) => false);

class FormOrderScreen extends ConsumerStatefulWidget {
  final UsersHanaang? usersHanaang;
  const FormOrderScreen({
    super.key,
    this.usersHanaang,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormOrderScreenState();
}

class _FormOrderScreenState extends ConsumerState<FormOrderScreen> {
  late TextEditingController _quantityCtrl;
  late TextEditingController _orderTakenCtrl;
  late TextEditingController _nominalCtrl;
  late TextEditingController _searchCtrl;
  final GlobalKey<FormState> _formOrder = GlobalKey<FormState>();

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userNotifier.notifier).getData(makeLoading: true);
      if (widget.usersHanaang != null) {
        ref.read(userSelectedProvider.notifier).state = widget.usersHanaang;
      }
    });
    _quantityCtrl = TextEditingController(text: '0');
    _orderTakenCtrl = TextEditingController(text: '0');
    _nominalCtrl = TextEditingController(text: '0');
    _searchCtrl = TextEditingController();

    _quantityCtrl.addListener(() async {
      int totalOrder = int.parse(_quantityCtrl.text.replaceAll(".", ""));
      _orderTakenCtrl.text = _quantityCtrl.text;
      await ref.read(checkPriceNotifier.notifier).getPrice(
          ref.watch(userSelectedProvider)!.id!,
          int.parse(_quantityCtrl.text.replaceAll(".", "")));

      ref.read(totalPriceProvider.notifier).state =
          (totalOrder * (ref.watch(checkPriceNotifier).data ?? 0))
              .convertToIdr();
    });
    _nominalCtrl.addListener(() {
      ref.read(priceProvider.notifier).state = _nominalCtrl.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _orderTakenCtrl.dispose();
    _nominalCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  incrementTotalOrder(String value) {
    int total = int.parse(_quantityCtrl.text.replaceAll("", ""));
    total += int.parse(value);
    _quantityCtrl.text = total.toString();
  }

  incrementTotalTakeOrder(String value) {
    if (int.parse(_orderTakenCtrl.text.replaceAll(".", "")) <
        int.parse(_quantityCtrl.text.replaceAll(".", ""))) {
      int total = int.parse(_orderTakenCtrl.text.replaceAll("", ""));
      total += int.parse(value);
      _orderTakenCtrl.text = total.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifier);
    final image = ref.watch(imageSelectedProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Pesanan Baru"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 70.0),
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      visualDensity: const VisualDensity(horizontal: -3),
                      title: const Text("Pilih Pengguna",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          )),
                      subtitle: Builder(builder: (context) {
                        if (state.isLoading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                          );
                        }
                        return _buildDropdownSearch();
                      }),
                    ),
                    //form order
                    const SizedBox(height: 15),
                    if (ref.watch(userSelectedProvider) != null)
                      Form(
                        key: _formOrder,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Form Pesanan",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Divider(thickness: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: FieldInput(
                                    textAlign: TextAlign.center,
                                    title: "Jumlah Pesanan",
                                    hintText: "",
                                    suffixText: " Cup",
                                    controller: _quantityCtrl,
                                    textValidator: "",
                                    keyboardType: TextInputType.number,
                                    obsecureText: false,
                                    onTap: () {
                                      if (_quantityCtrl.text == "0") {
                                        _quantityCtrl.clear();
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        value = formatNumber(
                                            value.replaceAll('.', ''));
                                        _quantityCtrl.value = TextEditingValue(
                                          text: value,
                                          selection: TextSelection.collapsed(
                                              offset: value.length),
                                        );
                                      } else {
                                        _quantityCtrl.text = "0";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      ["5", "10", "100", "x"].map((value) {
                                    if (value != "x") {
                                      return SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () =>
                                              incrementTotalOrder(value),
                                          child: Text(value),
                                        ),
                                      );
                                    }
                                    return SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () =>
                                            _quantityCtrl.text = "0",
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: FieldInput(
                                    textAlign: TextAlign.center,
                                    title: "Pesanan diambil",
                                    hintText: "",
                                    suffixText: " Cup",
                                    controller: _orderTakenCtrl,
                                    textValidator: "",
                                    keyboardType: TextInputType.number,
                                    obsecureText: false,
                                    onTap: () {
                                      if (_orderTakenCtrl.text == "0") {
                                        _orderTakenCtrl.clear();
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        value = formatNumber(
                                            value.replaceAll('.', ''));
                                        _orderTakenCtrl.value =
                                            TextEditingValue(
                                          text: value,
                                          selection: TextSelection.collapsed(
                                              offset: value.length),
                                        );
                                      } else {
                                        _orderTakenCtrl.text = "0";
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      ["5", "10", "100", "x"].map((value) {
                                    if (value != "x") {
                                      return SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () =>
                                              incrementTotalTakeOrder(value),
                                          child: Text(value),
                                        ),
                                      );
                                    }
                                    return SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          _orderTakenCtrl.text = "0";
                                        },
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                )),
                              ],
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                ref.read(isShowFormPayment.notifier).state =
                                    !ref.watch(isShowFormPayment);
                              },
                              icon: ref.watch(isShowFormPayment)
                                  ? const Icon(Icons.toggle_on)
                                  : const Icon(Icons.toggle_off_outlined),
                              label: const Text("Lakukan Pembayaran"),
                            ),

                            //Form payment
                            if (ref.watch(isShowFormPayment))
                              Column(
                                children: [
                                  DropdownContainer(
                                    title: "Metode Pembayaran",
                                    value: ref.watch(paymentMethodProvider),
                                    items: const [
                                      DropdownMenuItem(
                                        value:
                                            "e103202b-f615-46ba-9e66-7efe8bc568b6",
                                        child: Text("Cash"),
                                      ),
                                      DropdownMenuItem(
                                        value:
                                            "a9e653ea-3a35-4473-9bb2-1fab7e67c970",
                                        child: Text("Transfer"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      ref
                                          .read(paymentMethodProvider.notifier)
                                          .state = value!;
                                    },
                                  ),
                                  FieldInput(
                                    title: "Nominal",
                                    hintText: "",
                                    prefixText: "Rp. ",
                                    controller: _nominalCtrl,
                                    textValidator: "",
                                    keyboardType: TextInputType.number,
                                    obsecureText: false,
                                    onTap: () {
                                      if (_nominalCtrl.text == "0") {
                                        _nominalCtrl.clear();
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        value = formatNumber(
                                            value.replaceAll('.', ''));
                                        _nominalCtrl.value = TextEditingValue(
                                          text: value,
                                          selection: TextSelection.collapsed(
                                              offset: value.length),
                                        );
                                      } else {
                                        _nominalCtrl.text = "0";
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          )),
                                          context: context,
                                          builder: (_) {
                                            return ModalBottomOptionImagePicker(
                                              onTapCamera: () async {
                                                ref
                                                        .read(
                                                            imageSelectedProvider
                                                                .notifier)
                                                        .state =
                                                    await ref
                                                        .read(
                                                            imagePickerProvider
                                                                .notifier)
                                                        .getFromGallery(
                                                            source: ImageSource
                                                                .camera);
                                              },
                                              onTapGalery: () async {
                                                ref
                                                        .read(
                                                            imageSelectedProvider
                                                                .notifier)
                                                        .state =
                                                    await ref
                                                        .read(
                                                            imagePickerProvider
                                                                .notifier)
                                                        .getFromGallery(
                                                            source: ImageSource
                                                                .gallery);
                                              },
                                            );
                                          });
                                    },
                                    child: Builder(builder: (_) {
                                      if (image != null) {
                                        return InkWell(
                                          child: Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(image),
                                                )),
                                          ),
                                        );
                                      }
                                      return const Center(
                                          child: Text(
                                              " + Tambah bukti pembayaran"));
                                    }),
                                  )
                                ],
                              )
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -4),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      title: const Text("Total Bayar",
                          style: TextStyle(fontSize: 12)),
                      subtitle: Text(
                        ref.watch(totalPriceProvider),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      title:
                          const Text("Bayar", style: TextStyle(fontSize: 12)),
                      subtitle: Text(
                        "Rp.${ref.watch(priceProvider)}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (ref.watch(userSelectedProvider) == null) {
                          showSnackbar(context, "Harap pilih pengguna",
                              isWarning: true);
                        } else {
                          if (_formOrder.currentState!.validate()) {
                            final totalQuantity = int.parse(
                                _quantityCtrl.text.replaceAll(".", ""));
                            final totalTaken = int.parse(
                                _orderTakenCtrl.text.replaceAll(".", ""));
                            final totalNominal = int.parse(
                                _nominalCtrl.text.replaceAll(".", ""));
                            ref
                                .read(createOrderNotifier.notifier)
                                .create(
                                  ref.watch(userSelectedProvider)!.id!,
                                  quantity: totalQuantity,
                                  orderTaken: totalTaken,
                                  paymentMethod:
                                      ref.watch(paymentMethodProvider),
                                  nominal: totalNominal,
                                  proofOfPayment:
                                      ref.watch(imageSelectedProvider),
                                )
                                .then((success) {
                              if (success) {
                                Navigator.of(context).pop();
                                showSnackbar(
                                    context, "Berhasil membuat pesanan baru");
                              } else {
                                final errorMsg =
                                    ref.watch(createOrderNotifier).error;
                                showSnackbar(context, errorMsg!,
                                    isWarning: true);
                              }
                            });
                          }
                        }
                      },
                      child: ref.watch(createOrderNotifier).isLoading
                          ? const LoadingInButton()
                          : const Text("Simpan"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: ref.watch(isShowSearchaProvider),
            child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(15.0),
              height: size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Daftar Pengguna",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: IconButton(
                      onPressed: () {
                        ref.read(isShowSearchaProvider.notifier).state = false;
                        ref.read(userNotifier.notifier).getData();
                        _searchCtrl.clear();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  FieldInput(
                    hintText: "Masukkan Nama pengguna",
                    controller: _searchCtrl,
                    textValidator: "",
                    keyboardType: TextInputType.text,
                    obsecureText: false,
                    onChanged: (value) {
                      ref.read(userNotifier.notifier).searchData(value);
                    },
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (_, i) {
                          UsersHanaang user = state.data![i];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              onTap: () {
                                ref.read(userSelectedProvider.notifier).state =
                                    user;
                                ref.read(isShowSearchaProvider.notifier).state =
                                    false;
                              },
                              leading: user.image == null
                                  ? ProfileWithName(user.name ?? "")
                                  : CircleAvatarNetwork("$BASE/${user.image}"),
                              title: Text(user.name ?? ""),
                              subtitle: Text(user.email ?? "-"),
                              trailing:
                                  Text(formatToRoleUser(user.roleId ?? "")),
                            ),
                          );
                        },
                        separatorBuilder: (_, i) => const SizedBox(height: 5),
                        itemCount: (state.data ?? []).length),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSearch() {
    return InkWell(
      onTap: () {
        ref.read(isShowSearchaProvider.notifier).state = true;
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Builder(builder: (context) {
          if (ref.watch(userSelectedProvider) != null) {
            UsersHanaang user = ref.watch(userSelectedProvider)!;
            return ListTile(
              leading: user.image == null
                  ? ProfileWithName(user.name!)
                  : CircleAvatarNetwork("$BASE/${user.image}"),
              title: Text(user.name ?? ""),
              subtitle: Text(user.email ?? "-"),
              trailing: Text(formatToRoleUser(user.roleId ?? "")),
            );
          }
          return const ListTile(
            leading: Icon(Icons.person),
            title: Text("Pilih Pengguna"),
            trailing: Icon(Icons.arrow_drop_down),
          );
        }),
      ),
    );
  }
}
