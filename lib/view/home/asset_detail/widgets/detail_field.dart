import 'package:flutter/material.dart';
import 'package:pilog_idqm/global/app_styles.dart';

class DetailField extends StatelessWidget {
  final String? label;
  final String? value;

  const DetailField({
    super.key,
    this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label ?? "",
            style: AppStyles.black_15_400,
          ),
        ),
        TextFormField(
          style: AppStyles.black_15_400,
          enabled: false,
          initialValue: value ?? '',
          maxLines: null,
          minLines: 1,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}