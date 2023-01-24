import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/venues_view_widget.dart';
import 'package:efood_multivendor/view/screens/venues/widgets/featured_venues_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavVenues extends StatefulWidget {
  final int index;
  const FavVenues({
    Key key,
    this.index,
  }) : super(key: key);

  static Future<void> getVenuesList(bool reload) async {
    await Get.find<RestaurantController>().getRestaurantList(reload, offset: 1);
  }

  @override
  State<FavVenues> createState() => _FavVenuesState();
}

class _FavVenuesState extends State<FavVenues> {
  List<Restaurant> favRestaurants = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishListController>(builder: (wishController) {
      favRestaurants = [];
      if (wishController.wishRestList != null &&
          wishController.wishRestList.isNotEmpty) {
        wishController.wishRestList.forEach((element) {
          favRestaurants.add(element.copyWith());
        });
      }
      return RefreshIndicator(
        onRefresh: () async {
          await wishController.getWishList();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              FeaturedVenueView(),
              if (favRestaurants.length > 0)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 6),
                  child: Column(
                    children: [
                      if (favRestaurants.length > 0)
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).cardColor,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'Favorite Venues'.tr,
                                  style: robotoMedium.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              for (int index = 0;
                                  index < favRestaurants.length;
                                  index++)
                                VenuesViewWidget(
                                  restaurant: favRestaurants[index],
                                  tagIndex: index,
                                  cellWidth:
                                      MediaQuery.of(context).size.width * 0.94,
                                )
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
