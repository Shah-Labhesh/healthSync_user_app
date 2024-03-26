
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_bloc.dart';
import 'package:user_mobile_app/features/medical_records/bloc/record_bloc/record_event.dart';
import 'package:user_mobile_app/features/medical_records/data/model/record_request.dart';

class RecordRequestWidget extends StatelessWidget {
  const RecordRequestWidget({
    super.key,
    required this.request,
  });

  final RecordRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          vertical: PaddingManager.p14,
          horizontal: PaddingManager.p18),
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.p12,
        vertical: PaddingManager.p10,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Record Request',
                  style: TextStyle(
                    fontSize: FontSizeManager.f16,
                    fontWeight:
                        FontWeightManager.semiBold,
                    color: gray800,
                    fontFamily: GoogleFonts.montserrat()
                        .fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Doctor Name ${request.doctor!.name!}',
                  style: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight: FontWeightManager.regular,
                    color: gray800,
                    fontFamily: GoogleFonts.montserrat()
                        .fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
               if (request.accepted == false &&
                    request.rejected == false)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (Utils
                                .checkInternetConnection(
                                    context)) {
                              context
                                  .read<RecordBloc>()
                                  .add(
                                      UpdateRequestStatus(
                                          requestId:
                                              request.id!,
                                          value: true));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets
                                .symmetric(
                              horizontal:
                                  PaddingManager.p10,
                              vertical:
                                  PaddingManager.p12,
                            ),
                            decoration: BoxDecoration(
                              color: blue900,
                              borderRadius:
                                  BorderRadius.circular(
                                      6),
                              border: Border.all(
                                color: blue900,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize:
                                      FontSizeManager.f14,
                                  fontWeight:
                                      FontWeightManager
                                          .semiBold,
                                  color: white,
                                  fontFamily: GoogleFonts
                                          .montserrat()
                                      .fontFamily,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (Utils
                                .checkInternetConnection(
                                    context)) {
                              context
                                  .read<RecordBloc>()
                                  .add(
                                      UpdateRequestStatus(
                                          requestId:
                                              request.id!,
                                          value: false));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets
                                .symmetric(
                              horizontal:
                                  PaddingManager.p10,
                              vertical:
                                  PaddingManager.p12,
                            ),
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: red600,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                      6),
                            ),
                            child: Center(
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  fontSize:
                                      FontSizeManager.f14,
                                  fontWeight:
                                      FontWeightManager
                                          .semiBold,
                                  color: red600,
                                  fontFamily: GoogleFonts
                                          .montserrat()
                                      .fontFamily,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    "Status ${request.accepted! ? 'Accepted' : 'Rejected'}",
                    style: TextStyle(
                      fontSize: FontSizeManager.f14,
                      fontWeight:
                          FontWeightManager.semiBold,
                      color: request.accepted!
                          ? green900
                          : red600,
                      fontFamily: GoogleFonts.montserrat()
                          .fontFamily,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
          if (request.accepted == true) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (Utils.checkInternetConnection(
                    context)) {
                  context.read<RecordBloc>().add(
                      RevokePermission(
                          requestId: request.id!,
                         ));
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: PaddingManager.p10,
                  vertical: PaddingManager.p12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: gray200,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  'Revoke',
                  style: TextStyle(
                    fontSize: FontSizeManager.f14,
                    fontWeight:
                        FontWeightManager.semiBold,
                    color: gray600,
                    fontFamily: GoogleFonts.montserrat()
                        .fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
