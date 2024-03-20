import 'package:admin_hanaang/config/constant/role_id.dart';
import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/manage_access_warehouse/provider/manage_accces_provider.dart';
import 'package:admin_hanaang/models/manage_access.dart';
import 'package:admin_hanaang/views/components/dialog_loading.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/card_admin_access.dart';

part 'main screen/access_admin_screen.dart';
part "detail_manage_access/detail_manage_access_screen.dart";