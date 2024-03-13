// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/settings/bloc/request_deletion_bloc/request_deletion_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/request_deletion_bloc/request_deletion_event.dart';
import 'package:user_mobile_app/features/settings/bloc/request_deletion_bloc/request_deletion_state.dart';
import 'package:user_mobile_app/features/settings/data/model/requests.dart';
import 'package:user_mobile_app/features/settings/widgets/request_dialog.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class DataDeletionScreen extends StatefulWidget {
  const DataDeletionScreen({super.key});

  @override
  State<DataDeletionScreen> createState() => _DataDeletionScreenState();
}

class _DataDeletionScreenState extends State<DataDeletionScreen> {
  List<Requests> requestDeletion = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(HeightManager.h73),
          child: AppBarCustomWithSceenTitle(
            title: 'Data Deletion',
            isBackButton: true,
          ),
        ),
        body: BlocConsumer<RequestDeletionBloc, RequestDeletionState>(
            listener: (context, state) {
          if (state is TokenExpired) {
            Utils.handleTokenExpired(context);
          }

          if (state is RequestDeletionSuccess) {
            Utils.showSnackBar(context, state.message);
            Navigator.pop(context);
          }

          if (state is RequestDeletionFailure) {
            Utils.showSnackBar(context, state.message, isSuccess: false);
          }

          if (state is RequestDeletionLoaded) {
            requestDeletion = state.requestDeletion;
            setState(() {});
          }
        }, builder: (context, state) {
          if (state is RequestDeletionInitial) {
            context.read<RequestDeletionBloc>().add(FetchRequestDeletion());
          }
          if (state is RequestDeletionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestDeletionError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  fontSize: FontSizeManager.f16,
                  color: red600,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontWeight: FontWeightManager.semiBold,
                ),
              ),
            );
          }
          if (state is RequestDeletionLoaded) {
            requestDeletion = state.requestDeletion;
          }
          return LoadingOverlay(
            isLoading: state is RequestingDeletion,
            progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900,
              size: 60,
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                if (Utils.checkInternetConnection(context)) {
                  context
                      .read<RequestDeletionBloc>()
                      .add(FetchRequestDeletion());
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingManager.paddingMedium,
                    vertical: PaddingManager.paddingMedium,
                  ),
                  child: Column(
                    children: [
                      for (Requests req in requestDeletion)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: PaddingManager.p12,
                            horizontal: PaddingManager.p14,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: HeightManager.h20,
                          ),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: black.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delete Request - ${req.type!.removeUnderScore()}',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f18,
                                  color: gray800,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeightManager.semiBold,
                                ),
                              ),
                              const SizedBox(height: HeightManager.h10),
                              Text(
                                'Reason - ${req.reason}',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f14,
                                  color: gray600,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeightManager.medium,
                                ),
                              ),
                              const SizedBox(height: HeightManager.h10),
                              Text(
                                'Requested on - ${req.createdAt!.splitDate()} ${req.createdAt!.splitTime()}',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f14,
                                  color: gray600,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeightManager.regular,
                                ),
                              ),
                              const SizedBox(height: HeightManager.h18),
                              Text(
                                'Status - ${req.isAccepted! ? 'Accepted' : req.isRejected! ? 'Rejected' : 'Pending'}',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f16,
                                  color: gray900,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontWeight: FontWeightManager.semiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: HeightManager.h45),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const RequestDialog(),
            ).then((value) {
              if (value != null) {
                // debugPrint(value);
                if (Utils.checkInternetConnection(context)) {
                  context.read<RequestDeletionBloc>().add(
                      RequestDeletion(data: value! as Map<String, dynamic>));
                }
              }
            });
          },
          backgroundColor: blue900,
          child: const Icon(Icons.delete_forever_rounded, color: white),
        ));
  }
}
