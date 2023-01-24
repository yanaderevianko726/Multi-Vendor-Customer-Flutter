import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatelessWidget {
  final String userName;

  const CategoryView({
    Key key,
    this.userName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    double height = 96;

    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        return (categoryController.categoryList != null &&
                categoryController.categoryList.length == 0)
            ? SizedBox()
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14, 6, 14, 10),
                    child: TitleWidget(
                      title: 'categories'.tr,
                      onTap: () => Get.toNamed(
                        RouteHelper.getCategoryRoute(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      height: height,
                      child: categoryController.categoryList != null
                          ? ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryController.categoryList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => Get.toNamed(
                                    RouteHelper.getCategoryProductRoute(
                                      categoryController.categoryList[index].id,
                                      categoryController
                                          .categoryList[index].name,
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      bottom:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      right: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_DEFAULT,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[
                                              Get.find<ThemeController>()
                                                      .darkTheme
                                                  ? 700
                                                  : 300],
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                              Dimensions.RADIUS_SMALL,
                                            ),
                                            topLeft: Radius.circular(
                                              Dimensions.RADIUS_SMALL,
                                            ),
                                          ),
                                          child: CustomImage(
                                            image:
                                                '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                                            width: 92,
                                            height: height - 34,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              categoryController
                                                  .categoryList[index].name,
                                              style: robotoMedium.copyWith(
                                                fontSize: 12,
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
                          : CategoryShimmer(
                              categoryController: categoryController),
                    ),
                  ),
                ],
              );
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
