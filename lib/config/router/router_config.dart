import 'package:admin_hanaang/models/bank_account.dart';
import 'package:admin_hanaang/models/employee.dart';
import 'package:admin_hanaang/models/material_model.dart';
import 'package:admin_hanaang/models/order.dart';
import 'package:admin_hanaang/models/order_detail.dart';
import 'package:admin_hanaang/models/pre_order_user.dart';
import 'package:admin_hanaang/models/retur.dart';
import 'package:admin_hanaang/models/suplayer.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/order/detail_history_order.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/order/form_order_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/pre_order/pre_order_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/pre_order/setting_pre_order/setting_pre_order.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/retur/retur_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/shopping/form_shopping_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/shopping/shopping_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/users_hanaang/detail_user_hanaang_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/users_hanaang/form_user_hanaang_screen.dart';
import 'package:admin_hanaang/views/screens/admin/admin_order/users_hanaang/user_hanaang_screen.dart';
import 'package:admin_hanaang/views/screens/admin/main_admin.dart';
import 'package:admin_hanaang/views/screens/admin/material/material.dart';
import 'package:admin_hanaang/views/screens/admin/penerimaan_barang/penerimaan_barang.dart';
import 'package:admin_hanaang/views/screens/admin/units/unit.dart';
import 'package:admin_hanaang/views/screens/not_support_view/not_support_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/account/edit_address_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/account/edit_password.dart';
import 'package:admin_hanaang/views/screens/super_admin/account/edit_profile_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/employee/employee_detail.screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/employee/employee_list_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/employee/form_employee_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/employee/position_screen.dart';
import 'package:admin_hanaang/features/bank-account/ui/detail/detail_bank_account_screen.dart';
import 'package:admin_hanaang/features/bank-account/ui/history/bank_history_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/home/history_income_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/main.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/detail_hutang.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/detail_payment_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/order/detail_order_transaction_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/retur/detail_retur_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/detail_taking_order_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/hutang_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/order/order_list_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/retur/retur_search_screen.dart';

import 'package:admin_hanaang/views/screens/super_admin/users/detail_admin_hanaang_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/users/detail_market_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/users/users_hanaang_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/access-admin/access_admin.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/detail_material_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/detail_penerimaan_barang_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/detail_suplayer_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/form_material_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/form_penerimaan_barang_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/form_suplayer_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/order/retur/retur_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/menu_material_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/suplayer_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/users/admin_hanaang_screen.dart';
import 'package:admin_hanaang/views/screens/super_admin/warehouse/units_screen.dart';
import 'package:flutter/material.dart';

import '../../features/bank-account/bank_account.dart';
import '../../features/bonus/bonus.dart';
import '../../features/cashback/cashback.dart';
import '../../features/price_product/price_product.dart';
import '../../features/shift/shift.dart';
import '../../views/screens/admin/admin_order/main_order_screen.dart';
import '../../views/screens/admin/admin_order/order/detail_order_screen.dart';
import '../../views/screens/admin/admin_order/pre_order/form_preorder_screen.dart';
import '../../views/screens/admin/profile/profile.dart';
import '../../views/screens/admin/resep/resep.dart';
import '../../views/screens/admin/suplayer/suplayer.dart';
import '../../views/screens/auth/login.dart';
import '../../views/screens/splash/splash.dart';
import '../../views/screens/super_admin/order/order.dart';
import '../../views/screens/super_admin/order/order/form_order_screen.dart';
import '../../views/screens/super_admin/order/pre order/pre_order.dart';
import '../../views/screens/super_admin/users/form_create_admin_hanaang_screen.dart';
import '../../views/screens/super_admin/users/markets_screen.dart';
import '../../views/screens/super_admin/warehouse/material_screen.dart';
import '../../views/screens/super_admin/warehouse/penerimaan_barang_screen.dart';
import '../../views/screens/super_admin/warehouse/reciep/reciep.dart';

