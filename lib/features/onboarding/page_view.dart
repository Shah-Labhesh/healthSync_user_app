import 'package:flutter/material.dart';
import 'package:user_mobile_app/constants/app_color.dart';
import 'package:user_mobile_app/constants/app_icon.dart';
import 'package:user_mobile_app/constants/app_images.dart';
import 'package:user_mobile_app/constants/app_string.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';
import 'package:user_mobile_app/features/onboarding/onBoarding.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;

  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: pageController,
                scrollDirection: Axis.horizontal,

                children: const [
                  OnBoardingPageView(
                    title: AppStrings.title1,
                    subtitle: AppStrings.subtitle1,
                    image: AppImages.onboardingImage1,
                    width: WidthManager.w250,
                    height: HeightManager.h250,
                  ),
                  OnBoardingPageView(
                    title: AppStrings.title2,
                    subtitle: AppStrings.subtitle2,
                    image: AppImages.onboardingImage2,
                    width: WidthManager.w300,
                    height: HeightManager.h300,
                  ),
                  OnBoardingPageView(
                    title: AppStrings.title3,
                    subtitle: AppStrings.subtitle3,
                    image: AppImages.onboardingImage3,
                    width: WidthManager.w250,
                    height: HeightManager.h266,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.all(PaddingManager.p2),
                    child: Container(
                      width: WidthManager.w10,
                      height: HeightManager.h10,
                      decoration: BoxDecoration(
                        color: (currentPage == i) ? blue900 : gray300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                const SizedBox(
                  width: WidthManager.w10,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingLarge,
                vertical: PaddingManager.padding
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, 'login_screen');
                    },
                    child: Text(
                      'Skip',
                      style: textTheme.displaySmall!.copyWith(
                        color: blue900,
                        fontWeight: FontWeightManager.regular,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentPage++;
                      });
                      (pageController.page == 2)
                          ? Navigator.pushReplacementNamed(
                              context,
                              'login_screen',
                            )
                          : pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                    },
                    child: Container(
                      width: WidthManager.w45,
                      height: HeightManager.h45,
                      padding: const EdgeInsetsDirectional.all(
                          PaddingManager.padding),
                      decoration: BoxDecoration(
                        color: blue900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        forwardIcon,
                        color: white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: HeightManager.h40,
            ),
          ],
        ),
      ),
    );
  }
}
