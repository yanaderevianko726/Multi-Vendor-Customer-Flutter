import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CuisineView extends StatelessWidget {
  final String userName;
  const CuisineView({
    Key key,
    this.userName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    double height = 88;
    const double cellMargin = 5;
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {
        return (cuisineController.cuisinesList != null &&
                cuisineController.cuisinesList.isNotEmpty)
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 6, 14, 2),
                    child: TitleWidget(
                      title: 'cuisines'.tr,
                      onTap: () => Get.toNamed(
                        RouteHelper.getCuisinesRoute(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Container(
                      width: double.infinity,
                      height: height,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: cuisineController.cuisinesList.length,
                        itemBuilder: (context, index) {
                          int bckIndex = index % 4;
                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                RouteHelper.getCuisineProductRoute(
                                  cuisineController.cuisinesList[index].id,
                                  cuisineController.cuisinesList[index].name,
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(cellMargin),
                              decoration: BoxDecoration(
                                color: cuisineBackColors[bckIndex],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 0.8,
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    CustomImage(
                                      image:
                                          '${Get.find<SplashController>().configModel.baseUrls.cuisineImageUrl}/${cuisineController.cuisinesList[index].image}',
                                      width: height - cellMargin * 2,
                                      height: height - cellMargin * 2,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: height - cellMargin * 2,
                                      height: height - cellMargin * 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black54,
                                            Colors.black12,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: height - cellMargin * 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                top: 6,
                                                bottom: 6.0,
                                              ),
                                              child: Text(
                                                cuisineController
                                                    .cuisinesList[index].name,
                                                style: robotoMedium.copyWith(
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Column(children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300],
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryAllShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
