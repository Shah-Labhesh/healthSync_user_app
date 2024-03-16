// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/account/data/model/user.dart';
import 'package:user_mobile_app/features/authentication/data/model/specialities.dart';
import 'package:user_mobile_app/features/home/widgets/doctor_tile.dart';
import 'package:user_mobile_app/features/home/widgets/no_doctor_widget.dart';
import 'package:user_mobile_app/features/notification/bloc/notification_bloc/notification_bloc.dart';
import 'package:user_mobile_app/features/search_doctors/bloc/search_bloc/search_bloc.dart';
import 'package:user_mobile_app/features/search_doctors/bloc/search_bloc/search_event.dart';
import 'package:user_mobile_app/features/search_doctors/bloc/search_bloc/search_state.dart';
import 'package:user_mobile_app/features/search_doctors/data/model/search_param.dart';
import 'package:user_mobile_app/features/search_doctors/widgets/filter_container.dart';
import 'package:user_mobile_app/widgets/appbar.dart';
import 'package:user_mobile_app/widgets/custom_textfield.dart';

class SearchDoctorScreen extends StatefulWidget {
  const SearchDoctorScreen({super.key});

  @override
  State<SearchDoctorScreen> createState() => _SearchDoctorScreenState();
}

class _SearchDoctorScreenState extends State<SearchDoctorScreen> {
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> priceType = ['LOW_TO_HIGH', 'HIGH_TO_LOW', 'RANGE'];
  List<Specialities> specialities = [];

  String? selectedPriceType;
  String? speciality;
  String? specialityName;
  String? priceFrom;
  String? priceTo;
  double ratings = 0.0;
  bool? popular;

  void fetchData() {
    if (Utils.checkInternetConnection(context)) {
      BlocProvider.of<SearchBloc>(context).add(SearchDoctors(
        feeFrom: priceFrom,
        feeTo: priceTo,
        feeType: selectedPriceType,
        popular: popular,
        ratings: ratings,
        speciality: speciality,
        text: _searchText,
      ));
    }
  }

  bool checkFilter() {
    if (speciality != null ||
        selectedPriceType != null ||
        priceFrom != null ||
        priceTo != null ||
        ratings != 0.0 ||
        popular != null) {
      return true;
    }
    return false;
  }

  void clearFilter() {
    if (!checkFilter()) {
      return;
    }
    setState(() {
      speciality = null;
      specialityName = null;
      selectedPriceType = null;
      priceFrom = null;
      priceTo = null;
      ratings = 0.0;
      popular = null;
    });
    fetchData();
  }

