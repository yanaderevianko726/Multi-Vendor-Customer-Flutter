import 'package:efood_multivendor/controller/onboarding_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Get.find<OnBoardingController>().getOnBoardingList();

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: GetBuilder<OnBoardingController>(
        builder: (onBoardingController) => onBoardingController
                    .onBoardingList.length >
                0
            ? SafeArea(
                child: Center(
                  child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount:
                                onBoardingController.onBoardingList.length,
                            controller: _pageController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_DEFAULT,
                                      left: Dimensions.PADDING_SIZE_LARGE,
                                      right: Dimensions.PADDING_SIZE_LARGE,
                                    ),
                                    child: Image.asset(
                                        onBoardingController
                                            .onBoardingList[index].imageUrl,
                                        height: context.height * 0.4),
                                  ),
                                  SizedBox(height: context.height * 0.07),
                                  Text(
                                    onBoardingController
                                        .onBoardingList[index].title,
                                    style: robotoMedium.copyWith(
                                      fontSize: context.height * 0.022,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: context.height * 0.025),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_LARGE * 2),
                                    child: Text(
                                      onBoardingController
                                          .onBoardingList[index].description,
                                      style: robotoRegular.copyWith(
                                        fontSize: context.height * 0.018,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                            onPageChanged: (index) {
                              onBoardingController.changeSelectIndex(index);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _pageIndicators(
                            onBoardingController,
                            context,
                          ),
                        ),
                        SizedBox(height: context.height * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE,
                          ),
                          child: Row(children: [
                            onBoardingController.selectedIndex == 2
                                ? SizedBox()
                                : Expanded(
                                    child: InkWell(
                                      child: Container(
                                        height: 44,
                                        margin: EdgeInsets.only(
                                          right:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'skip'.tr,
                                            textAlign: TextAlign.center,
                                            style: robotoBold.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Get.find<SplashController>()
                                            .disableIntro();
                                        Get.offAndToNamed(
                                          RouteHelper.getSignInRootRoute(),
                                        );
                                      },
                                    ),
                                  ),
                            Expanded(
                              child: CustomButton(
                                buttonText: 'next'.tr,
                                radius: 30,
                                height: 46,
                                onPressed: () {
                                  if (onBoardingController.selectedIndex != 2) {
                                    _pageController.nextPage(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.ease,
                                    );
                                  } else {
                                    Get.find<SplashController>().disableIntro();
                                    Get.offAndToNamed(
                                      RouteHelper.getSignInRootRoute(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  List<Widget> _pageIndicators(
    OnBoardingController onBoardingController,
    BuildContext context,
  ) {
    List<Container> _indicators = [];
    for (int i = 0; i < onBoardingController.onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: 7,
          height: 7,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: i == onBoardingController.selectedIndex
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            borderRadius: i == onBoardingController.selectedIndex
                ? BorderRadius.circular(50)
                : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
