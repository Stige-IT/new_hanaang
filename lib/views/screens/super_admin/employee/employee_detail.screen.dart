import 'package:admin_hanaang/features/employee/provider/employee_provider.dart';
import 'package:admin_hanaang/models/employee.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../utils/constant/base_url.dart';
import '../../../components/container_address.dart';
import '../../../components/label.dart';
import '../../../components/profile_with_name.dart';

class EmployeeDetailScreen extends ConsumerStatefulWidget {
  final Employee employee;

  const EmployeeDetailScreen(this.employee, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends ConsumerState<EmployeeDetailScreen> {
  @override
  void initState() {
    Future.microtask(() =>
        ref.watch(employeeNotifier.notifier).getEmployee(widget.employee));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeNotifier);
    final employee = state.data?[0];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AppBarSliver(title: "Detail Karyawan"),
          SliverList(
              delegate: SliverChildListDelegate([
            state.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : employee == null
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Data tidak ditemkan"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    if (employee.image != null)
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            "$BASE/${employee.image}"),
                                      )
                                    else
                                      ProfileWithName(
                                        employee.name ?? " ",
                                        radius: 30,
                                      ),
                                    if (employee.position != null)
                                      SizedBox(
                                        width: 100,
                                        child: Label(
                                          status: "partial",
                                          title: employee.position?.name ?? "",
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employee.name ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      employee.phoneNumber ?? "No.Telp: -",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "Besar Gaji",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    0.convertToIdr(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Alamat",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const Divider(thickness: 2),
                            const ContainerAddress(
                              label: "Provinsi",
                              value: "-",
                            ),
                            const ContainerAddress(
                              label: "Kabupaten",
                              value: "-",
                            ),
                            const ContainerAddress(
                              label: "Kecamatan",
                              value: "-",
                            ),
                            const ContainerAddress(
                              label: "Kelurahan",
                              value: "-",
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Detail Alamat",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const Divider(thickness: 2),
                            const ContainerAddress(
                              isMultiLine: true,
                              value: "-",
                            )
                          ],
                        ),
                      )
          ]))
        ],
      ),
    );
  }
}
