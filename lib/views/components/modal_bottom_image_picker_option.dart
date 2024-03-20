import 'package:flutter/material.dart';

class ModalBottomOptionImagePicker extends StatelessWidget {
  final void Function()? onTapGalery;
  final void Function()? onTapCamera;
  const ModalBottomOptionImagePicker(
      {super.key, this.onTapGalery, this.onTapCamera});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: onTapGalery ?? () {},
          leading: const Icon(Icons.image),
          title: const Text("Galeri"),
        ),
        ListTile(
          onTap: onTapCamera ?? () {},
          leading: const Icon(Icons.camera_alt),
          title: const Text("Kamera"),
        ),
      ],
    );
  }
}