class AppRoutes {
  static const sa = "/sa"; // sa alias Super Admin
  static const admin = "/admin"; // ao alias Admin
  static const ag = "/ag"; // ag alis Admin Gudang
  static Map<String, Widget Function(BuildContext)> routes = {
    "/splash": (_) => const SplashScreen(),
    "/login": (_) => const LoginScreen(),
    "/not-support": (_) => const NotSupportView(),

    ///[SUPER ADMIN]
    ///MAIN FEATURE
    "$sa/main": (_) => const MainScreen(),

    ///HOME FEATURES
    "$sa/finance": (_) {
      final BankAccount? account =
          ModalRoute.of(_)!.settings.arguments as BankAccount?;
      return DetailBankAccountScreen(account!);
    },
    "$sa/finance/bank": (_) => const BankAccountScreen(),
    "$sa/finance/bank/history": (context) {
      final bankAccountId =
          ModalRoute.of(context)?.settings.arguments as String;
      return HistoryIncomeScreen(bankAccountId);
    },
    "$sa/finance/bank/history/detail": (context) {
      final data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      return DetailBankHistoryScreen(data['bankHistoryId'], data['is_income']);
    },

    ///ORDER FEATURES
    "$sa/setting-bonus": (_) => const SettingBonusScreen(),
    "$sa/setting-cashback": (_) => const SettingCashbackScreen(),
    "$sa/setting-harga": (_) => const SettingHargaProdukScreen(),
    "$sa/pre-order-list": (_) => const PreOrderUsersScreen(),
    "$sa/pre-order-list/detail": (_) {
      final PreOrderUser data =
          ModalRoute.of(_)!.settings.arguments as PreOrderUser;
      return FormPreOrderScreen(data);
    },
    "$sa/order-list": (_) => const OrderListScreen(),
    "$sa/order-list/detail": (_) {
      final String data = ModalRoute.of(_)!.settings.arguments as String;
      return DetailOrderScreen(data);
    },
    "$sa/order/transaction": (context) {
      final orderId = ModalRoute.of(context)!.settings.arguments as String;
      return DetailOrderTransactionScreen(orderId);
    },
    "$sa/order/form": (context) {
      final userHanaang = ModalRoute.of(context)?.settings.arguments;
      if (userHanaang != null) {
        return FormOrderScreen(usersHanaang: userHanaang as UsersHanaang);
      }
      return const FormOrderScreen();
    },
    "$sa/payment-detail": (_) {
      final OrderDetailData data =
          ModalRoute.of(_)!.settings.arguments as OrderDetailData;
      return DetailPaymentScreen(data);
    },
    "$sa/taking-order-detail": (_) {
      final OrderDetailData data =
          ModalRoute.of(_)!.settings.arguments as OrderDetailData;
      return DetailTakingOrderScreen(data);
    },
    "$sa/retur": (_) => const ReturScreen(),
    "$sa/retur/search": (_) => const ReturSearchScreen(),
    "$sa/retur/detail": (context) {
      Retur data = ModalRoute.of(context)?.settings.arguments as Retur;
      return DetailReturScreen(data);
    },
    "$sa/hutang": (_) => const HutangScreen(),
    "$sa/hutang/detail": (context) {
      String hutangId = ModalRoute.of(context)?.settings.arguments as String;
      return DetailHutangScreen(hutangId);
    },

    ///WAREHOUSE FEATURE
    "$sa/suplayer": (_) => const SuplayerScreen(),
    "$sa/suplayer/detail": (_) {
      final Suplayer suplayer =
          ModalRoute.of(_)?.settings.arguments as Suplayer;
      return DetailSuplayerScreen(suplayer);
    },
    "$sa/suplayer/form": (context) {
      final suplayer = ModalRoute.of(context)?.settings.arguments;
      if (suplayer != null) {
        return FormSuplayerScreen(suplayer: suplayer as Suplayer);
      }
      return const FormSuplayerScreen();
    },
    "$sa/menu-material": (_) => const MenuMaterialScreen(),
    "$sa/materials": (_) => const MaterialScreen(),
    "$sa/material/create": (_) => const FormMaterialScreen(),
    "$sa/material/detail": (context) {
      String materialId = ModalRoute.of(context)?.settings.arguments as String;
      return DetailMaterialScreen(materialId);
    },
    "$sa/units": (_) => const UnitsScreen(),
    "$sa/penerimaan-barang": (_) => const PenerimaanBarangScreen(),
    "$sa/penerimaan-barang/detail": (context) {
      String id = ModalRoute.of(context)?.settings.arguments as String;
      return DetailPenerimaanBarangScreen(id);
    },
    "$sa/penerimaan-barang/form": (_) => const FormPenerimaanBarang(),
    "$sa/recipt": (_) => const ReciptScreen(),
    "$sa/recipt/detail": (context) {
      final reciptId = ModalRoute.of(context)?.settings.arguments as String;
      return DetailReciptScreen(reciptId);
    },
    "$sa/recipt/create": (_) => const FormReciptScreen(),
    "$sa/access-admin": (_) => const AccessAdminScreen(),
    "$sa/access-admin/detail": (context) {
      final argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return DetailManageAccessScreen(argument['manage_access_id']!,
          name: argument['name']!);
    },

    ///USERS FEATURE
    "$sa/users": (context) {
      final String title = ModalRoute.of(context)?.settings.arguments as String;
      return UsersHanaangScreen(title: title);
    },
    "$sa/markets": (context) {
      final userId = ModalRoute.of(context)?.settings.arguments;
      if (userId != null) {
        return MarketsScreen(userId: userId as String);
      }
      return const MarketsScreen();
    },
    "$sa/markets/detail": (context) {
      final String marketId =
          ModalRoute.of(context)?.settings.arguments as String;
      return DetailMarketScreen(marketId);
    },
    "$sa/admin-hanaang": (_) => const AdminHanaangScreen(),
    "$sa/admin-hanaang/detail": (context) {
      String adminHanaangId =
          ModalRoute.of(context)?.settings.arguments as String;
      return DetailAdminHanaangScreen(adminHanaangId);
    },
    "$sa/admin-hanaang/create": (_) => const FormAdminHanaangScreen(),

    ///EMPLOYEES FEATURE
    "$sa/employee/list": (_) => const EmployeeListScreen(),
    "$sa/employee/detail": (_) {
      final Employee employee =
          ModalRoute.of(_)!.settings.arguments as Employee;
      return EmployeeDetailScreen(employee);
    },
    "$sa/employee/form": (_) {
      final employee = ModalRoute.of(_)?.settings.arguments;
      if (employee == null) {
        return const FormCreateEmployeeScreen();
      }
      return FormCreateEmployeeScreen(employee: employee as Employee);
    },
    "/positions": (_) => const PositionScreen(),

    ///ACCOUNT FEATURES
    "$sa/password": (_) => const EditPasswordScreen(),
    "$sa/address": (_) => const EditAddressScreen(),
    "$sa/profile": (_) => const EditProfileScreen(),

    /*
    SCREEN ALL ADMIN
    */

    /// SHIFT
    "$admin/shift": (_) => const ShiftScreen(),

    ///MAIN
    admin: (_) => const MainAdmin(),

    ///PROFILE
    "$admin/profile": (_) => const ProfileScreen(),
    "$admin/profile/setting": (_) => const SettingAccountScreen(),

    ///ORDER
    "$admin/order": (_) => const OrderScreenAdmin(),
    "$admin/order/detail": (_) {
      OrderData orderData = ModalRoute.of(_)!.settings.arguments as OrderData;
      return DetailOrderScreenAdmin(orderData);
    },
    "$admin/order/form": (context) {
      final usersHanaang = ModalRoute.of(context)?.settings.arguments;
      if (usersHanaang != null) {
        return FormOrderScreenAO(usersHanaang: usersHanaang as UsersHanaang);
      }
      return const FormOrderScreenAO();
    },
    "$admin/order/history": (_) {
      List<dynamic> arguments = ModalRoute.of(_)!.settings.arguments as List;
      bool isHistoryPayment = arguments[0] as bool;
      OrderDetailData orderData = arguments[1] as OrderDetailData;
      return DetailHistoryOrderScreenAO(isHistoryPayment, orderData);
    },

    ///PRE ORDER SCREEN
    "$admin/setting-pre-order": (_) => const SettingPreOrderScreenAO(),
    "$admin/pre-order": (_) => const PreOrderScreenAO(),
    "$admin/pre-order-list/detail": (_) {
      final PreOrderUser data =
          ModalRoute.of(_)!.settings.arguments as PreOrderUser;
      return FormPreOrderScreenAO(data);
    },

    ///Suplayer
    "$admin/suplayer": (_) => const SuplayerScreenAdmin(),
    "$admin/suplayer/detail": (context) {
      final suplayerId = ModalRoute.of(context)?.settings.arguments as String;
      return DetailSuplayerScreenAdmin(suplayerId);
    },
    "$admin/suplayer/form": (context) {
      final suplayer = ModalRoute.of(context)?.settings.arguments;
      if (suplayer != null) {
        return FormSuplayerScreenAdmin(suplayer: suplayer as Suplayer);
      }
      return const FormSuplayerScreenAdmin();
    },

    ///MATERIAL
    "$admin/material": (_) => const MaterialScreenAdmin(),
    "$admin/material/detail": (context) {
      final materialId = ModalRoute.of(context)!.settings.arguments as String;
      return DetailMaterialScreenAdmin(materialId);
    },
    "$admin/material/form": (context) {
      final material = ModalRoute.of(context)!.settings.arguments;
      if (material != null) {
        return FormMaterialScreenAdmin(
          material: material as MaterialModel,
        );
      }
      return const FormMaterialScreenAdmin();
    },

    ///UNIT
    "$admin/units": (_) => const UnitsScreenAdmin(),

    ///PENERIMAAN BARANG
    "$admin/penerimaan-barang": (_) => const PenerimaanBarangScreenAdmin(),
    "$admin/penerimaan-barang/form": (_) =>
        const FormPenerimaanBarangScreenAdmin(),
    "$admin/penerimaan-barang/detail": (context) {
      final id = ModalRoute.of(context)!.settings.arguments as String;
      return DetailPenerimaanBarangScreenAdmin(id);
    },

    ///RESEP
    "$admin/recipt": (_) => const ResepScreenAdmin(),

    ///RETUR
    "$admin/retur": (_) => const ReturScreenAO(),

    ///SHOPPING
    "$admin/shopping": (_) => const ShoppingScreenAo(),
    "$admin/shopping/form": (_) => const FormShoppingScreenAO(),

    ///USER HANAANG
    "$admin/user-hanaang": (_) => const UserHanaangScreenAO(),
    "$admin/user-hanaang/form": (_) => const FormUserHanaangScreenAo(),
    "$admin/user-hanaang/detail": (context) {
      final userId = ModalRoute.of(context)?.settings.arguments as String;
      return DetailUserScreenAO(userId);
    },
  };
}
