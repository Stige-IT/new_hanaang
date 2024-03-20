
import 'package:admin_hanaang/features/material/provider/material_provider.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_provider.dart';
import 'package:admin_hanaang/models/material_detail.dart';
import 'package:admin_hanaang/models/material_model.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/utils/extensions/currency_format.dart';
import 'package:admin_hanaang/utils/helper/formatted_currency.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../config/router/router_config.dart';
import '../../../../config/theme.dart';
import '../../../../features/unit/provider/unit_provider.dart';
import '../../../../models/unit.dart';
import '../../../components/dropdown_container.dart';
import '../../../components/form_input.dart';
import '../../../components/loading_in_button.dart';
import '../../../components/navigation_widget.dart';
import '../../../components/snackbar.dart';

part 'main_material/material_screen.dart';
part "main_material/header_material.dart";
part "main_material/data_table_material.dart";
part 'detail_material/detail_material_screen.dart';
part "detail_material/components/card_total_stock.dart";
part "form_material/form_material_screen.dart";