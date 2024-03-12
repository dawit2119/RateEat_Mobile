import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/language/language.dart';
import 'package:rateeat_mobile/src/core/language/language_bloc.dart';
import 'package:rateeat_mobile/src/core/language/language_event.dart';
import 'package:rateeat_mobile/src/core/language/language_state.dart';
import 'package:rateeat_mobile/src/features/splash/presentation/widgets/circular_progress_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/routes.dart';
import 'splash_content.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  // List<Map<String, String>> splashData = [
  //   {
  //     'title': 'Welcome to RateEat',
  //     'detail': 'Discover the best restaurants and \ndishes in your area.',
  //     'image': 'assets/images/rafikisplash_1.png'
  //   },
  //   {
  //     'title': 'Find Your Perfect Spot',
  //     'detail': 'Let RateEat guide you to the ideal \ndining destination.',
  //     'image': 'assets/images/brosplash_2.png'
  //   },
  //   {
  //     'title': 'Rate and Share',
  //     'detail': 'Your opinion matters! Share your \ndining experiences now!',
  //     'image': 'assets/images/cuatesplash_3.png'
  //   },
  // ];

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) => Container(
          padding: const EdgeInsets.all(20),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Language',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...Language.values.map((lang) => ListTile(
                        onTap: () {
                          final languageState = Hive.box<String>('language');
                          languageState.put(0, lang.text);
                          context.read<LanguageBloc>().add(
                                ChangeLanguage(selectedLanguage: lang),
                              );
                          Navigator.pop(context);
                        },
                        title: Text(lang.text),
                        trailing: lang == state.selectedLanguage
                            ? const Icon(Icons.check_circle,
                                color: AppColors.primaryColor)
                            : null,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final localizations = AppLocalizations.of(context)!;
        final splashData = [
          {
            'title': localizations.onboardingTitle1,
            'detail': localizations.onboardingDetail1,
            'image': 'assets/images/rafikisplash_1.png'
          },
          {
            'title': localizations.onboardingTitle2,
            'detail': localizations.onboardingDetail2,
            'image': 'assets/images/brosplash_2.png'
          },
          {
            'title': localizations.onboardingTitle3,
            'detail': localizations.onboardingDetail3,
            'image': 'assets/images/cuatesplash_3.png'
          },
        ];

        return SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                          if (index >= splashData.length) {
                            context.goNamed(AppRoutes.login);
                          }
                        },
                        itemCount: splashData.length + 1,
                        itemBuilder: (context, index) {
                          if (index <= splashData.length - 1) {
                            return SplashContent(
                              title: splashData[index]['title']!,
                              detailInfo: splashData[index]['detail']!,
                              imagePath: splashData[index]['image']!,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 2.h,
                right: 4.w,
                child: IconButton(
                  onPressed: _showLanguageBottomSheet,
                  icon: const Icon(Icons.language, size: 28),
                  color: AppColors.primaryColor,
                ),
              ),
              Positioned(
                bottom: 2.h,
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                            (index) {
                              return buildDot(index: index);
                            },
                          ),
                        ),
                        CircularProgressButton(
                          currentPage: currentPage,
                          totalPages: 3,
                          onPress: () {
                            if (currentPage < 2) {
                              setState(() {
                                currentPage++;
                                _pageController.animateToPage(
                                  currentPage,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                              });
                            } else {
                              context.goNamed(AppRoutes.login);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: animationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: (currentPage == index) ? 20 : 6,
      decoration: BoxDecoration(
        color: (currentPage == index)
            ? AppColors.secondaryColor
            : const Color(0xffE1E4E8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
