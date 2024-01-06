// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class CustomTextfield extends StatefulWidget {
  CustomTextfield({
    Key? key,
    required this.label,
    this.bottomPadding = 16,
    this.obscure = false,
    this.suffixIcon,
    required this.hintText,
    this.textInputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.suffixPressed,
    this.nextFocusNode,
  }) : super(key: key);

  final String label;
  final double bottomPadding;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  bool obscure;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Function()? suffixPressed;

  final String hintText;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty) ...[
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: FontSizeManager.f16,
                fontWeight: FontWeightManager.semiBold,
                color: gray800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(
              height: HeightManager.h12,
            ),
          ],
          TextFormField(
            obscureText: widget.obscure,
            keyboardType: widget.textInputType,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            controller: widget.controller,
            onChanged: widget.onChanged,
            validator: widget.validator,
            focusNode: widget.focusNode,
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              fontSize: FontSizeManager.f16,
              fontWeight: FontWeightManager.regular,
              color: gray800,
            ),
            onFieldSubmitted: (value) {
              if (widget.nextFocusNode != null) {
                widget.nextFocusNode!.requestFocus();
              }
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: widget.suffixPressed ?? () {},
                icon: widget.suffixIcon ?? const SizedBox(),
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontFamily: GoogleFonts.montserrat().fontFamily,
                fontSize: FontSizeManager.f16,
                fontWeight: FontWeightManager.regular,
                color: gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: gray400, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: gray400, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: gray400, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            ),
          ),
        ],
      ),
    );
  }
}
