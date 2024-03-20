part of "../access_admin.dart";

class AccessAdminScreen extends StatelessWidget {
  const AccessAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Akses Admin Gudang"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CardAdminAccess(
              title: "Gudang RCI",
              icon: Icons.other_houses,
              onTap: ()=> nextPage(context, "${AppRoutes.sa}/access-admin/detail", argument: {
                "manage_access_id" : RoleAdmin.adminGudang.value,
                "name" : "Gudang RCI",
              }),
            ),
            CardAdminAccess(
              title: "Gudang Cipanas",
              icon: Icons.house_siding_rounded,
              onTap: ()=> nextPage(context, "${AppRoutes.sa}/access-admin/detail", argument: {
                "manage_access_id" : RoleAdmin.adminGudang2.value,
                "name" : "Gudang Cipanas",
              }),
            ),
            CardAdminAccess(
              title: "Gudang PSH",
              icon: Icons.warehouse,
              onTap: ()=> nextPage(context, "${AppRoutes.sa}/access-admin/detail", argument: {
                "manage_access_id" : RoleAdmin.adminGudang3.value,
                "name" : "Gudang PSH",
              }),
            )
          ],
        ),
      ),
    );
  }
}

