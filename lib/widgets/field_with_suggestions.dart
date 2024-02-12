// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:user_mobile_app/constants/app_color.dart';

class SuggestionField extends StatefulWidget {
  const SuggestionField({
    Key? key,
    required this.suggestionsCallback,
    this.controller,
    required this.title,
    required this.onSuggestionSelected,
    required this.itemBuilder,
  }) : super(key: key);

  final FutureOr<Iterable<Object?>> Function(String) suggestionsCallback;
  final TextEditingController? controller;
  final String title;
  final Widget Function(BuildContext, Object?) itemBuilder;
  final Function(Object?) onSuggestionSelected;

  @override
  State<SuggestionField> createState() => _SuggestionFieldState();
}

class _SuggestionFieldState extends State<SuggestionField> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: gray400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: gray400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: gray400),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: gray400),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: gray400),
          ),
          fillColor: gray50,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          counterText: "",
          hintText: widget.title,
          hintStyle: const TextStyle(
            color: gray500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      
      itemBuilder: widget.itemBuilder,
      onSuggestionSelected: widget.onSuggestionSelected,
      errorBuilder: (context, error) {
        return const ListTile(
          title: Text("Something Went Wrong"),
        );
      },
      loadingBuilder: (context) {
        return const ListTile(
          title: Text("Loading..."),
        );
      },
      noItemsFoundBuilder: (context) {
        return const ListTile(
          title: Text("No Place Found"),
        );
      },
      suggestionsCallback: widget.suggestionsCallback,
    );
  }
}
