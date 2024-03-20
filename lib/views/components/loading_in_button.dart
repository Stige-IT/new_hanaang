import 'package:flutter/material.dart';

class LoadingInButton extends StatelessWidget {
  final Color? color;

  const LoadingInButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(color: color ?? Colors.white),
    );
  }
}

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingInButton(color: Theme.of(context).colorScheme.primary),
    );
  }
}
