import 'package:admin_hanaang/config/theme.dart';
import 'package:flutter/material.dart';

class FormfieldBank extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType? type;
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  const FormfieldBank({
    super.key,
    required this.title,
    required this.controller,
    this.type,
    this.prefix,
    this.hint,
    this.onChanged,
    this.onTap, this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: TextFormField(
        controller: controller,
        keyboardType: type ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefix: prefix,
          suffix: suffix,
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:  BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:  BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
        borderSide:  BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Harap isi terlebih dahulu";
          }
          return null;
        },
        onTap: onTap ?? () {},
        onChanged: onChanged ?? (value) {},
      ),
    );
  }
}
