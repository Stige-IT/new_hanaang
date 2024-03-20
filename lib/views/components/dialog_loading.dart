import 'package:flutter/material.dart';

class DialogLoading extends StatelessWidget {
  const DialogLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.2),
      child: const Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
