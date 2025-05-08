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
            label:
                label != null
                    ? Text(
                      label!,
                      style: appFonts.ts.copyWith(
                        // color:
                        //     Theme.of(context).brightness == Brightness.light
                        //         ? appColors.primary
                        //         : appColors.black,
                      ),
                    )
                    : null,
            // labelStyle: appFonts.ts.copyWith(
            //   color:
            //       Theme.of(context).brightness == Brightness.light
            //           ? appColors.primary
            //           : appColors.black,
            // ),
            hintText: label,
            // hintStyle: appFonts.caption.ts.copyWith(
            //   color:
            //       Theme.of(context).brightness == Brightness.light
            //           ? appColors.placeholder
            //           : appColors.black,
            // ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 22,
            ),
            border: customBorder ?? border(context),
            enabledBorder: customBorder ?? border(context),
            focusedBorder: customFocusedBorder ?? focusedBorder(context),
            errorBorder: errorBorder(context),
            suffixIcon: suffixIcon,
            errorStyle: appFonts.caption.error.ts,
          ),
        ),
      ],
    );
  }

  InputBorder border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(multiLines ? 10 : 10),
      borderSide: BorderSide(
        color:
            Theme.of(context).brightness == Brightness.light
                ? appColors.primary
                : Colors.white,
      ),
    );
  }

  InputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(multiLines ? 10 : 10),
      borderSide: BorderSide(
        color:
            Theme.of(context).brightness == Brightness.light
                ? appColors.info
                : Colors.white,
      ),
    );
  }

  InputBorder errorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(multiLines ? 10 : 10),
      borderSide: BorderSide(
        color:
            Theme.of(context).brightness == Brightness.light
                ? appColors.error
                : appColors.error.surface,
      ),
    );
  }
}
