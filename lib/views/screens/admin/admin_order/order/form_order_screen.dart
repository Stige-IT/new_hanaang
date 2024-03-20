import 'dart:developer';
import 'dart:io';

import 'package:admin_hanaang/features/bonus/provider/bonus_provider.dart';
import 'package:admin_hanaang/features/cashback/provider/cashback_provider.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_state.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../features/image_picker/image_picker.dart';
import '../../../../../features/order/order.dart';
import '../../../../../features/price_product/provider/price_product_provider.dart';
import '../../../../../features/users_hanaang/provider/users_hanaang_providers.dart';
import '../../../../../utils/constant/base_url.dart';
import '../../../../../utils/helper/formatted_currency.dart';
import '../../../../../utils/helper/formatted_role.dart';
import '../../../../components/circle_avatar_network.dart';
import '../../../../components/dropdown_container.dart';
import '../../../../components/form_input.dart';
import '../../../../components/loading_in_button.dart';
import '../../../../components/modal_bottom_image_picker_option.dart';
import '../../../../components/profile_with_name.dart';
import '../../../../components/snackbar.dart';

final userSelectedProvider =
    StateProvider.autoDispose<UsersHanaang?>((ref) => null);
final isShowSearchaProvider = StateProvider.autoDispose<bool>((ref) => false);
final paymentMethodProvider = StateProvider.autoDispose<String>(
    (ref) => "e103202b-f615-46ba-9e66-7efe8bc568b6");
final imageSelectedProvider = StateProvider.autoDispose<File?>((ref) => null);

final priceProvider = StateProvider.autoDispose<String>((ref) => "0");
final totalPriceProvider = StateProvider.autoDispose<String>((ref) => "0");
final remainingPriceProvider = StateProvider.autoDispose<String>((ref) => "0");
final isPromoProvider = StateProvider.autoDispose<bool>((ref) => false);

final orderTakenProvider = StateProvider.autoDispose<String>((ref) => "0");
final remainngTakenProvider = StateProvider.autoDispose<String>((ref) => "0");

class FormOrderScreenAO extends ConsumerStatefulWidget {
  final UsersHanaang? usersHanaang;
  const FormOrderScreenAO({super.key, this.usersHanaang});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormOrderScreenAOState();
}

