import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChefCuisineScreen extends StatefulWidget {
  @override
  State<ChefCuisineScreen> createState() => _ChefCuisineScreenState();
}

class _ChefCuisineScreenState extends State<ChefCuisineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'cuisines'.tr),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: GetBuilder<CuisineController>(
                  builder: (cuisineController) {
                    return cuisineController.cuisinesList != null
                        ? cuisineController.cuisinesList.length > 0
                            ? GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: (1 / 1),
                                  mainAxisSpacing:
                                      Dimensions.PADDING_SIZE_SMALL,
                                  crossAxisSpacing:
                                      Dimensions.PADDING_SIZE_SMALL,
                                ),
                                padding: EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_SMALL,
                                ),
                                itemCount:
                                    cuisineController.cuisinesList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Get.toNamed(
                                      RouteHelper.getCuisineProductRoute(
                                        cuisineController
                                            .cuisinesList[index].id,
                                        cuisineController
                                            .cuisinesList[index].name,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[
                                                Get.isDarkMode ? 800 : 200],
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL,
                                            ),
                                            child: CustomImage(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.cuisineImageUrl}/${cuisineController.cuisinesList[index].image}',
                                            ),
                                          ),
                                          SizedBox(
                                            height: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL,
                                          ),
                                          Text(
                                            cuisineController
                                                .cuisinesList[index].name,
                                            textAlign: TextAlign.center,
                                            style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : NoDataScreen(
                                text: 'no_category_found'.tr,
                              )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