  List<User> doctors = [];

  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SearchParam?;
    if (args != null && isFirstTime) {
      if (args.speciality != null) {
        speciality = args.speciality;
        specialityName = args.specialityName;
      }
      if (args.feeType != null) {
        selectedPriceType = args.feeType;
      }
      if (args.feeFrom != null) {
        priceFrom = args.feeFrom;
      }
      if (args.feeTo != null) {
        priceTo = args.feeTo;
      }
      if (args.popular != null) {
        popular = args.popular;
      }
      isFirstTime = false;
    }
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is TokenExpired) {
          Utils.handleTokenExpired(context);
        }

        if (state is SearchSuccess) {
          doctors = state.doctors;
        }

        if (state is SpecialitySuccess) {
          specialities = state.specialities;
        }

        if (state is ToogleFavoriteSuccess) {
          for (User element in doctors) {
            if (element.id == state.id) {
              element.favorite = !element.favorite!;
            }
          }
        }

        if (state is ToogleFavoriteFailure) {
          Utils.showSnackBar(context, state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        if (state is SearchInitial) {
          fetchData();
          context.read<SearchBloc>().add(GetSpecialities());
        }

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium2,
                  vertical: PaddingManager.p10),
              child: Column(
                children: [
                  BlocProvider(
                    create: (context) => NotificationBloc(),
                    child: const CustomAppBar(
                      title: 'Find Doctor',
                      isBackButton: true,
                      notification: true,
                    ),
                  ),
                  const SizedBox(
                    height: HeightManager.h20,
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: clearFilter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: PaddingManager.p12,
                                vertical: PaddingManager.p10),
                            margin: const EdgeInsets.only(
                              right: PaddingManager.p8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: gray200, width: 1.5),
                              color: checkFilter() ? gray100 : white,
                            ),
                            child: const ImageIcon(
                              AssetImage(funnelIcon),
                              color: gray800,
                              size: 18,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          constraints: const BoxConstraints(
                            maxHeight: HeightManager.h200,
                          ),
                          itemBuilder: (context) {
                            context.read<SearchBloc>().add(GetSpecialities());
                            if (specialities.isEmpty) {
                              return [];
                            }
                            return specialities
                                .map((e) => PopupMenuItem(
                                      value: e.id,
                                      child: Text(e.name!),
                                      onTap: () {
                                        setState(() {
                                          speciality = e.id;
                                          specialityName = e.name;
                                        });
                                        fetchData();
                                      },
                                    ))
                                .toList();
                          },
                          child: FilterContainer(
                            title: specialityName ?? 'Speciality',
                            dropDown: speciality == null,
                            isSelected: speciality != null,
                            onCancelPressed: () {
                              setState(() {
                                speciality = null;
                                specialityName = null;
                              });
                              fetchData();
                            },
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return priceType
                                .map((e) => PopupMenuItem(
                                      value: e,
                                      child: Text(e.removeUnderScore()),
                                      onTap: () {
                                        if (e == 'RANGE') {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return SimpleDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                                PaddingManager
                                                                    .paddingMedium,
                                                            vertical:
                                                                PaddingManager
                                                                    .p12),
                                                    children: [
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Min Price',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  FontSizeManager
                                                                      .f14,
                                                              color: gray700,
                                                              fontWeight:
                                                                  FontWeightManager
                                                                      .regular,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Max Price',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  FontSizeManager
                                                                      .f14,
                                                              color: gray700,
                                                              fontWeight:
                                                                  FontWeightManager
                                                                      .regular,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height:
                                                            HeightManager.h12,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            priceFrom != null
                                                                ? priceFrom!
                                                                : '0',
                                                            style:
                                                                const TextStyle(
                                                              fontSize:
                                                                  FontSizeManager
                                                                      .f12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            priceTo != null
                                                                ? priceTo!
                                                                : '10000',
                                                            style:
                                                                const TextStyle(
                                                              fontSize:
                                                                  FontSizeManager
                                                                      .f12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      RangeSlider(
                                                        min: 0,
                                                        max: 10000,
                                                        values: RangeValues(
                                                          priceFrom != null
                                                              ? double.parse(
                                                                  priceFrom!,
                                                                )
                                                              : 0.0,
                                                          priceTo != null
                                                              ? double.parse(
                                                                  priceTo!,
                                                                )
                                                              : 10000.0,
                                                        ),
                                                        onChanged: (value) {
                                                          setState(
                                                            () {
                                                              priceFrom = value
                                                                  .start
                                                                  .toStringAsFixed(
                                                                      0);
                                                              priceTo = value
                                                                  .end
                                                                  .toStringAsFixed(
                                                                      0);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height:
                                                            HeightManager.h12,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    FontSizeManager
                                                                        .f14,
                                                                fontWeight:
                                                                    FontWeightManager
                                                                        .medium,
                                                                color: red600,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                                {
                                                                  "min":
                                                                      priceFrom,
                                                                  "max": priceTo
                                                                },
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Apply',
                                                              style: TextStyle(
                                                                color: green600,
                                                                fontSize:
                                                                    FontSizeManager
                                                                        .f14,
                                                                fontWeight:
                                                                    FontWeightManager
                                                                        .medium,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ).then((value) {
                                            if (value == null) {
                                              return;
                                            }
                                            setState(() {
                                              selectedPriceType = e;
                                              priceFrom = value['min'];
                                              priceTo = value['max'];
                                            });
                                            fetchData();
                                          });
                                        } else {
                                          setState(() {
                                            selectedPriceType = e;
                                          });
                                          fetchData();
                                        }
                                      },
                                    ))
                                .toList();
                          },
                          child: FilterContainer(
                            title: 'Price',
                            dropDown: selectedPriceType == null,
                            isSelected: selectedPriceType != null,
                            onCancelPressed: () {
                              setState(() {
                                selectedPriceType = null;
                              });
                              fetchData();
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  shape: ShapeBorder.lerp(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    0.0,
                                  ),
                                  children: [
                                    Center(
                                      child: RatingBar.builder(
                                        unratedColor: gray400,
                                        itemCount: 5,
                                        itemSize: 30,
                                        tapOnlyMode: true,
                                        itemPadding: const EdgeInsets.all(
                                            PaddingManager.p6),
                                        direction: Axis.horizontal,
                                        initialRating:
                                            ratings == 0.0 ? 0 : ratings,
                                        allowHalfRating: false,
                                        itemBuilder: (context, index) {
                                          return const ImageIcon(
                                            AssetImage(
                                              filledStarIcon,
                                            ),
                                            color: orange400,
                                          );
                                        },
                                        onRatingUpdate: (value) {
                                          Navigator.pop(context, value);
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            ).then((value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                ratings = value;
                              });
                              fetchData();
                            });
                          },
                          child: FilterContainer(
                            title: 'Ratings',
                            dropDown: false,
                            isSelected: ratings != 0.0,
                            onCancelPressed: () {
                              setState(() {
                                ratings = 0.0;
                              });
                              fetchData();
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (popular != null) {
                              setState(() {
                                popular = null;
                              });
                            } else {
                              setState(() {
                                popular = true;
                              });
                            }
                            fetchData();
                          },
                          child: FilterContainer(
                            title: 'Popular',
                            dropDown: false,
                            isSelected: popular != null,
                            onCancelPressed: () {
                              setState(() {
                                popular = null;
                              });
                              fetchData();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: HeightManager.h30,
                  ),
                  CustomTextfield(
                    label: '',
                    hintText: 'Search Doctor',
                    controller: _searchController,
                    suffixIcon: _searchText.isNotEmpty
                        ? const Icon(
                            Icons.cancel,
                            color: gray400,
                            size: 32,
                          )
                        : const Icon(
                            CupertinoIcons.search,
                            color: gray400,
                            size: 32,
                          ),
                    suffixPressed: () {
                      if (_searchController.text.isNotEmpty) {
                        setState(() {
                          _searchText = '';
                          _searchController.clear();
                        });
                        fetchData();
                      }
                    },
                    textInputType: TextInputType.text,
                    onChanged: (p0) {
                      setState(() {
                        _searchText = p0;
                      });
                      fetchData();
                    },
                  ),
                  const SizedBox(
                    height: HeightManager.h20,
                  ),
                  if (state is SearchLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (state is SearchFailure)
                    Center(
                      child: Text(state.message),
                    )
                  else if (doctors.isEmpty)
                    const NoDoctorWidget()
                  else
                    for (User doctor in doctors)
                      DoctorTile(
                        doctor: doctor,
                        onPressed: () {
                          context.read<SearchBloc>().add(
                                ToogleFavorite(
                                  id: doctor.id!,
                                ),
                              );
                        },
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
