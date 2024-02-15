// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:user_mobile_app/constants/font_value.dart';
import 'package:user_mobile_app/constants/value_manager.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.height,
    required this.width,
  });

  final String title;
  final String subtitle;
  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth < 600) {
        return Layout1(
          image: image,
          width: width,
          height: height,
          title: title,
          textTheme: textTheme,
          subtitle: subtitle,
        );
      } else {
        return Layout2(
          image: image,
          width: width,
          height: height,
          title: title,
          textTheme: textTheme,
          subtitle: subtitle,
        );
      }
    }));
  }
}

class Layout1 extends StatelessWidget {
  const Layout1({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    required this.title,
    required this.textTheme,
    required this.subtitle,
  });

  final String image;
  final double width;
  final double height;
  final String title;
  final TextTheme textTheme;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const Gap(
            PaddingManager.paddingExtraLarge,
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Image.asset(
              image,
              width: width,
              height: height,
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(PaddingManager.p10),
              child: FittedBox(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge!.copyWith(
                    fontSize: FontSizeManager.f26,
                    fontWeight: FontWeightManager.semiBold,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingManager.paddingLarge,
              ),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
      
          
        ],
      ),
    );
  }
}

class Layout2 extends StatelessWidget {
  const Layout2({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    required this.title,
    required this.textTheme,
    required this.subtitle,
  });

  final String image;
  final double width;
  final double height;
  final String title;
  final TextTheme textTheme;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingManager.paddingLarge,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(PaddingManager.p10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTheme.displayLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.paddingLarge,
                    ),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.displaySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Image.asset(
              image,
              width: width,
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}
