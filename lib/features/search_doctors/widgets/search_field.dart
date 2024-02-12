// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
    required this.hintText,
    required this.suffixIcon,
    required this.suggestionsCallback,
    this.controller,
    required this.title,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    this.suffixPressed,
  }) : super(key: key);

  final FutureOr<Iterable<Object?>> Function(String) suggestionsCallback;
  final TextEditingController? controller;
  final String title;
  final Widget Function(BuildContext, Object?) itemBuilder;
  final Function(Object?) onSuggestionSelected;
  final String hintText;
  final Widget? suffixIcon;
  final Function()? suffixPressed;
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(
        fillColor: white,
        filled: true,
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
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: gray300, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: gray300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: gray300, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
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
          title: Text("No Recent Search Found"),
        );
      },
      suggestionsCallback: widget.suggestionsCallback,
    );
  }
}


                  // SearchField(
                  //   hintText: 'Search Doctor',
                  //   controller: _searchController,
                  //   suffixIcon: _searchController.text.isNotEmpty
                  //       ? const Icon(
                  //           Icons.cancel_outlined,
                  //           color: gray400,
                  //           size: 32,
                  //         )
                  //       : const Icon(
                  //           CupertinoIcons.search,
                  //           color: gray300,
                  //           size: 32,
                  //         ),
                  //   suggestionsCallback: (p0) {
                  //     return SharedUtils.getSearchHistory();
                  //   },
                  //   title: 'Search',
                  //   onSuggestionSelected: (p0) {
                  //     print(p0);
                  //   },
                  //   itemBuilder: (p0, p1) {
                  //     return ListTile(
                  //       title: Text(p1.toString()),
                  //     );
                  //   },
                  // ),