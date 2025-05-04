import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final Widget? suffixLabel;
  final String? hint;
  final bool obscureText;
  final bool multiLines;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final InputBorder? customBorder;
  final InputBorder? customFocusedBorder;
  final bool? enable;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextField({
    super.key,
    this.label,
    this.suffixLabel,
    this.hint,
    this.obscureText = false,
    this.multiLines = false,
    this.suffixIcon,
    this.controller,
    this.customBorder,
    this.customFocusedBorder,
    this.enable,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          enabled: enable,
          controller: controller,
          style: appFonts.caption.ts,
          obscureText: obscureText,
          maxLines: multiLines ? 3 : 1,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: appColors.white,
            label: label != null
                ? Text(
                    label!,
                    style: appFonts.primary.ts,
                  )
                : null,
            labelStyle: appFonts.primary.ts,
            hintText: label,
            hintStyle: appFonts.caption.primary.ts,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 22,
            ),
            border: customBorder ?? border,
            enabledBorder: customBorder ?? border,
            focusedBorder: customFocusedBorder ?? focusedBorder,
            errorBorder: errorBorder,
            suffixIcon: suffixIcon,
            errorStyle: appFonts.caption.error.ts,
          ),
        ),
      ],
    );
  }

  InputBorder get border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(multiLines ? 10 : 10),
      borderSide: BorderSide(color: appColors.primary),
    );
  }

  InputBorder get focusedBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(multiLines ? 10 : 10),
      borderSide: BorderSide(color: appColors.info),
    );
  }

  InputBorder get errorBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(multiLines ? 10 : 10),
      borderSide: BorderSide(color: appColors.error),
    );
  }
}