class _FormOrderScreenAOState extends ConsumerState<FormOrderScreenAO> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formOrder = GlobalKey<FormState>();
  late TextEditingController _searchCtrl;
  late TextEditingController _quantityCtrl;
  late TextEditingController _orderTakenCtrl;
  late TextEditingController _nominalCtrl;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(userNotifier.notifier).getData(makeLoading: true);
      if (widget.usersHanaang != null) {
        ref.read(userSelectedProvider.notifier).state = widget.usersHanaang;
      }
    });
    _searchCtrl = TextEditingController();
    _quantityCtrl = TextEditingController(text: '0');
    _orderTakenCtrl = TextEditingController(text: '0');
    _nominalCtrl = TextEditingController(text: '0');

    _quantityCtrl.addListener(() async {
      int totalOrder = int.parse(_quantityCtrl.text.replaceAll(".", ""));
      _orderTakenCtrl.text = _quantityCtrl.text;
      await ref.read(checkPriceNotifier.notifier).getPrice(
          ref.watch(userSelectedProvider)!.id!,
          int.parse(_quantityCtrl.text.replaceAll(".", "")));

      ref.read(totalPriceProvider.notifier).state = formatNumber(
          (totalOrder * (ref.watch(checkPriceNotifier).data ?? 0)).toString());
    });

    _orderTakenCtrl.addListener(() {
      ref.read(orderTakenProvider.notifier).state = _orderTakenCtrl.text;
      remainingTakenOrder();
    });
    _nominalCtrl.addListener(() {
      ref.read(priceProvider.notifier).state = _nominalCtrl.text;
      remainingPayment();
      checkPromo();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _quantityCtrl.dispose();
    _orderTakenCtrl.dispose();
    _nominalCtrl.dispose();
    super.dispose();
  }

  incrementTotalOrder(String value) {
    int total = int.parse(_quantityCtrl.text.replaceAll("", ""));
    total += int.parse(value);
    _quantityCtrl.text = total.toString();
  }

  isMaximumOrder(String value) {
    int orderTake = int.parse(_orderTakenCtrl.text.replaceAll(".", ""));
    int quantity = int.parse(_quantityCtrl.text.replaceAll(".", ""));
    int added = int.parse(value);
    if ((orderTake + added) > quantity) {
      return true;
    }
    return false;
  }

  incrementTotalTakeOrder(String value) {
    if (!isMaximumOrder(value)) {
      int total = int.parse(_orderTakenCtrl.text.replaceAll("", ""));
      total += int.parse(value);
      _orderTakenCtrl.text = total.toString();
    }
  }

  String notYetTakenOrder() {
    if (_quantityCtrl.text.isEmpty) return "0";
    int quantity = int.parse(_quantityCtrl.text.replaceAll(".", ""));
    int orderTaken = int.parse(_orderTakenCtrl.text.replaceAll(".", ""));
    int total = quantity - orderTaken;
    return formatNumber(total.toString());
  }

  void remainingPayment() {
    log(_nominalCtrl.text);
    if (_nominalCtrl.text.isNotEmpty || _nominalCtrl.text != "0") {
      int totalPrice =
          int.parse(ref.watch(totalPriceProvider).replaceAll(".", ""));
      int nominal = int.parse(ref.watch(priceProvider).replaceAll(".", ""));
      int total = totalPrice - nominal;
      ref.read(remainingPriceProvider.notifier).state =
          formatNumber(total.toString());
    } else {
      ref.invalidate(remainingPriceProvider);
    }
  }

  void remainingTakenOrder() {
    if (_orderTakenCtrl.text.isNotEmpty || _orderTakenCtrl.text != "0") {
      int totalOrder = int.parse(_quantityCtrl.text.replaceAll(".", ""));
      int takenOrder =
          int.parse(ref.watch(orderTakenProvider).replaceAll(".", ""));
      int total = totalOrder - takenOrder;
      log(total.toString());
      ref.read(remainngTakenProvider.notifier).state =
          formatNumber(total.toString());
    } else {
      ref.invalidate(remainngTakenProvider);
    }
  }

  void checkPromo() {
    if (int.parse(_nominalCtrl.text.replaceAll(".", "")) > 0) {
      ref.read(isPromoProvider.notifier).state = true;
      final userId = ref.watch(userSelectedProvider)!.id;
      final quantity = int.parse(_quantityCtrl.text.replaceAll(".", ""));
      ref
          .read(checkCashbackNotifierProvider.notifier)
          .checkCashback(userId!, quantity);

      int nominal = int.parse(_nominalCtrl.text.replaceAll('.', ""));
      int totalPrice =
          int.parse(ref.watch(totalPriceProvider).replaceAll(".", ""));
      if (nominal == totalPrice) {
        ref
            .read(checkBonusNotifierProvider.notifier)
            .checkBonus(userId, quantity);
      }
    } else {
      ref.invalidate(isPromoProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifier);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      appBar: AppbarAdmin(scaffoldKey: _key, title: "Pesanan Baru"),
      endDrawer: const EndrawerWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _leftMenu(state, size),
          _rightMenu(),
        ],
      ),
    );
  }

  Flexible _rightMenu() {
    return Flexible(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                "Hasil Pesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (ref.watch(imageSelectedProvider) != null)
                ListTile(
                  title: const Text("Bukti Pembayaran"),
                  trailing: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Builder(builder: (_) {
                      if (ref.watch(imageSelectedProvider) != null) {
                        return Image.file(ref.watch(imageSelectedProvider)!,
                            fit: BoxFit.cover);
                      }
                      return const Icon(Icons.image, size: 50);
                    }),
                  ),
                ),
              const Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                      title: const Text("Jumlah Pesanan"),
                      subtitle: Text(
                        "${_quantityCtrl.text} Cup",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                      title: const Text("Pesanan diambil"),
                      subtitle: Text(
                        "${ref.watch(orderTakenProvider)} Cup",
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -3),
                      title: const Text(
                        "Belum diambil",
                      ),
                      subtitle: Text(
                        "${ref.watch(remainngTakenProvider)} Cup",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Total Bayar"),
                trailing: Text(
                  "Rp. ${ref.watch(totalPriceProvider)}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Dibayar"),
                trailing: Text(
                  "Rp. ${ref.watch(priceProvider)}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                title: const Text("Sisa"),
                trailing: Text(
                  "Rp. ${ref.watch(remainingPriceProvider)}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 1),
              if (ref.watch(isPromoProvider))
                Row(
                  children: [
                    Flexible(
                      child: ListTile(
                        shape: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        title: const Text("Cashback"),
                        trailing: Text(ref
                            .watch(checkCashbackNotifierProvider).data!
                            .convertToIdr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: ListTile(
                        shape: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        title: const Text("Bonus"),
                        trailing: Text(
                            "${ref.watch(checkBonusNotifierProvider)} Cup"),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (ref.watch(userSelectedProvider) == null) {
                      showSnackbar(context, "Harap pilih pengguna",
                          isWarning: true);
                    } else {
                      if (_formOrder.currentState!.validate()) {
                        final totalQuantity =
                            int.parse(_quantityCtrl.text.replaceAll(".", ""));
                        final totalTaken =
                            int.parse(_orderTakenCtrl.text.replaceAll(".", ""));
                        final totalNominal =
                            int.parse(_nominalCtrl.text.replaceAll(".", ""));
                        ref
                            .read(createOrderNotifier.notifier)
                            .create(
                              ref.watch(userSelectedProvider)!.id!,
                              quantity: totalQuantity,
                              orderTaken: totalTaken,
                              paymentMethod: ref.watch(paymentMethodProvider),
                              nominal: totalNominal,
                              proofOfPayment: ref.watch(imageSelectedProvider),
                            )
                            .then((success) {
                          if (success) {
                            Navigator.of(context).pop();
                            showSnackbar(
                                context, "Berhasil membuat pesanan baru");
                          } else {
                            final errorMsg =
                                ref.watch(createOrderNotifier).error;
                            showSnackbar(context, errorMsg!, isWarning: true);
                          }
                        });
                      }
                    }
                  },
                  child: ref.watch(createOrderNotifier).isLoading
                      ? const LoadingInButton()
                      : const Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Flexible _leftMenu(UserState state, Size size) {
    final image = ref.watch(imageSelectedProvider);
    return Flexible(
      child: Stack(
        children: [
          Form(
            key: _formOrder,
            child: ListView(
              padding: const EdgeInsets.all(25.0),
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
                const SizedBox(height: 15),
                const Text(
                  "Form Pesanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            value = formatNumber(value.replaceAll('.', ''));
                            _quantityCtrl.value = TextEditingValue(
                              text: value,
                              selection:
                                  TextSelection.collapsed(offset: value.length),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ["5", "10", "100", "x"].map((value) {
                        if (value != "x") {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => incrementTotalOrder(value),
                              child: Text(value),
                            ),
                          );
                        }
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () => _quantityCtrl.text = "0",
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    )),
                  ],
                ),
                const SizedBox(height: 10),
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
                            value = formatNumber(value.replaceAll('.', ''));
                            _orderTakenCtrl.value = TextEditingValue(
                              text: value,
                              selection:
                                  TextSelection.collapsed(offset: value.length),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ["5", "10", "100", "x"].map((value) {
                        if (value != "x") {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => incrementTotalTakeOrder(value),
                              child: Text(value),
                            ),
                          );
                        }
                        return SizedBox(
                          width: 50,
                          height: 50,
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: DropdownContainer(
                        title: "Metode Pembayaran",
                        value: ref.watch(paymentMethodProvider),
                        items: const [
                          DropdownMenuItem(
                            value: "e103202b-f615-46ba-9e66-7efe8bc568b6",
                            child: Text("Cash"),
                          ),
                          DropdownMenuItem(
                            value: "a9e653ea-3a35-4473-9bb2-1fab7e67c970",
                            child: Text("Transfer"),
                          ),
                        ],
                        onChanged: (value) {
                          ref.read(paymentMethodProvider.notifier).state =
                              value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      flex: 2,
                      child: FieldInput(
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
                            value = formatNumber(value.replaceAll('.', ''));
                            _nominalCtrl.value = TextEditingValue(
                              text: value,
                              selection:
                                  TextSelection.collapsed(offset: value.length),
                            );
                          } else {
                            _nominalCtrl.text = "0";
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Harap isi terlebih dahulu jika melakukan pembayaran";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      if (image != null) {
                        return Card(
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Image.file(image, fit: BoxFit.cover),
                          ),
                        );
                      }
                      return const Card(
                          child: Icon(Icons.image_outlined, size: 70));
                    }),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
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
                                            .read(imageSelectedProvider.notifier)
                                            .state =
                                        await ref
                                            .read(imagePickerProvider.notifier)
                                            .getFromGallery(
                                                source: ImageSource.camera);
                                  },
                                  onTapGalery: () async {
                                    ref
                                            .read(imageSelectedProvider.notifier)
                                            .state =
                                        await ref
                                            .read(imagePickerProvider.notifier)
                                            .getFromGallery(
                                                source: ImageSource.gallery);
                                  },
                                );
                              });
                        },
                        child: Builder(builder: (_) {
                          if (image != null) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    image.path.split("/").last,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      ref.invalidate(imageSelectedProvider);
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            );
                          }
                          return const Text(" + Tambah bukti pembayaran");
                        }),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: ref.watch(isShowSearchaProvider),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(15.0),
                height: size.height * 0.8,
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
                          ref.read(isShowSearchaProvider.notifier).state =
                              false;
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
                                  ref
                                      .read(userSelectedProvider.notifier)
                                      .state = user;
                                  ref
                                      .read(isShowSearchaProvider.notifier)
                                      .state = false;
                                },
                                leading: user.image == null
                                    ? ProfileWithName(user.name ?? "")
                                    : CircleAvatarNetwork(
                                        "$BASE/${user.image}"),
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
