import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, File>((ref) {
  return ImagePickerNotifier();
});

class ImagePickerNotifier extends StateNotifier<File> {
  ImagePickerNotifier() : super(File(""));

  getFromGallery({ImageSource? source}) async {
    source ??= ImageSource.gallery;
    XFile? pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      state = imageFile;
      return imageFile;
    }
  }
}
