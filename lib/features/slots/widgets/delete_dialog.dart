import 'package:flutter/material.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.slotId,
    this.onDeleteTap,
  }) : super(key: key);

  final String slotId;
  final Function()? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Slot'),
      titleTextStyle: const TextStyle(
        fontSize: FontSizeManager.f22,
        fontWeight: FontWeightManager.semiBold,
        color: gray900,
      ),
      content: const Text('Are you sure you want to delete this slot?'),
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
