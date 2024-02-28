// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/favorite/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:user_mobile_app/features/favorite/bloc/favorite_bloc/favorite_event.dart';
import 'package:user_mobile_app/features/favorite/bloc/favorite_bloc/favorite_state.dart';
import 'package:user_mobile_app/features/home/widgets/doctor_tile.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class MyFavoriteScreen extends StatelessWidget {
  MyFavoriteScreen({super.key});

  List<User> doctors = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }
        if (state is ToggleFavouriteSuccess) {
          Utils.showSnackBar(context, 'Removed from favorite', isSuccess: true);

          for (User doctor in doctors) {
            if (doctor.id == state.doctorId) {
              doctors.remove(doctor);
              break;
            }
          }
        }

        if (state is ToggleFavouriteFailed) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        if (state is FavoriteInitial) {
          context.read<FavoriteBloc>().add(FetchFavoriteEvent());
        }
        if (state is FavoriteLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FavoriteLoadFailed) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is FavoriteLoaded) {
          doctors = state.doctors;
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (Utils.checkInternetConnection(context)){
              context.read<FavoriteBloc>().add(FetchFavoriteEvent());
            }
            await Future.delayed(const Duration(seconds: 1));
          },
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(HeightManager.h73),
              child: AppBarCustomWithSceenTitle(
                title: 'Favorite',
                isBackButton: true,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingMedium2,
                vertical: PaddingManager.paddingSmall,
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    for (User doctor in doctors)
                      DoctorTile(
                        doctor: doctor,
                        onPressed: () {
                          final bloc = context.read<FavoriteBloc>();
                          bloc.add(ToggleFavouriteEvent(doctorId: doctor.id!));
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
