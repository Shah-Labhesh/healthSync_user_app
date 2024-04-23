import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/Utils/utils.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/payment/bloc/payment_bloc/payment_bloc.dart';
import 'package:user_mobile_app/features/payment/bloc/payment_bloc/payment_event.dart';
import 'package:user_mobile_app/features/payment/bloc/payment_bloc/payment_state.dart';
import 'package:user_mobile_app/features/payment/data/model/payment.dart';
import 'package:user_mobile_app/features/payment/widgets/no_transaction_widget.dart';
import 'package:user_mobile_app/features/payment/widgets/sort_container.dart';
import 'package:user_mobile_app/features/payment/widgets/transaction_tile.dart';
import 'package:user_mobile_app/widgets/custom_appbar.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  bool showAmount = false;
  bool doctor = false;
  bool edit = false;
  String sort = 'ALL';
  List<String> sortList = ['ALL', 'PENDING', 'SETTLED'];
  final mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int totalbalance = 0;

  @override
  void initState() {
    super.initState();
    initializeRole();
    context.read<PaymentBloc>().add(GetMyPayments(
          sort: sort,
        ));
  }

  void initializeRole() async {
    // Add your code here
    final role = await SharedUtils.getRole();
    showAmount = await SharedUtils.getAmountHide();
    if (role == 'DOCTOR') {
      setState(() {
        doctor = true;
      });
    }
  }

  void fetchData() {
    if (Utils.checkInternetConnection(context)) {
      context.read<PaymentBloc>().add(GetMyPayments(
            sort: sort,
          ));
    }
  }

  List<Payment> payments = [];

  String khaltiId = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null) {
      khaltiId = args;
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(HeightManager.h73),
        child: AppBarCustomWithSceenTitle(
          title: 'Payment Details',
          isBackButton: true,
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is TokenExpired) {
            Utils.handleTokenExpired(context);
          }
          if (state is PaymentSuccess) {
            if (payments.isNotEmpty) {
              payments.clear();
            }
            payments = state.payments;
            setState(() {});
            if (sort == 'ALL') {
              totalbalance = 0;
              for (var item in payments) {
                totalbalance += item.amount!;
              }
            }
          }

          if (state is KhaltiUpdated) {
            Utils.showSnackBar(
              context,
              'Khalti ID updated successfully',
            );
            setState(() {
              khaltiId = state.khalti;
              edit = false;
            });
          }

          if (state is KhaltiUpdateFailure) {
            Utils.showSnackBar(
              context,
              state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PaymentFailure) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          }
          if (state is PaymentSuccess) {
            payments = state.payments;
          }
          if (state is KhaltiUpdated) {
            khaltiId = state.khalti;
          }
          return LoadingOverlay(
            isLoading: state is UpdatingKhalti,
            progressIndicator: LoadingAnimationWidget.threeArchedCircle(
              color: blue900,
              size: 60,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingManager.paddingMedium2,
                  vertical: PaddingManager.paddingMedium2,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Payment Amount',
                          style: TextStyle(
                            fontSize: FontSizeManager.f18,
                            fontWeight: FontWeightManager.medium,
                            color: black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HeightManager.h10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAmount = !showAmount;
                        });
                        SharedUtils.setAmountHide(showAmount);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: WidthManager.w24,
                          ),
                          Text(
                            'NRs. ${showAmount ? totalbalance : '****'}',
                            style: TextStyle(
                              fontSize: FontSizeManager.f24,
                              fontWeight: FontWeightManager.black,
                              color: blue800,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                          ),
                          showAmount
                              ? const Icon(
                                  CupertinoIcons.eye_slash,
                                  color: gray800,
                                  size: 24,
                                )
                              : const Icon(
                                  CupertinoIcons.eye,
                                  color: gray800,
                                  size: 24,
                                )
                        ],
                      ),
                    ),
                    const SizedBox(height: HeightManager.h50),
                    if (doctor)
                      if (edit) ...[
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: '',
                              hintText: '9875341235',
                              suffixIcon: Icon(
                                CupertinoIcons.creditcard,
                                size: 24,
                                color: gray500,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: PaddingManager.p6,
                                vertical: PaddingManager.p5,
                              ),
                            ),
                            controller: mobileController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter mobile number';
                              }
                              if (value.length < 10) {
                                return 'Please enter valid mobile number';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter valid mobile number';
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                context.read<PaymentBloc>().add(UpdateKhalti(
                                      khalti: mobileController.text.trim(),
                                    ));
                              }
                            },
                            onTapOutside: (event) {
                              setState(() {
                                edit = false;
                              });
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Text('Khalti ID',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f18,
                                  fontWeight: FontWeightManager.regular,
                                  color: gray500,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                )),
                            const Spacer(),
                            Text(
                              khaltiId,
                              style: TextStyle(
                                fontSize: FontSizeManager.f14,
                                fontWeight: FontWeightManager.regular,
                                color: gray600,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: WidthManager.w10),
                            GestureDetector(
                              onTap: () {
                                mobileController.text = khaltiId;
                                setState(() {
                                  edit = true;
                                });
                              },
                              child: const Icon(
                                CupertinoIcons.pencil,
                                color: blue800,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: HeightManager.h5),
                        const Divider(
                          color: gray400,
                          thickness: 1,
                        ),
                      ],
                    Row(
                      children: [
                        for (var item in sortList)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sort = item;
                              });
                              fetchData();
                            },
                            child: SortContainer(
                              title: item.capitalize(),
                              isSelected: item == sort,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: HeightManager.h20),
                    if (payments.isEmpty)
                      const NoTransactionWidget()
                    else
                      for (var item in payments)
                        TransactionTile(
                          id: item.appointment!.appointmentId ?? '-',
                          date: item.createdAt!.splitDate(),
                          amount: item.amount.toString(),
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
