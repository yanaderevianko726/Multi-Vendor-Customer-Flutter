import 'dart:collection';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/reservations/widgets/open_times_view.dart';
import 'package:efood_multivendor/view/screens/restaurant/reserve_places_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RestaurantDescriptionView extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantDescriptionView({
    @required this.restaurant,
  });
  @override
  State<RestaurantDescriptionView> createState() =>
      _RestaurantDescriptionViewState();
}

class _RestaurantDescriptionViewState extends State<RestaurantDescriptionView> {
  GoogleMapController _controller;
  Set<Marker> _markers = HashSet<Marker>();

  @override
  void initState() {
    super.initState();
    Get.find<RestaurantController>().getRestaurantReviewList(
      '${widget.restaurant.id}',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return GetBuilder<LocationController>(builder: (locationController) {
        List<ReviewModel> reviewList = [];
        if (restaurantController.restaurantReviewList != null &&
            restaurantController.restaurantReviewList.isNotEmpty) {
          for (int i = 0; i < 5; i++) {
            if (i < restaurantController.restaurantReviewList.length) {
              reviewList.add(
                restaurantController.restaurantReviewList[i],
              );
            }
          }
        }

        Color _textColor =
            ResponsiveHelper.isDesktop(context) ? Colors.white : null;
        double halfWidth = (MediaQuery.of(context).size.width - 40) / 2 + 8;

        List<Widget> dollars = [];
        dollars.add(
          SizedBox(
            width: 4,
          ),
        );
        for (int i = 0; i < 4; i++) {
          if (i < 2) {
            dollars.add(Text(
              '\$',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue,
              ),
            ));
          } else {
            dollars.add(
              Text(
                '\$',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            );
          }
        }

        var strDistance = 'calculating'.tr;
        double _distance = 0;
        var curLat = locationController.getUserAddress().latitude;
        var curLong = locationController.getUserAddress().longitude;
        if (curLat != null && widget.restaurant.latitude != null) {
          _distance = Geolocator.distanceBetween(
            double.parse(curLat),
            double.parse(curLong),
            double.parse(widget.restaurant.latitude),
            double.parse(widget.restaurant.longitude),
          );

          if (_distance < 1000) {
            strDistance = '${_distance.toStringAsFixed(0)} m ${'away'.tr}';
          } else if (_distance < 1610) {
            _distance /= 1000;
            strDistance = '${_distance.toStringAsFixed(1)} Kms ${'away'.tr}';
          } else {
            _distance /= 1852;
            strDistance = '${_distance.toStringAsFixed(0)} Miles ${'away'.tr}';
          }
        }

        var chefName = '';
        if (Get.find<VendorController>().allVendorList != null &&
            Get.find<VendorController>().allVendorList.isNotEmpty) {
          Get.find<VendorController>().allVendorList.forEach((vendor) {
            if (vendor.id == widget.restaurant.vendorId) {
              chefName = '${vendor.fName} ${vendor.lName}';
            }
          });
        }

        var cuisineName = '';
        if (Get.find<CuisineController>().cuisinesList != null &&
            Get.find<CuisineController>().cuisinesList.isNotEmpty) {
          Get.find<CuisineController>().cuisinesList.forEach((cuisine) {
            if (cuisine.id == widget.restaurant.cuisineId) {
              cuisineName = '${cuisine.name}';
            }
          });
        }

        _markers = HashSet<Marker>();
        _markers.add(
          Marker(
            markerId: MarkerId('restaurant'),
            position: LatLng(
              double.parse(widget.restaurant.latitude),
              double.parse(widget.restaurant.longitude),
            ),
            infoWindow: InfoWindow(
              title: '${widget.restaurant.name}',
              snippet: '${widget.restaurant.address}',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );

        return Column(
          children: [
            Row(
              children: [
                if (widget.restaurant.venueType == 1)
                  Image.asset(
                    'assets/image/ic_award.png',
                    width: 18,
                    fit: BoxFit.fitWidth,
                    color: yellowDark,
                  ),
                if (widget.restaurant.venueType == 1)
                  SizedBox(
                    width: 6,
                  ),
                Text(
                  widget.restaurant.name,
                  style: robotoMedium.copyWith(
                    fontSize: 18,
                    color: _textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    String url =
                        'https://www.google.com/maps/dir/?api=1&destination=${widget.restaurant.latitude}'
                        ',${widget.restaurant.longitude}&mode=d';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      showCustomSnackBar('unable_to_launch_google_map'.tr);
                    }
                  },
                  icon: Icon(Icons.directions),
                  label: Text('direction'.tr),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '$chefName ',
                    style: robotoMedium.copyWith(
                      fontSize: 15,
                      color: yellowDark.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      '$cuisineName',
                      style: robotoMedium.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      width: 68,
                      height: 50,
                      decoration: BoxDecoration(
                        color: orangeLight,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Image.asset(
                                'assets/image/ic_delivery_black.png',
                                color: Colors.white,
                                width: 20,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'delivery'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      width: 68,
                      height: 50,
                      decoration: BoxDecoration(
                        color: orangeLight,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Image.asset(
                                'assets/image/ic_blubs.png',
                                color: Colors.white,
                                width: 20,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Pick-Up'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      width: 68,
                      height: 50,
                      decoration: BoxDecoration(
                        color: orangeLight,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Image.asset(
                                  'assets/image/ic_denein.png',
                                  color: Colors.white,
                                  width: 17,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Dine-In'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      width: 68,
                      height: 50,
                      decoration: BoxDecoration(
                        color: orangeLight,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Image.asset(
                                  'assets/image/ic_table_services.png',
                                  color: Colors.white,
                                  width: 20,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Table Service'.tr,
                            style: robotoRegular.copyWith(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    width: halfWidth,
                    child: Row(children: [
                      Icon(
                        Icons.star,
                        color: yellowDark,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${widget.restaurant.avgRating.toStringAsFixed(1)}/5 (${widget.restaurant.ratingCount} Reviews)',
                        style: robotoRegular.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: dollars,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    width: halfWidth,
                    child: Row(children: [
                      Icon(
                        Icons.timer,
                        color: yellowDark,
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '${widget.restaurant.deliveryTime} ${'min'.tr} (Delivery Time)',
                        style: robotoRegular.copyWith(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/image/ic_distance.png',
                          width: 15,
                          fit: BoxFit.fitWidth,
                          color: yellowDark,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '$strDistance',
                          style: robotoRegular.copyWith(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Opening Times'.tr,
                style: robotoMedium.copyWith(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            DottedBorder(
              color: yellowLight,
              strokeWidth: 1,
              strokeCap: StrokeCap.butt,
              dashPattern: [8, 5],
              borderType: BorderType.RRect,
              radius: Radius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6.0),
                color: Theme.of(context).disabledColor.withOpacity(0.2),
                child: Center(
                  child: OpenTimesView(
                    restaurant: widget.restaurant,
                  ),
                ),
              ),
            ),
            (restaurantController.categoryList.length > 1)
                ? Column(
                    children: [
                      SizedBox(
                        height: 28,
                      ),
                      Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        height: 22,
                        child: Text(
                          'Categories'.tr,
                          style: robotoMedium.copyWith(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        height: 84,
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.zero,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restaurantController.categoryList.length,
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return index > 0
                                ? InkWell(
                                    onTap: () {
                                      restaurantController
                                          .setCategoryIndex(index);
                                      Get.toNamed(
                                        RouteHelper.getVenueFoodsRoute(
                                          '${widget.restaurant.id}',
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 72,
                                      height: 84,
                                      margin: EdgeInsets.all(3),
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(6),
                                            ),
                                            color: Theme.of(context).cardColor,
                                          ),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: CustomImage(
                                                  image:
                                                      '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${restaurantController.categoryList[index].image}',
                                                  width: 72,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                ),
                                                child: Text(
                                                  restaurantController
                                                      .categoryList[index].name,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: 11,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .color,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      restaurantController.setCategoryIndex(0);
                      Get.toNamed(
                        RouteHelper.getVenueFoodsRoute(
                          '${widget.restaurant.id}',
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: 52,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image/ic_menu_book.png',
                            width: 15,
                            fit: BoxFit.fitWidth,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Menu'.tr,
                            style: robotoBold.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getReservePlaces(),
                        arguments: ReservePlacesScreen(
                          restaurant: widget.restaurant,
                        ),
                      );
                      // Get.toNamed(
                      //   RouteHelper.getReserveAPlace(),
                      //   arguments: MakeReserveAPlaceScreen(
                      //     restaurant: widget.restaurant,
                      //   ),
                      // );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Reserve A Place'.tr,
                          style: robotoBold.copyWith(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      if (await canLaunchUrlString(
                          'tel:${widget.restaurant.phone}')) {
                        launchUrlString('tel:${widget.restaurant.phone}',
                            mode: LaunchMode.externalApplication);
                      } else {
                        showCustomSnackBar(
                            '${'can_not_launch'.tr} ${widget.restaurant.phone}');
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.68,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: blueDeep,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image/ic_phone_green.png',
                            width: 18,
                            fit: BoxFit.fitWidth,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            '${widget.restaurant.phone}',
                            style: robotoMedium.copyWith(
                              fontSize: 16,
                              color: blueDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 56,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/image/ic_whatsapp.png',
                        width: 36,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Location'.tr,
                style: robotoMedium.copyWith(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Image.asset(
                  'assets/image/ic_location.png',
                  width: 14,
                  fit: BoxFit.fitWidth,
                  color: Theme.of(context).disabledColor,
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Get.toNamed(
                      RouteHelper.getMapRoute(
                        AddressModel(
                          id: widget.restaurant.id,
                          address: widget.restaurant.address,
                          latitude: widget.restaurant.latitude,
                          longitude: widget.restaurant.longitude,
                          contactPersonNumber: '',
                          contactPersonName: '',
                          addressType: '',
                        ),
                        'restaurant',
                      ),
                    ),
                    child: Text(
                      '${widget.restaurant.address}',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).disabledColor,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 280,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(widget.restaurant.latitude),
                    double.parse(widget.restaurant.longitude),
                  ),
                  zoom: 16,
                ),
                // minMaxZoomPreference: MinMaxZoomPreference(0, 20),
                zoomControlsEnabled: true,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  setMarker(
                    widget.restaurant,
                    AddressModel(
                      latitude: widget.restaurant.latitude.toString(),
                      longitude: widget.restaurant.longitude.toString(),
                      address: Get.find<LocationController>().address,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 24,
              margin: EdgeInsets.only(
                top: 18,
              ),
              child: Row(
                children: [
                  Text(
                    'Reviews & Ratings (${widget.restaurant.ratingCount} Reviews)',
                    style: robotoMedium.copyWith(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getRestaurantReviewRoute(
                          widget.restaurant.id,
                        ),
                      );
                    },
                    child: Container(
                      width: 64,
                      height: 32,
                      child: Center(
                        child: Text(
                          'View All',
                          style: robotoMedium.copyWith(
                            fontSize: 13,
                            color: yellowDark,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
            if (reviewList.isNotEmpty)
              RefreshIndicator(
                onRefresh: () async {
                  await restaurantController.getRestaurantReviewList(
                    '${widget.restaurant.id}',
                  );
                },
                child: SingleChildScrollView(
                  child: ListView.builder(
                    key: UniqueKey(),
                    controller: scrollController,
                    itemCount: reviewList.length > 5 ? 5 : reviewList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var createdAt = '';
                      if (reviewList[index].createdAt != null) {
                        createdAt = reviewList[index].createdAt.split('T')[0];
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: CustomImage(
                                        image:
                                            '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${reviewList[index].foodImage ?? ''}',
                                        height: 52,
                                        width: 52,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reviewList[index].customerName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoBold.copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 1.0,
                                                ),
                                                child: RatingBar(
                                                  rating: reviewList[index]
                                                      .rating
                                                      .toDouble(),
                                                  ratingCount: null,
                                                  size: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 1,
                                                ),
                                                child: Text(
                                                  '$createdAt',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 6,
                                    top: 10,
                                  ),
                                  child: DottedLine(
                                    dashColor: Theme.of(context).disabledColor,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                    left: 18.0,
                                    top: 8,
                                    right: 18,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    reviewList[index].comment,
                                    style: robotoRegular.copyWith(
                                      fontSize: 12,
                                      color: Colors.black87.withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.start,
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
        );
      });
    });
  }

  void setMarker(Restaurant restaurant, AddressModel addressModel) async {
    print('=== setMarker:');
    try {
      Uint8List restaurantImageData = await convertAssetToUnit8List(
          'assets/image/ic_venues_red.png',
          width: 100);
      // Animate to coordinate
      LatLngBounds bounds;
      if (_controller != null) {
        if (double.parse(addressModel.latitude) <
            double.parse(restaurant.latitude)) {
          bounds = LatLngBounds(
            southwest: LatLng(
              double.parse(addressModel.latitude),
              double.parse(addressModel.longitude),
            ),
            northeast: LatLng(
              double.parse(restaurant.latitude),
              double.parse(restaurant.longitude),
            ),
          );
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(restaurant.latitude),
                double.parse(restaurant.longitude)),
            northeast: LatLng(double.parse(addressModel.latitude),
                double.parse(addressModel.longitude)),
          );
        }
      }
      LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );

      _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: centerBounds,
            zoom: GetPlatform.isWeb ? 10 : 17,
          ),
        ),
      );
      zoomToFit(_controller, bounds, centerBounds, padding: 1.5);
      print('=== setMarker:');

      _markers = HashSet<Marker>();
      _markers.add(
        Marker(
          markerId: MarkerId('restaurant'),
          position: LatLng(
            double.parse(restaurant.latitude),
            double.parse(restaurant.longitude),
          ),
          infoWindow: InfoWindow(
            title: 'restaurant'.tr,
            snippet: restaurant.address,
          ),
          icon: BitmapDescriptor.fromBytes(restaurantImageData),
        ),
      );
    } catch (e) {}
    setState(() {});
  }

  Future<void> zoomToFit(
    GoogleMapController controller,
    LatLngBounds bounds,
    LatLng centerBounds, {
    double padding = 0.5,
  }) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if (fits(bounds, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;
    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;
    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
