import 'dart:developer';

import 'package:admin_hanaang/models/retur.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../../features/retur/provider/retur_provider.dart';
import '../../../../../utils/constant/base_url.dart';
import '../../../../../utils/helper/checkStatusLabel.dart';
import '../../../../components/rounded_button.dart';
import '../../../../components/snackbar.dart';

class ReturScreenAO extends ConsumerStatefulWidget {
  const ReturScreenAO({super.key});

  @override
  ConsumerState createState() => _ReturScreenAOState();
}

class _ReturScreenAOState extends ConsumerState<ReturScreenAO> {
  late TextEditingController _descriptionCtrl;
  late TextEditingController _searchCtrl;
  late TextEditingController _quantityCtrl;
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKeyDialog = GlobalKey<FormState>();
  List<Retur> returs = [];

  _getData() async {
    ref.watch(returProcessNotifier.notifier).getRetur();
    ref.watch(returAcceptNotifier.notifier).getRetur();
    ref.watch(returRejectNotifier.notifier).getRetur();
    ref.watch(returFinishNotifier.notifier).getRetur();
  }

  @override
  void initState() {
    _descriptionCtrl = TextEditingController();
    _searchCtrl = TextEditingController();
    _quantityCtrl = TextEditingController();
    Future.microtask(() {
      _getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(returProvider);
    ref.invalidate(selectedIndexProvider);
    ref.invalidate(indexProvider);
    ref.invalidate(isShowSearchProvider);
    _searchCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollCtrl = ScrollController();
    final ScrollController scrollReturCtrl = ScrollController();
    final ScrollController scrollDetailCtrl = ScrollController();
    final isLoadingReject = ref.watch(rejectReturNotifier).isLoading;
    final isLoadingAccept = ref.watch(createAcceptReturNotifier).isLoading;
    final isLoadingTaking = ref.watch(takingReturNotifier).isLoading;

    final diProsesData = ref.watch(returProcessNotifier).data;
    final disetujuiData = ref.watch(returAcceptNotifier).data;
    final diTolakData = ref.watch(returRejectNotifier).data;
    final finishData = ref.watch(returFinishNotifier).data;

    final size = MediaQuery.of(context).size;
    Retur? retur = ref.watch(returProvider);
    final index = ref.watch(indexProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

    final data = [diProsesData, disetujuiData, diTolakData, finishData];
    final List<Retur> allData = [
      ...diProsesData ?? [],
      ...disetujuiData ?? [],
      ...diTolakData ?? [],
      ...finishData ?? []
    ];
    final searchData = ref.watch(searchNotifier);
    final isShowSearch = ref.watch(isShowSearchProvider);
    returs = data[index] ?? [];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: false,
        appBar: AppbarAdmin(title: "Retur", scaffoldKey: _key),
        endDrawer: const EndrawerWidget(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    FieldInput(
                      prefixIcons: const Icon(Icons.search),
                      hintText: "Masukkan Nomor Retur",
                      controller: _searchCtrl,
                      textValidator: "Nomor retur",
                      keyboardType: TextInputType.text,
                      obsecureText: false,
                      isRounded: false,
                      onTap: () {
                        if (!isShowSearch) {
                          ref.watch(isShowSearchProvider.notifier).state = true;
                          ref
                              .watch(searchNotifier.notifier)
                              .searchByQuery(allData, query: "");
                        }
                      },
                      onChanged: (value) {
                        ref
                            .watch(searchNotifier.notifier)
                            .searchByQuery(allData, query: value);
                      },
                      suffixIcon: isShowSearch
                          ? IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                ref.invalidate(isShowSearchProvider);
                                ref.invalidate(searchNotifier);
                                _searchCtrl.clear();
                              },
                              icon: const Icon(Icons.close))
                          : null,
                    ),
                    if (!isShowSearch)
                      Scrollbar(
                        thumbVisibility: true,
                        controller: scrollCtrl,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          controller: scrollCtrl,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RoundedButton(
                                title: "Diproses",
                                isSelected: index == 0,
                                onTap: () => onChangeIndexButton(0),
                              ),
                              RoundedButton(
                                title: "Disetujui",
                                isSelected: index == 1,
                                onTap: () => onChangeIndexButton(1),
                              ),
                              RoundedButton(
                                title: "Ditolak",
                                isSelected: index == 2,
                                onTap: () => onChangeIndexButton(2),
                              ),
                              RoundedButton(
                                title: "Selesai",
                                isSelected: index == 3,
                                onTap: () => onChangeIndexButton(3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1), () {
                            _getData();
                          });
                        },
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: scrollReturCtrl,
                          child: ListView.separated(
                            controller: scrollReturCtrl,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                              right: 5.0,
                            ),
                            itemBuilder: (_, i) {
                              Retur retur =
                                  isShowSearch ? searchData[i] : returs[i];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 2,
                                color: Theme.of(context).colorScheme.surface,
                                child: ListTile(
                                  selected: selectedIndex == i + 1,
                                  onTap: () {
                                    ref
                                        .watch(selectedIndexProvider.notifier)
                                        .state = i + 1;
                                    ref.watch(returProvider.notifier).state =
                                        retur;
                                  },
                                  leading: const Icon(
                                      Icons.assignment_return_outlined),
                                  title: Text(
                                    retur.returNumber!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "${retur.date!.timeFormat()} WIB",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Text(
                                    "${retur.quantity} Cup",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, i) =>
                                const SizedBox(height: 5),
                            itemCount: isShowSearch
                                ? searchData.length
                                : returs.length,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            /// Side page right
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Scrollbar(
                    controller: scrollDetailCtrl,
                    child: SingleChildScrollView(
                      controller: scrollDetailCtrl,
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Detail Retur Produk",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (retur == null)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_drink,
                                      size: 75,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Klik Kartu retur terlebih dahulu."),
                                  ],
                                ),
                              ),
                            )
                          else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: const Text("No.Retur"),
                                            subtitle: Text(
                                              retur.returNumber!,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text("Tanggal Retur"),
                                            subtitle: Text(
                                              retur.date!.dateFormatWithDay(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text("Jumlah Retur"),
                                            subtitle: Text(
                                              "${retur.quantity} Cup",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          if (retur.status?.name! ==
                                              "Disetujui")
                                            ListTile(
                                              title: const Text("belum diambil",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              subtitle: Text(
                                                "${retur.notYetTaken} Cup",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Sudah diambil",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    "${retur.alreadyTaken} Cup",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          SizedBox(
                                            width: 100,
                                            child: ListTile(
                                              title: const Text("Status"),
                                              subtitle: SizedBox(
                                                height: 30,
                                                width: 100,
                                                child: Label(
                                                  title: retur.status!.name,
                                                  status: checkStatusRetur(
                                                      retur.status!.name!),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: const Text("No.Pesanan"),
                                            subtitle: Text(
                                              retur.order!.orderNumber!,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            title:
                                                const Text("Tanggal Pemesanan"),
                                            subtitle: Text(
                                              retur.order!.createdAt!
                                                  .dateFormatWithDay(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text("Jumlah Pesanan"),
                                            subtitle: Text(
                                              "${retur.order!.totalOrder} Cup",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text("Total Bayar"),
                                            subtitle: Text(
                                              retur.order?.totalPrice?.convertToIdr(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                ///[* If order rejected show the message]
                                if (retur.messageRejected != null)
                                  ListTile(
                                    title: const Text(
                                      "Pesan Alasan Penolakan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    subtitle: Text(
                                      retur.messageRejected!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                const Divider(thickness: 2),
                                ListTile(
                                  title: const Text(
                                    "Deskripsi Retur",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(retur.detail!),
                                ),
                                const Divider(thickness: 2),
                                if (retur.image!.isNotEmpty)
                                  GridView.count(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(15.0),
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 3,
                                    shrinkWrap: true,
                                    children: retur.image!
                                        .map(
                                          (image) => InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        titleTextStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white),
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        content: SizedBox(
                                                          width: size.width,
                                                          child: PhotoView(
                                                            backgroundDecoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .transparent),
                                                            imageProvider:
                                                                NetworkImage(
                                                              "$BASE/${image.image}",
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                "kembali",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                )),
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            child: Card(
                                              elevation: 3,
                                              child: Image.network(
                                                "$BASE/${image.image!}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons
                                                        .image_not_supported_rounded,
                                                    size: 50.h,
                                                    color: Colors.red.shade400,
                                                  );
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                else
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image_not_supported,
                                              size: 50),
                                          SizedBox(height: 10),
                                          Text("Tidak ada Foto"),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),

                  //show button if status == Diproses
                  if (retur != null && retur.status?.name! == "Diproses")
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () => _handleRejectRetur(retur),
                                  child: isLoadingReject
                                      ? const LoadingInButton()
                                      : const Text("Tolak")),
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleAcceptRetur(retur),
                                child: isLoadingAccept
                                    ? const LoadingInButton()
                                    : const Text("Terima"),
                              ),
                            )
                          ],
                        ),
                      ),
                    )

                  //show button if status == Disetujui
                  else if (retur != null && retur.status?.name! == "Disetujui")
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () =>
                              _dialogTakingRetur(retur.id!, _quantityCtrl.text),
                          child: isLoadingTaking
                              ? const LoadingInButton()
                              : const Text("Ambil Produk"),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onChangeIndexButton(int index) {
    ref.invalidate(selectedIndexProvider);
    ref.invalidate(returProvider);
    ref.watch(indexProvider.notifier).state = index;
  }

  _dialogTakingRetur(String id, String quantity) {
    final searchData = ref.watch(searchNotifier);
    final isShowSearch = ref.watch(isShowSearchProvider);
    Retur? retur = ref.watch(returProvider);
    Size size = MediaQuery.of(context).size;
    int index = ref.watch(selectedIndexProvider) - 1;
    showDialog(
        context: context,
        builder: (_) => Form(
              key: _formKeyDialog,
              child: AlertDialog(
                title: const Text("Pengambilan Produk Retur"),
                content: SizedBox(
                  height: size.height * 0.15,
                  child: FieldInput(
                    suffixText: "Cup / ${retur?.notYetTaken ?? 0} Cup",
                    hintText: "0",
                    controller: _quantityCtrl,
                    textValidator: "",
                    keyboardType: TextInputType.number,
                    obsecureText: false,
                  ),
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      if (_formKeyDialog.currentState!.validate()) {
                        Navigator.of(context).pop();
                        ref
                            .watch(takingReturNotifier.notifier)
                            .takingRetur(id, quantity: _quantityCtrl.text)
                            .then((value) async {
                          if (value) {
                            await ref
                                .watch(returAcceptNotifier.notifier)
                                .getRetur();
                            await ref
                                .watch(returFinishNotifier.notifier)
                                .getRetur();
                            if (!mounted) return;
                            showSnackbar(
                                context, "Berhasil ambil produk retur");
                            log(quantity);
                            if (quantity != retur!.notYetTaken!) {
                              log("Reload");
                              Retur returData = isShowSearch
                                  ? searchData[index]
                                  : ref.watch(returAcceptNotifier).data![index];
                              ref.watch(returProvider.notifier).state =
                                  returData;
                            }
                            _quantityCtrl.clear();
                          } else {
                            showSnackbar(context, "Gagal ambil produk retur",
                                isWarning: true);
                          }
                        });
                      }
                    },
                    child: const Text("Simpan"),
                  )
                ],
              ),
            ));
  }

  _handleRejectRetur(Retur retur) {
    _descriptionCtrl.clear();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              // insetPadding: EdgeInsets.symmetric(horizontal: 50),
              actionsPadding: const EdgeInsets.only(right: 25, bottom: 20),
              title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Text("Pesan Penolakan Retur")),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _descriptionCtrl,
                  minLines: 5,
                  maxLines: null,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref
                          .watch(rejectReturNotifier.notifier)
                          .rejectRetur(retur.id!,
                              messageReject: _descriptionCtrl.text)
                          .then((value) {
                        if (value) {
                          ref.invalidate(returProvider);
                          ref.invalidate(indexProvider);
                          ref.invalidate(selectedIndexProvider);
                          ref.watch(returProcessNotifier.notifier).getRetur();
                          ref.watch(returRejectNotifier.notifier).getRetur();
                          showSnackbar(
                              context, "Berhasil menolak pengajuan retur");
                        } else {
                          showSnackbar(context, "Gagal Menolak pengajuan retur",
                              isWarning: true);
                        }
                      });
                    },
                    child: const Text("Kirim")),
              ],
            ));
  }

  _handleAcceptRetur(Retur retur) {
    PanaraConfirmDialog.show(
      context,
      message: "Lanjutkan terima pengajuan retur?",
      confirmButtonText: "Terima",
      cancelButtonText: "Kembali",
      onTapConfirm: () {
        Navigator.pop(context);
        ref
            .watch(createAcceptReturNotifier.notifier)
            .createAcceptRetur(retur.id!)
            .then((value) {
          if (value) {
            ref.invalidate(returProvider);
            ref.invalidate(indexProvider);
            ref.invalidate(selectedIndexProvider);
            ref.watch(returProcessNotifier.notifier).getRetur();
            ref.watch(returAcceptNotifier.notifier).getRetur();
            showSnackbar(context, "Berhasil menerima pengajuan retur");
          } else {
            showSnackbar(context, "Gagal menerima pengajuan retur",
                isWarning: true);
          }
        });
      },
      onTapCancel: Navigator.of(context).pop,
      panaraDialogType: PanaraDialogType.warning,
    );
  }
}

final returProvider = StateProvider<Retur?>((ref) => null);
final selectedIndexProvider = StateProvider<int>((ref) => 0);
final indexProvider = StateProvider<int>((ref) => 0);
final isShowSearchProvider = StateProvider<bool>((ref) => false);

final searchNotifier =
    StateNotifierProvider<SearchDataNotifier, List<Retur>>((ref) {
  return SearchDataNotifier();
});

class SearchDataNotifier extends StateNotifier<List<Retur>> {
  SearchDataNotifier() : super([]);

  searchByQuery(List<Retur> data, {required String query}) {
    List<Retur> temp = [];
    if (query.isNotEmpty) {
      for (Retur retur in data) {
        if (retur.returNumber!.toLowerCase().contains(query.toLowerCase())) {
          temp.add(retur);
        }
      }
    } else {
      temp = data;
    }
    state = temp;
  }
}
