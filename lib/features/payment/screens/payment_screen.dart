import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_mobile_app/Utils/shared_preferences_utils.dart';
import 'package:user_mobile_app/Utils/string_extension.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/font_value.dart';
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
  String sort = 'PENDING';
  List<String> sortList = ['PENDING', 'SETTLED'];
  final mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initializeRole();
  }

  void initializeRole() async {
    // Add your code here
    final role = await SharedUtils.getRole();
    if (role == 'DOCTOR') {
      setState(() {
        doctor = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarCustomWithSceenTitle(
          title: 'Payment Details',
          isBackButton: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              // Add your widgets here
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAmount = !showAmount;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    Text(
                      'NRs. ${showAmount ? '1000.00' : '****'}',
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
              const SizedBox(height: 50),
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
                        horizontal: 6,
                        vertical: 5,
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
                        setState(() {
                          edit = false;
                        });
                      }
                      if (value.isNotEmpty) {
                        print("object");
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
                      '9875341235',
                      style: TextStyle(
                        fontSize: FontSizeManager.f14,
                        fontWeight: FontWeightManager.regular,
                        color: gray600,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
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
                const SizedBox(height: 5),
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
                      },
                      child: SortContainer(
                        title: item.capitalize(),
                        isSelected: item == sort,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const TransactionTile(
                id: '123456',
                date: '12th May 2021',
                amount: '1000.00',
              ),
              const TransactionTile(
                id: '123457',
                date: '12th May 2021',
                amount: '1000.00',
              ),
              const TransactionTile(
                id: '123458',
                date: '12th May 2021',
                amount: '1000.00',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.id,
    required this.date,
    required this.amount,
  });

  final String id;
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
          color: gray50,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.08),
              blurRadius: 20,
            ),
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Appointment ID',
                      style: TextStyle(
                        fontSize: FontSizeManager.f18,
                        fontWeight: FontWeightManager.semiBold,
                        color: gray800,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    TextSpan(
                      text: '#$id',
                      style: TextStyle(
                        fontSize: FontSizeManager.f18,
                        fontWeight: FontWeightManager.regular,
                        color: gray400,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: FontSizeManager.f12,
                    fontWeight: FontWeightManager.medium,
                    color: gray500,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'NRs. $amount',
            style: TextStyle(
              fontSize: FontSizeManager.f18,
              fontWeight: FontWeightManager.semiBold,
              color: gray600,
              fontFamily: GoogleFonts.poppins().fontFamily,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SortContainer extends StatelessWidget {
  const SortContainer({
    super.key,
    required this.title,
    required this.isSelected,
  });

  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: gray200, width: 1.5),
        color: isSelected ? gray100 : white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontSizeManager.f14,
          fontWeight: FontWeightManager.semiBold,
          color: gray800,
          fontFamily: GoogleFonts.poppins().fontFamily,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
