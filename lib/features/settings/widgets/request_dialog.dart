
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class RequestDialog extends StatefulWidget {
  const RequestDialog({super.key});

  @override
  State<RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<RequestDialog> {
  final List<String> options = [
    'MEDICAL_RECORDS_DELETION',
    'PRESCRIPTION_DELETION',
    'ACCOUNT_DELETION',
  ];

  String selectedOption = 'MEDICAL_RECORDS_DELETION';
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.paddingMedium,
        vertical: PaddingManager.paddingMedium,
      ),
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        1,
      ),
      title: Center(
        child: Text(
          'Delete Request',
          style: TextStyle(
            fontSize: FontSizeManager.f18,
            color: red900,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeightManager.semiBold,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Request Type',
                style: TextStyle(
                  fontSize: FontSizeManager.f16,
                  color: gray800,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeightManager.semiBold,
                ),
              ),
              const SizedBox(height: HeightManager.h6),
              DropdownButton(
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: blue900,
                ),
                value: selectedOption,
                items: [
                  for (String option in options)
                    DropdownMenuItem(
                      value: option,
                      child: Text(
                        option.removeUnderScore(),
                        style: TextStyle(
                          fontSize: FontSizeManager.f16,
                          color: gray700,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
              ),
              const SizedBox(height: HeightManager.h10),
              CustomTextfield(
                label: 'Reason',
                hintText: 'Write your reason here...',
                minLines: 5,
                maxLines: 5,
                controller: _reasonController,
                textInputType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  }
                  if (value.length < 10) {
                    return 'Reason should be at least 10 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: HeightManager.h20),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: gray700,
              fontSize: FontSizeManager.f16,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeightManager.regular,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                "type": selectedOption,
                "reason": _reasonController.text.trim(),
              });
            }
          },
          child: Text(
            'Request',
            style: TextStyle(
              color: red600,
              fontSize: FontSizeManager.f16,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeightManager.regular,
            ),
          ),
        ),
      ],
    );
  }
}
