

import '../../models/user_hanaang_detail.dart';

String? formatAddresstoDetail(Address? address){
  if(address == null){
    return "Alamat: -";
  }
  return "${address.detail} ${address.village} ${address.district} ${address.regency} ${address.province}";
}