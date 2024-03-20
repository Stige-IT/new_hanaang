import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

extension DialogImagePreview on BuildContext {
  void showDialogImagePreview(String imageUrl) {
    showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 300.0,
            width: 300.0,
            child: PhotoView(
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        );
      },
    );
  }
}
