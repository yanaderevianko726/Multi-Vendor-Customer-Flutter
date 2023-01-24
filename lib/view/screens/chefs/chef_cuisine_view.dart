import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/cuisine_model.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ChefCuisineView extends StatelessWidget {
  final String userName;
  final int cuisineIndex;
  final List<CuisineModel> cuisines;
  final Function onClickCuisine;

  const ChefCuisineView({
    Key key,
    this.userName,
    this.cuisineIndex,
    this.onClickCuisine,
    this.cuisines,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    double height = 72;
    double allMargin = Dimensions.PADDING_SIZE_EXTRA_SMALL;
    return (cuisines != null && cuisines.length == 0)
        ? SizedBox()
        : Card(
            margin: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              height: height,
              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: cuisines != null
                  ? ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: cuisines.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onClickCuisine(index);
                          },
                          child: index == 0
                              ? Container(
                                  width: height - allMargin * 2,
                                  height: height - allMargin * 2,
                                  margin: EdgeInsets.all(
                                    6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index == cuisineIndex
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2)
                                        : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: height - 34,
                                        height: height - 34,
                                        child: Center(
                                          child: Image.asset(
                                            'assets/image/ic_chefs_red.png',
                                            width: 22,
                                            height: 22,
                                            fit: BoxFit.cover,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        '${'All'.tr}',
                                        style: robotoMedium.copyWith(
                                          fontSize: 13,
                                          color: yellowDark,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: height - allMargin * 2,
                                  height: height - allMargin * 2,
                                  margin: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index == cuisineIndex
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2)
                                        : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(3.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(60),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              spreadRadius: 0.8,
                                              blurRadius: 3,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(height - 30),
                                            ),
                                            child: CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.cuisineImageUrl}/${cuisines[index].image}',
                                              width: height - 34,
                                              height: height - 34,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            cuisines[index].name,
                                            style: robotoMedium.copyWith(
                                              fontSize: 11,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    )
                  : SizedBox(),
            ),
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
