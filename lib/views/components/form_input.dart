import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final double _radius = 50.r;


class FieldInput extends StatelessWidget {
  final String? title;
  final TextAlign? textAlign;
  final String? hintText;
  final Icon? prefixIcons;
  final TextEditingController controller;
  final String? textValidator;
  final TextInputType? keyboardType;
  final bool? obsecureText;
  final IconButton? suffixIcon;
  final bool? enable;
  final bool? isRounded;
  final String? prefixText;
  final String? suffixText;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;

  const FieldInput({
    super.key,
    this.title,
    this.hintText,
    this.prefixIcons,
    required this.controller,
    this.textValidator,
    this.keyboardType = TextInputType.text,
    this.obsecureText = false,
    this.suffixIcon,
    this.enable,
    this.prefixText,
    this.onChanged,
    this.onEditingComplete,
    this.isRounded,
    this.validator,
    this.suffixText,
    this.onTap,
    this.maxLines,
    this.textAlign,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 5),
            child: Text(
              title ?? "",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0.h),
          child: TextFormField(
            textAlign: textAlign ?? TextAlign.start,
            maxLength: maxLength,
            minLines: keyboardType == TextInputType.multiline ? null : 1,
            maxLines: maxLines ?? 1,
            obscureText: obsecureText!,
            style: Theme.of(context).textTheme.bodySmall,
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            validator: validator ??
                (String? value) {
                  if (value!.isEmpty || value == "0") {
                    return "Harap isi terlebih dahulu";
                  }
                  return null;
                },
            onSaved: (String? val) {
              controller.text = val!;
            },
            cursorColor: Theme.of(context).colorScheme.primary,
            decoration: InputDecoration(
              prefixText: prefixText,
              prefixStyle: Theme.of(context).textTheme.bodySmall,
              contentPadding: EdgeInsets.all(10.h),
              suffixIcon: suffixIcon,
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(
                  isRounded != null ? 5 : _radius,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(
                    isRounded != null ? 5 : _radius,
                  )),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                borderRadius: BorderRadius.circular(
                  isRounded != null ? 5 : _radius,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(
                    isRounded != null ? 5 : _radius,
                  )),
              hintText: hintText ?? "masukkan $title",
              hintStyle: Theme.of(context).textTheme.bodySmall,
              disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(
                    isRounded != null ? 5 : _radius,
                  )),
              enabled: enable ?? true,
              prefixIcon: prefixIcons,
              prefixIconColor: Colors.grey,
              suffixText: suffixText,
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
