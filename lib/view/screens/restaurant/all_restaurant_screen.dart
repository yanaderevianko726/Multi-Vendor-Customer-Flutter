import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/venues_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllRestaurantScreen extends StatefulWidget {
  AllRestaurantScreen();

  @override
  State<AllRestaurantScreen> createState() => _AllRestaurantScreenState();
}

class _AllRestaurantScreenState extends State<AllRestaurantScreen> {
  var offset = 1;
  var limit = 10;
  void initPage() async {
    Get.find<RestaurantController>().getRestaurantList(false, offset: 1);
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'all_restaurants'.tr,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<RestaurantController>().getPopularRestaurantList(
            false,
            offset: offset,
            limit: limit,
            type: Get.find<RestaurantController>().type,
          );
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<RestaurantController>(
                builder: (restController) {
                  return restController.popularRestaurantList.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    for (int index = 0;
                                        index <
                                            restController
                                                .popularRestaurantList.length;
                                        index++)
                                      VenuesViewWidget(
                                        restaurant: restController
                                            .popularRestaurantList[index],
                                        tagIndex: 0,
                                        cellWidth:
                                            MediaQuery.of(context).size.width *
                                                0.94,
                                      )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        )
                      : SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
