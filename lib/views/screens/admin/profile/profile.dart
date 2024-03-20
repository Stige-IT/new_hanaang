
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../features/address/provider/address_provider.dart';
import '../../../../features/image_picker/image_picker.dart';
import '../../../../features/password/provider/password_notifer.dart';
import '../../../../features/password/provider/password_provider.dart';
import '../../../../features/user/provider/user_provider.dart';
import '../../../components/dropdown_container.dart';
import '../../../components/form_input.dart';

import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';

import '../../../components/snackbar.dart';
import '../components/dialog_logout.dart';



part 'setting_account/setting_form_data_password.dart';
part 'setting_account/setting_account_screen.dart';
part 'setting_account/setting_form_data_user.dart';
part 'setting_account/setting_form_data_address.dart';
part 'profile_screen.dart';