import 'package:assesment_motio/core/formatter/date_formatter.dart';
import 'package:assesment_motio/core/themes/app_colors.dart';
import 'package:assesment_motio/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDateField extends StatefulWidget {
  final String? label;
  final String? hint;
  final InputBorder? customBorder;
  final InputBorder? customFocusedBorder;
  final bool? enable;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final Function(DateTime date) onDateSelected;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  const AppDateField({
    super.key,
    this.label,
    this.hint,
    this.customBorder,
    this.customFocusedBorder,
    this.enable,
    this.validator,
    this.initialDate,
    required this.onDateSelected,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _controller.text = DateFormatter.parseDisplayDate(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          readOnly: true,
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: widget.initialDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            ).then((value) {
              if (value != null) {
                setState(() {
                  _controller.text = DateFormatter.parseDisplayDate(value);
                });
                widget.onDateSelected(value);
              }
            });
          },
          enabled: widget.enable,
          controller: _controller,
          style: appFonts.caption.ts,
          validator: widget.validator,
          keyboardType: TextInputType.datetime,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_month_outlined,
              size: 16,
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? appColors.primary
                      : appColors.black,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 0,
            ),
            filled: true,
            fillColor: appColors.white,
            label:
                widget.label != null
                    ? Text(
                      widget.label!,
                      style: appFonts.ts.copyWith(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? appColors.primary
                                : appColors.black,
                      ),
                    )
                    : null,
            labelStyle: appFonts.primary.ts,
            hintText: widget.label,
            hintStyle: appFonts.caption.primary.ts,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 22,
            ),
            border: widget.customBorder ?? border,
            enabledBorder: widget.customBorder ?? border,
            focusedBorder: widget.customFocusedBorder ?? focusedBorder,
            errorBorder: errorBorder,
            errorStyle: appFonts.caption.error.ts,
          ),
        ),
      ],
    );
  }

  InputBorder get border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color:
            Theme.of(context).brightness == Brightness.light
                ? appColors.primary
                : appColors.black,
      ),
    );
  }

  InputBorder get focusedBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color:
            Theme.of(context).brightness == Brightness.light
                ? appColors.primary
                : appColors.black,
      ),
    );
  }

  InputBorder get errorBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color:
            Theme.of(context).brightness == Brightness.light
                ? appColors.primary
                : appColors.error.surface,
      ),
    );
  }
}
