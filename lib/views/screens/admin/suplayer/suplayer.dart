import 'dart:io';

import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/address/provider/address_provider.dart';
import 'package:admin_hanaang/features/image_picker/image_picker.dart';
import 'package:admin_hanaang/features/suplayer/provider/suplayer_provider.dart';
import 'package:admin_hanaang/models/suplayer.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/dropdown_container.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/modal_bottom_image_picker_option.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:admin_hanaang/views/screens/admin/suplayer/components/dialog_delete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../components/container_address.dart';
import '../../../components/error_button_widget.dart';
import '../components/endrawer/endrawer_widget.dart';



part 'main_suplayer/suplayer_screen.dart';
part 'main_suplayer/data_table_suplayer.dart';
part 'main_suplayer/header_suplayer.dart';
part 'detail_suplayer/detail_suplayer_screen.dart';
part "form_suplayer/form_suplayer_screen.dart";