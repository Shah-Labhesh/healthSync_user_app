import 'package:flutter/material.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class DeleteQualificationDialog extends StatelessWidget {
  const DeleteQualificationDialog({
    Key? key,
    required this.id,
    this.onDeleteTap,
  }) : super(key: key);

  final String id;
  final Function()? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Qualification'),
      titleTextStyle: const TextStyle(
        fontSize: FontSizeManager.f22,
        fontWeight: FontWeightManager.semiBold,
        color: gray900,
      ),
      content: const Text('Are you sure you want to delete this qualification?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onDeleteTap,
          child: const Text(
            'Delete',
            style: TextStyle(
              color: red600,
            ),
          ),
        ),
      ],
    );
  }
}
