import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/authentication/data/model/Qualification.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_bloc.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_event.dart';
import 'package:user_mobile_app/features/settings/bloc/qualification_bloc/qualification_state.dart';
import 'package:user_mobile_app/features/settings/widgets/delete_qualification_dialog.dart';
import 'package:user_mobile_app/features/settings/widgets/qualification_tile.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MyQualificationScreen extends StatefulWidget {
  const MyQualificationScreen({super.key});

  @override
  State<MyQualificationScreen> createState() => _MyQualificationScreenState();
}

class _MyQualificationScreenState extends State<MyQualificationScreen> {
  List<DocQualification> qualifications = [];

  @override
  void initState() {
    super.initState();
    context.read<QualificationBloc>().add(GetQualifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(HeightManager.h73),
            child: AppBarCustomWithSceenTitle(title: 'My Qualification')),
        body: BlocConsumer<QualificationBloc, QualificationState>(
          listener: (context, state) {
            if (state is TokenExpired) {
              Utils.handleTokenExpired(context);
            }
            if (state is QualificationSuccess) {
              qualifications = state.qualifications;
            }

            if (state is QualificationDeletingFailure) {
              Utils.showSnackBar(context, state.message, isSuccess: false);
            }

            if (state is QualificationDeleted) {
              Utils.showSnackBar(context, 'Qualification Deleted Successfully');
              qualifications.removeWhere((element) => element.id == state.id);
            }
          },
          builder: (context, state) {
            if (state is QualificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return LoadingOverlay(
              isLoading: state is QualificationDeleting,
              progressIndicator: LoadingAnimationWidget.threeArchedCircle(
                color: blue900,
                size: 60,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: WidthManager.w20,
                    vertical: HeightManager.h20,
                  ),
                  child: Column(
                    children: [
                      if (qualifications.isEmpty &&
                          state is QualificationSuccess)
                        const Center(
                          child: Text(
                            'No Qualification Added',
                          ),
                        )
                      else
                        for (DocQualification qualification in qualifications)
                          QualificationTile(
                            qualification: qualification,
                            onEditTap: () {
                              if (Utils.checkInternetConnection(context)) {
                                Navigator.pushNamed(
                                    context, 'auth_qualification_screen',
                                    arguments: {
                                      'qualification': {
                                        'id': qualification.id,
                                        'title': qualification.title,
                                        'institute': qualification.institute,
                                        'passOutYear':
                                            qualification.passOutYear,
                                        'image': qualification.image,
                                      },
                                    }).then((value) {
                                  if (value != null) {
                                    qualifications.removeWhere((element) =>
                                        element.id == qualification.id);
                                    qualifications
                                        .add(value as DocQualification);
                                    setState(() {});
                                  }
                                });
                              }
                            },
                            onDeleteTap: () {
                              if (Utils.checkInternetConnection(context)) {
                                final bloc =
                                    BlocProvider.of<QualificationBloc>(context);
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      DeleteQualificationDialog(
                                    id: qualification.id!,
                                    onDeleteTap: () {
                                      bloc.add(DeleteQualification(
                                          id: qualification.id!));
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'auth_qualification_screen')
                .then((value) {
              if (value != null) {
                qualifications.add(value as DocQualification);
                setState(() {});
              }
            });
          },
          backgroundColor: blue900,
          child: const Icon(
            Icons.add,
            color: white,
          ),
        ));
  }
}
