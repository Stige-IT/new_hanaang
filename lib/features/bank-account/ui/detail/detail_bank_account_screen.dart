import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/bank-account/provider/bank_account_by_id/bank-account_provider.dart';
import 'package:admin_hanaang/models/bank_account.dart';
import 'package:admin_hanaang/models/bank_history.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../data/bank-account_api.dart';
import '../../provider/bank-account_provider.dart';
import '../../../../views/components/card_income.dart';

class DetailBankAccountScreen extends ConsumerStatefulWidget {
  final BankAccount account;

  const DetailBankAccountScreen(this.account, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailBankAccountScreenState();
}

class _DetailBankAccountScreenState
    extends ConsumerState<DetailBankAccountScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _saldoCtrl;
  late TextEditingController _transferSaldoCtrl;

  late TextEditingController _bankNameCtrl;
  late TextEditingController _accountNameCtrl;
  late TextEditingController _numberBankCtrl;
  late ScrollController _scrollController;

  @override
  void initState() {
    Future.microtask(() async {
      ref
          .watch(bankAccountByIdProvider.notifier)
          .getBankAccountsById(widget.account.id!, makeLoading: true);
      ref
          .read(bankHistoryNotifier.notifier)
          .getHistoy(bankAccountId: widget.account.id);
    });
    _saldoCtrl = TextEditingController();
    _transferSaldoCtrl = TextEditingController();

    _bankNameCtrl = TextEditingController();
    _accountNameCtrl = TextEditingController();
    _numberBankCtrl = TextEditingController();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (ref.watch(bankHistoryNotifier).page !=
            ref.watch(bankHistoryNotifier).lastPage) {
          ref.read(bankHistoryNotifier.notifier).getDataMore(
                bankAccountId: widget.account.id,
              );
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern("id_ID").format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bankAccountByIdProvider);
    final BankAccount? account = ref.watch(bankAccountByIdProvider).data;
    final stateHistory = ref.watch(bankHistoryNotifier);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(account == null ? "" : "Bank ${account.bankName}"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Text("Detail Akun Bank")),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.account_circle),
                                  title: const Text("Nama",
                                      style: TextStyle(fontSize: 12)),
                                  subtitle: Text(
                                    account?.accountName ?? "-",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                const Divider(thickness: 1),
                                ListTile(
                                  leading:
                                      const Icon(Icons.account_balance_wallet),
                                  title: const Text("Nama Bank",
                                      style: TextStyle(fontSize: 12)),
                                  subtitle: Text(
                                    account?.bankName ?? "-",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                const Divider(thickness: 1),
                                ListTile(
                                  leading: const Icon(Icons.numbers),
                                  title: const Text("No.Rekening",
                                      style: TextStyle(fontSize: 12)),
                                  subtitle: Text(
                                    account?.accountNumber ?? "-",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ),
                                const Divider(thickness: 1),
                                ListTile(
                                  leading: const Icon(Icons.money_rounded),
                                  title: const Text("Total Saldo",
                                      style: TextStyle(fontSize: 12)),
                                  subtitle: Text(
                                    int.parse(account?.ballance ?? "0")
                                        .convertToIdr(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ));
                },
                icon: const Icon(Icons.person)),
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      _editAccountBankdialog();
                      break;
                    case "toPrimary":
                      PanaraConfirmDialog.show(
                        context,
                        message: "Ubah akun bank ini ke primary ?",
                        confirmButtonText: "Ubah",
                        cancelButtonText: "Kembali",
                        onTapConfirm: () {
                          Navigator.of(context).pop();
                          ref
                              .read(updateBankToPrimaryNotifier.notifier)
                              .updateToPrimary(state.data!.id!)
                              .then((success) {
                            if (success) {
                              showSnackbar(
                                  context, "Berhasil mengubah menjadi primary");
                            } else {
                              final error =
                                  ref.watch(updateBankToPrimaryNotifier).error;
                              showSnackbar(context, error!, isWarning: true);
                            }
                          });
                        },
                        onTapCancel: Navigator.of(context).pop,
                        panaraDialogType: PanaraDialogType.warning,
                      );
                      break;
                    case "delete":
                      _handleConfirmDelete();
                      break;
                    default:
                  }
                },
                itemBuilder: (_) => [
                      const PopupMenuItem(value: "edit", child: Text("Edit")),
                      if (state.data!.primary == "0")
                        const PopupMenuItem(
                            value: "toPrimary", child: Text("Ubah ke Primary")),
                      const PopupMenuItem(
                          value: "delete", child: Text("Hapus")),
                    ]),
          ],
        ),
        body: Stack(
          children: [
            RefreshIndicator(onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                ref
                    .watch(bankAccountByIdProvider.notifier)
                    .getBankAccountsById(widget.account.id!, makeLoading: true);
                ref
                    .read(bankHistoryNotifier.notifier)
                    .getHistoy(bankAccountId: widget.account.id);
              });
            }, child: Builder(builder: (_) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber, size: 50),
                      Text(state.error!),
                    ],
                  ),
                );
              } else if (state.data == null) {
                return const Center(
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, size: 50),
                      Text("Data tidak ditemukan"),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            "assets/components/money.svg",
                            height: 95,
                          ),
                          if (account?.primary == "1")
                            const SizedBox(
                              width: 70,
                              child: Label(status: "done", title: "Primary"),
                            ),
                          const Text("Total Saldo"),
                          Text(int.parse(account!.ballance!).convertToIdr(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  _saldoCtrl.clear();
                                  _dialogAddSaldo();
                                },
                                label: const Text("Tambah"),
                                icon: const Icon(Icons.add),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  _transferSaldoCtrl.clear();
                                  _dialogTransferSaldo();
                                },
                                label: const Text("Transfer"),
                                icon: const Icon(Icons.money),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: const Text("Riwayat Pendapatan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        trailing: TextButton(
                          onPressed: () => nextPage(
                              context, "${AppRoutes.sa}/finance/bank/history",
                              argument: widget.account.id),
                          child: const Text(
                            "Lihat semua",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const Divider(thickness: 2),
                      Expanded(child: Builder(builder: (_) {
                        if (stateHistory.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (stateHistory.error != null) {
                          return Center(
                            child: Column(
                              children: [
                                const Icon(Icons.warning_amber, size: 50),
                                Text(stateHistory.error!),
                              ],
                            ),
                          );
                        } else if (stateHistory.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.money, size: 50),
                                  Text("Data tidak ada"),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 70.0),
                          itemBuilder: (_, i) {
                            if (!stateHistory.isLoadingMore &&
                                i == stateHistory.data!.length) {
                              return Center(
                                child: LoadingInButton(color: Theme.of(context).colorScheme.primary),
                              );
                            }
                            BankHistory history = stateHistory.data![i];
                            return CardIncome(
                              historyBankId: history.id!,
                              isIncome: history.category == "Pemasukan",
                              type: history.type!,
                              nominal: history.nominal!,
                              createdAt: history.createdAt!,
                            );
                          },
                          separatorBuilder: (_, i) => const SizedBox(height: 5),
                          itemCount: stateHistory.isLoadingMore
                              ? stateHistory.data!.length + 1
                              : stateHistory.data!.length,
                        );
                      }))
                    ],
                  ),
                );
              }
            })),
            if (ref.watch(updateBankAccountNotifier).isLoading ||
                ref.watch(transferBankAccountNotifier).isLoading)
              const DialogLoading()
          ],
        ));
  }

  void _editAccountBankdialog() {
    final account = ref.watch(bankAccountByIdProvider).data;
    _accountNameCtrl.text = account?.accountName ?? "-";
    _bankNameCtrl.text = account?.bankName ?? "-";
    _numberBankCtrl.text = account?.accountNumber ?? "-";
    _saldoCtrl.text = _formatNumber(account?.ballance ?? "0");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: const EdgeInsets.all(15.0),
        title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text("Data Akun bank")),
        content: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldInput(
                title: "Nama Akun",
                hintText: "Masukkan Nama Akun",
                controller: _accountNameCtrl,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: false,
              ),
              FieldInput(
                title: "Nama Bank",
                hintText: "Masukkan Nama",
                controller: _bankNameCtrl,
                textValidator: "",
                keyboardType: TextInputType.text,
                obsecureText: false,
              ),
              FieldInput(
                title: "Nomor Rekening Bank",
                hintText: "Masukkan nomor rekening",
                controller: _numberBankCtrl,
                textValidator: "",
                keyboardType: TextInputType.number,
                obsecureText: false,
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("Kembali")),
          FilledButton(
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                Navigator.of(context).pop();
                ref
                    .read(updateBankAccountNotifier.notifier)
                    .updateBankAccount(
                      BankAccount(
                        id: account!.id,
                        bankName: _bankNameCtrl.text,
                        accountName: _accountNameCtrl.text,
                        accountNumber: _numberBankCtrl.text,
                      ),
                    )
                    .then((success) {
                  if (success) {
                    showSnackbar(
                        context, "Berhasil memperbaharui data akun bank");
                  } else {
                    showSnackbar(
                      context,
                      ref.watch(updateBankAccountNotifier).error!,
                      isWarning: true,
                    );
                  }
                });
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  Future<dynamic> _handleConfirmDelete() {
    final account = ref.watch(bankAccountByIdProvider).data;
    return PanaraConfirmDialog.show(context,
        message: "Apakah Anda yakin  akan menghapus akun Bank ini..?",
        confirmButtonText: "Hapus",
        cancelButtonText: "Kembali",
        onTapConfirm: () {
          Navigator.pop(context);
          ref
              .watch(bankAccountProvider)
              .removeBankAccount(account!)
              .then((value) {
            if (value) {
              Navigator.pop(context);
              ref.watch(bankAccountNotifierProvider.notifier).getBankAccounts();
              showSnackbar(
                context,
                "Bank Account berhasil dihapus",
              );
            } else {
              showSnackbar(
                context,
                "Gagal dihapus, Bank Account adalah Primary",
                isWarning: true,
              );
            }
          });
        },
        onTapCancel: () => Navigator.pop(context),
        panaraDialogType: PanaraDialogType.error);
  }

  Future<dynamic> _dialogAddSaldo() {
    Size size = MediaQuery.of(context).size;
    final BankAccount? account = ref.watch(bankAccountByIdProvider).data;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: SizedBox(
                  width: size.width, child: const Text("Tambah Saldo")),
              content: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FieldInput(
                      prefixText: "Rp. ",
                      title: "Total Saldo",
                      hintText: "Masukkan total saldo",
                      controller: _saldoCtrl,
                      textValidator: "",
                      keyboardType: TextInputType.number,
                      obsecureText: false,
                      isRounded: false,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          value = _formatNumber(value.replaceAll('.', ''));
                          _saldoCtrl.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        }
                      },
                    ),
                    ListTile(
                      dense: true,
                      title: const Text("Saldo Anda :"),
                      subtitle: Text(
                          int.parse(account?.ballance ?? "0").convertToIdr(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.all(20.0),
              actions: [
                OutlinedButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text("Kembali")),
                FilledButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        Navigator.of(context).pop();
                        int ballanceTotal =
                            int.parse(_saldoCtrl.text.replaceAll('.', ''));
                        ref
                            .watch(addSaldoBankAccountNotifier.notifier)
                            .addSaldo(
                              widget.account.id!,
                              nominal: ballanceTotal,
                            )
                            .then((success) {
                          if (!success) {
                            showSnackbar(context,
                                ref.watch(updateBankAccountNotifier).error!,
                                isWarning: true);
                          }
                        });
                      }
                    },
                    child: const Text("Simpan"))
              ],
            ));
  }

  Future<dynamic> _dialogTransferSaldo() {
    String? bankReceiver;
    Size size = MediaQuery.of(context).size;
    List<BankAccount>? accounts = ref.watch(bankAccountNotifierProvider).data;
    final BankAccount? account = ref.watch(bankAccountByIdProvider).data;

    accounts = accounts?.where((bank) => bank.id != account?.id).toList();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, state) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: SizedBox(
                    width: size.width, child: const Text("Transfer Saldo")),
                content: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownContainer(
                          title: "Bank Tujuan",
                          value: bankReceiver,
                          items: accounts!
                              .map((e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(
                                      "${e.bankName}  ${e.accountNumber}")))
                              .toList(),
                          onChanged: (value) {
                            state(() {
                              bankReceiver = value;
                            });
                          }),
                      const SizedBox(height: 10),
                      FieldInput(
                        prefixText: "Rp. ",
                        title: "Total Saldo",
                        hintText: "Masukkan total saldo",
                        controller: _transferSaldoCtrl,
                        textValidator: "",
                        keyboardType: TextInputType.number,
                        obsecureText: false,
                        isRounded: false,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            value = _formatNumber(value.replaceAll('.', ''));
                            _transferSaldoCtrl.value = TextEditingValue(
                              text: value,
                              selection:
                                  TextSelection.collapsed(offset: value.length),
                            );
                          }
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: const Text("Saldo Anda :"),
                        subtitle: Text(
                            int.parse(account?.ballance ?? "0").convertToIdr(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ],
                  ),
                ),
                actionsPadding: const EdgeInsets.all(20.0),
                actions: [
                  OutlinedButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text("Kembali")),
                  FilledButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate() &&
                            bankReceiver != null) {
                          Navigator.pop(context);
                          ref
                              .watch(transferBankAccountNotifier.notifier)
                              .transferSaldo(widget.account.id!, bankReceiver!,
                                  nominal: int.parse(_transferSaldoCtrl.text
                                      .replaceAll('.', '')))
                              .then((success) {
                            if (!success) {
                              showSnackbar(context,
                                  ref.watch(transferBankAccountNotifier).error!,
                                  isWarning: true);
                            }
                          });
                        } else {
                          Navigator.of(context).pop();
                          showSnackbar(context, "Harap pilih bank tujuan",
                              isWarning: true);
                        }
                      },
                      child: const Text("Simpan"))
                ],
              );
            }));
  }
}
