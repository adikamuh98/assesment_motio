import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppRadioButtonValue<T> {
  final String label;
  final T value;

  const AppRadioButtonValue({
    required this.label,
    required this.value,
  });
}

class AppRadioButton<T> extends StatefulWidget {
  final String? label;
  final List<AppRadioButtonValue<T>> values;
  final Axis direction;
  const AppRadioButton({
    super.key,
    this.label,
    required this.values,
    this.direction = Axis.horizontal,
  });

  @override
  State<AppRadioButton<T>> createState() => _AppRadioButtonState<T>();
}

class _AppRadioButtonState<T> extends State<AppRadioButton<T>> {
  late T curValue;

  @override
  void initState() {
    super.initState();
    curValue = widget.values.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: appFonts.caption.ts),
          const SizedBox(height: 8),
        ],
        Flex(
          direction: widget.direction,
          children: [
            ...widget.values.map((e) {
              return Row(
                children: [
                  Radio<T>(
                    activeColor: appColors.primary,
                    value: e.value,
                    groupValue: curValue,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      setState(() {
                        curValue = e.value;
                      });
                    },
                  ),
                  Text(e.label, style: appFonts.caption.ts),
                  if (widget.direction == Axis.vertical)
                    const SizedBox(height: 8),
                  if (widget.direction == Axis.horizontal)
                    const SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}
