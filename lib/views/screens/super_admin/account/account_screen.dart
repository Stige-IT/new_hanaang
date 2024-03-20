import 'dart:async';
import 'dart:developer';

import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/auth/provider/auth_provider.dart';
import 'package:admin_hanaang/features/bluethermal_printer/providers/bluethermal_printer_provider.dart';
import 'package:admin_hanaang/features/user/provider/user_provider.dart';
import 'package:admin_hanaang/utils/helper/bluethermal_printer/bluethermal_printer_instance.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:admin_hanaang/views/screens/super_admin/account/edit_profile_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/main.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../models/user.dart';
import '../../../components/tile.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late StreamSubscription<fb.BluetoothAdapterState> subscription;

  @override
  void initState() {
    Future.microtask(
        () => ref.read(userNotifierProvider.notifier).getProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(userNotifierProvider).data;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(userNotifierProvider.notifier).getProfile();
          });
        },
        child: CustomScrollView(slivers: [
          const AppBarSliver(),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                title: Text(
                  user?.name ?? "No Name",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  children: [
                    Text(user?.email ?? "example@gmail.com"),
                    Text(user?.phoneNumber ?? "+62xxxxxxxxxx"),
                  ],
                ),
              ),
            ),
            Tile(
                title: "Profil",
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EditProfileScreen(
                      user: user,
                    );
                  }));
                }),
            Tile(
                title: "Password",
                onTap: () {
                  nextPage(context, "${AppRoutes.sa}/password");
                }),
            Tile(
                title: "Alamat",
                onTap: () {
                  nextPage(context, "${AppRoutes.sa}/address");
                }),
            Tile(
                title: "Hubungkan Printer",
                onTap: () {
                  subscription =
                      fb.FlutterBluePlus.adapterState.listen((state) {
                    log(state.toString(), name: 'Bluetooth State');
                    if (state == fb.BluetoothAdapterState.on) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          subscription.cancel();
                          return const DialogBluetoothWidget();
                        },
                      );
                    } else if (state == fb.BluetoothAdapterState.off) {
                      PanaraConfirmDialog.show(
                        context,
                        message:
                            "Bluetooth tidak aktif, aktifkan bluetooth terlebih dahulu",
                        panaraDialogType: PanaraDialogType.error,
                        confirmButtonText: 'OK',
                        onTapConfirm: () {
                          Navigator.of(context).pop();
                          // enable bluetooth with flutter blue plus
                          fb.FlutterBluePlus.turnOn();
                          subscription.cancel();
                        },
                        cancelButtonText: 'Kembali',
                        onTapCancel: Navigator.of(context).pop,
                      );
                    }
                  });
                }),
            const SizedBox(height: 20),
            Tile(
                title: "Logout",
                onTap: () async {
                  PanaraConfirmDialog.show(
                    context,
                    message: "Apakah anda yakin keluar dari akun ini ?",
                    panaraDialogType: PanaraDialogType.error,
                    cancelButtonText: 'Kembali',
                    confirmButtonText: 'Keluar',
                    onTapCancel: () => Navigator.pop(context),
                    onTapConfirm: () async {
                      nextPageRemoveAll(context, "/login");
                      FirebaseMessaging fcmMessage = FirebaseMessaging.instance;
                      await fcmMessage.unsubscribeFromTopic('super-admin');
                      ref.watch(authNotifier.notifier).logout();

                      Future.delayed(const Duration(seconds: 1), () {
                        ref.watch(navProvider.notifier).changeNavigation(0);
                      });
                    },
                  );
                }),
          ]))
        ]),
      ),
    );
  }
}

class DialogBluetoothWidget extends ConsumerStatefulWidget {
  const DialogBluetoothWidget({super.key});

  @override
  ConsumerState createState() => _DialogBluetoothWidgetState();
}

class _DialogBluetoothWidgetState extends ConsumerState<DialogBluetoothWidget> {
  @override
  void initState() {
    Future.microtask(
      () async {
        final isConnected = await ref.watch(bluethermalProvider).isConnected;
        ref.read(bluerthermalNotifier.notifier).getPairedDevices();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(bluethermalProvider).isConnected;
    final devices = ref.watch(bluerthermalNotifier);
    final selectedBluetooth = ref.watch(bluetoothSelectedProvider);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Hubungkan Printer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: isConnected,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return DropdownContainer<BluetoothDevice>(
                      value: selectedBluetooth,
                      items: devices
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name ?? "-"),
                            ),
                          )
                          .toList(),
                      onChanged: (bluetooth) {
                        ref.read(bluetoothSelectedProvider.notifier).state =
                            bluetooth;
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedBluetooth != null) {
                    Navigator.of(context).pop();
                    ref.read(bluethermalProvider).connect(selectedBluetooth);
                    showSnackbar(context, "Bluetooth Berhasil terhubung");
                  }
                },
                child: const Text("Hubungkan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
