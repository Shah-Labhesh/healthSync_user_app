import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/faqs/bloc/faqs_bloc/faqs_bloc.dart';
import 'package:user_mobile_app/features/faqs/bloc/faqs_bloc/faqs_event.dart';
import 'package:user_mobile_app/features/faqs/bloc/faqs_bloc/faqs_state.dart';
import 'package:user_mobile_app/features/faqs/data/model/faq.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(title: 'FAQs'),
      ),
      body: BlocConsumer<FAQBloc, FAQsState>(listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
      }, builder: (context, state) {
        if (state is FAQsInitial) {
          context.read<FAQBloc>().add(GetFAQs());
        }
        if (state is FAQsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FAQsError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(
                fontWeight: FontWeightManager.regular,
                fontSize: FontSizeManager.f16,
                color: gray500,
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
          );
        }
        if (state is FAQsLoaded) {
          if (state.faqs.isEmpty) {
            return Center(
              child: Text(
                'No FAQs available',
                style: TextStyle(
                  fontWeight: FontWeightManager.regular,
                  fontSize: FontSizeManager.f16,
                  color: gray500,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  letterSpacing: 0.5,
                ),
              ),
            );
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium2,
                  vertical: PaddingManager.paddingMedium2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (FaQs faq in state.faqs) ...[
                      Text(
                      faq.question ?? '',
                      style: TextStyle(
                        fontWeight: FontWeightManager.semiBold,
                        fontSize: FontSizeManager.f18,
                        color: gray800,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: HeightManager.h10,
                    ),
                    Text(
                      faq.answer ?? '',
                      style: TextStyle(
                        fontWeight: FontWeightManager.regular,
                        fontSize: FontSizeManager.f16,
                        color: gray500,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        letterSpacing: 0.5,
                      ),
                    ),
                      const SizedBox(
                        height: HeightManager.h20,
                      ),
                    ],
                    
                  ],
                ),
              ),
            );
          }
        }
        return const SizedBox();
      }),
    );
  }
}
