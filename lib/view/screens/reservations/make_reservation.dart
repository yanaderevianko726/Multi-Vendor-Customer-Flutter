import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/reservation_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/vendor_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/table_model.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/reservations/confirm_pay_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/reserve_complete.dart';
import 'package:efood_multivendor/view/screens/reservations/widgets/choose_foods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'fill_guest_info.dart';
import 'reserve_a_table.dart';
import 'widgets/open_times_view.dart';
import 'widgets/table_cell_widget.dart';

class MakeReservationScreen extends StatefulWidget {
  const MakeReservationScreen({Key key}) : super(key: key);
  @override
  State<MakeReservationScreen> createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  ScrollController _scrollController = ScrollController();
  var selStepIndex = 0;
  var isLoading = false;
  var _date = '', _startTime = '';
  var strGuestName = '', strEmail = '', strPhone = '';
  var strErrorMessage = '';
  var _isLoggedIn = false;

  initPageData() async {
    DateTime _curDate = DateTime.now();
    _date =
        '${_curDate.year}-${_curDate.month < 10 ? '0${_curDate.month}' : _curDate.month}-${_curDate.day < 10 ? '0${_curDate.day}' : _curDate.day}';
    _startTime =
        '${_curDate.hour < 10 ? '0${_curDate.hour}' : _curDate.hour}:${_curDate.minute < 10 ? '0${_curDate.minute}' : _curDate.minute}';
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    setState(() {});
    if (mounted) {
      if (_isLoggedIn) {
        if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
          Get.find<UserController>().getUserInfo().then((value) {
            initReservation();
          });
        } else {
          initReservation();
        }
      }
    }
  }

  void initReservation() {
    Get.find<ReservationController>().initReservation(_date, _startTime);
    Get.find<CartController>().clearCartList();
    Get.find<OrderController>().setPaymentMethod(1); // digital_payment
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPageData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const double mariHorPadding = 10.0;
    return GetBuilder<VendorController>(builder: (vendorController) {
      return GetBuilder<RestaurantController>(
        builder: (restaurantController) {
          BaseUrls baseUrls = Get.find<SplashController>().configModel.baseUrls;
          List<Restaurant> restaurants = [];
          Restaurant selectedVenue = Restaurant();
          Vendor vendor = Vendor();

          if (mounted) {
            if (restaurantController.restaurantModel != null &&
                restaurantController.restaurantModel.restaurants.isNotEmpty) {
              if (vendorController.allVendorList.isNotEmpty) {
                restaurants
                    .addAll(restaurantController.restaurantModel.restaurants);
                if (Get.find<ReservationController>().selVenueIndex == -1 ||
                    Get.find<ReservationController>().selVenueIndex == null) {
                  selectedVenue = restaurants[0];
                  Get.find<ReservationController>().setVenueInfo(
                    selectedVenue,
                  );
                  Get.find<ReservationController>().setVenueIndex(0);
                } else {
                  selectedVenue = restaurants[
                  Get.find<ReservationController>().selVenueIndex];
                  Get.find<ReservationController>().setVenueInfo(
                    selectedVenue,
                  );
                }

                vendor = vendorController.getVendor(selectedVenue.id);
                Get.find<ReservationController>().setVendorInfo(vendor);
              }
            }
          }
          double cellWidth = 160;

          return WillPopScope(
            onWillPop: () async {
              if (selStepIndex > 0) {
                setState(() {
                  strErrorMessage = '';
                  selStepIndex--;
                });
              } else {
                Get.back();
              }
              return false;
            },
            child: GetBuilder<CartController>(builder: (cartController) {
              return Scaffold(
                body: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).viewPadding.top + 60,
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).viewPadding.top,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Colors.grey[Get.isDarkMode ? 800 : 200],
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (selStepIndex > 0) {
                                      setState(() {
                                        strErrorMessage = '';
                                        selStepIndex--;
                                      });
                                    } else {
                                      Get.back();
                                    }
                                  },
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Reserve A Table'.tr,
                                  textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: InkWell(
                                    onTap: () => Get.toNamed(
                                      RouteHelper.getReserveCart(),
                                    ),
                                    child: Badge(
                                      badgeContent: Text(
                                        '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                                        style: robotoRegular.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/image/ic_cart.png',
                                        width: 22,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.PADDING_SIZE_LARGE,
                          ),
                          if (_isLoggedIn && restaurants.isNotEmpty)
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: mariHorPadding,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Text(
                                          'Select a Venue'.tr,
                                          style: robotoMedium.copyWith(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Container(
                                          height: cellWidth + 6,
                                          margin: EdgeInsets.only(top: 12),
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: restaurants.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  if (Get.find<
                                                      ReservationController>()
                                                      .selVenueIndex !=
                                                      index) {
                                                    Get.find<CartController>()
                                                        .clearCartList();
                                                    Get.find<
                                                        ReservationController>()
                                                        .clearTables();
                                                    Get.find<
                                                        ReservationController>()
                                                        .setVenueIndex(index);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  width: cellWidth - 8,
                                                  height: cellWidth * 1.12,
                                                  margin: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey[Get.find<
                                                            ThemeController>()
                                                            .darkTheme
                                                            ? 700
                                                            : 300],
                                                        blurRadius: 3,
                                                        spreadRadius: 1,
                                                      )
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                Dimensions
                                                                    .RADIUS_SMALL,
                                                              ),
                                                            ),
                                                            child: CustomImage(
                                                              image:
                                                              '${baseUrls.restaurantCoverPhotoUrl}'
                                                                  '/${restaurants[index].coverPhoto}',
                                                              width: cellWidth,
                                                              height: 104,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          restaurantController
                                                              .isOpenNow(
                                                            restaurants[index],
                                                          )
                                                              ? SizedBox()
                                                              : NotAvailableWidget(
                                                            isRestaurant:
                                                            true,
                                                          ),
                                                          Positioned(
                                                            top: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL,
                                                            right: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL,
                                                            child: GetBuilder<
                                                                WishListController>(
                                                              builder:
                                                                  (wishController) {
                                                                bool _isWished =
                                                                wishController
                                                                    .wishRestIdList
                                                                    .contains(
                                                                  restaurants[
                                                                  index]
                                                                      .id,
                                                                );
                                                                return Container(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                    Dimensions
                                                                        .PADDING_SIZE_EXTRA_SMALL,
                                                                  ),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .cardColor,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                      Dimensions
                                                                          .RADIUS_SMALL,
                                                                    ),
                                                                  ),
                                                                  child: Icon(
                                                                    _isWished
                                                                        ? Icons
                                                                        .favorite
                                                                        : Icons
                                                                        .favorite_border,
                                                                    size: 15,
                                                                    color: _isWished
                                                                        ? Theme.of(context)
                                                                        .primaryColor
                                                                        : Theme.of(context)
                                                                        .disabledColor,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 8,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                cellWidth,
                                                                child: Text(
                                                                  restaurants[
                                                                  index]
                                                                      .name,
                                                                  style: robotoMedium
                                                                      .copyWith(
                                                                    fontSize:
                                                                    Dimensions
                                                                        .fontSizeSmall,
                                                                  ),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .start,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: Dimensions
                                                                    .PADDING_SIZE_EXTRA_SMALL,
                                                              ),
                                                              RatingBar(
                                                                rating: restaurants[
                                                                index]
                                                                    .avgRating,
                                                                ratingCount:
                                                                restaurants[
                                                                index]
                                                                    .ratingCount,
                                                                size: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(
                                            top: 16,
                                            left: 2,
                                            right: 2,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Venue Info'.tr,
                                                style: robotoMedium.copyWith(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 76,
                                                    height: 76,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(
                                                          40,
                                                        ),
                                                      ),
                                                      child: CustomImage(
                                                        image:
                                                        '${baseUrls.vendorAvatarUrl}'
                                                            '/${vendor.image}',
                                                        width: 76,
                                                        height: 76,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          '${vendor.fName} ${vendor.lName}',
                                                          style: robotoMedium
                                                              .copyWith(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/image/ic_phone_green.png',
                                                              width: 14,
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              '${vendor.phone}',
                                                              style:
                                                              robotoRegular
                                                                  .copyWith(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Container(
                                                          height: 34,
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/image/ic_rentals.png',
                                                                width: 18,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                    left: 12,
                                                                  ),
                                                                  child: Text(
                                                                    '${selectedVenue.address}',
                                                                    style: robotoRegular
                                                                        .copyWith(
                                                                      fontSize:
                                                                      13,
                                                                    ),
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                'Opening Times'.tr,
                                                style: robotoMedium.copyWith(
                                                  fontSize: 16,
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
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(6.0),
                                                  child: Center(
                                                    child: OpenTimesView(
                                                      restaurant: selectedVenue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 32,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (selectedVenue != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext mcontext) =>
                                                    ReserveTableScreen(
                                                      restaurantID:
                                                      '${selectedVenue.id}',
                                                      onClickBack: () {
                                                        setState(() {});
                                                      },
                                                    ),
                                              ),
                                            );
                                          } else {
                                            showCustomSnackBar(
                                              'Please select a venue'.tr,
                                              isError: false,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width,
                                          height: 48,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                            Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/image/ic_table_services.png',
                                                width: 18,
                                                fit: BoxFit.fitWidth,
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                'Reserve A Table'.tr,
                                                style: robotoMedium.copyWith(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      if (Get.find<ReservationController>()
                                          .allTables
                                          .isNotEmpty &&
                                          Get.find<ReservationController>()
                                              .selTableIndex !=
                                              -1)
                                        tableCellUI(
                                          onTap: () {},
                                          selIndex: -1,
                                          currentIndex:
                                          Get.find<ReservationController>()
                                              .selTableIndex,
                                          tableModel: Get.find<
                                              ReservationController>()
                                              .allTables[
                                          Get.find<ReservationController>()
                                              .selTableIndex],
                                          baseUrls: baseUrls,
                                          context: context,
                                        ),
                                      SizedBox(
                                        height: 32,
                                      ),
                                      squareRectangleWidget(
                                        screenWidth,
                                        stepIndex: selStepIndex,
                                        buildContext: context,
                                      ),
                                      if (selStepIndex == 0)
                                        FillGuestInfoScreen(
                                          guestName: strGuestName,
                                          guestEmail: strEmail,
                                          guestPhone: strPhone,
                                          onClickNext: (sn, se, sp) {
                                            strGuestName = sn;
                                            strEmail = se;
                                            strPhone = sp;

                                            setState(() {
                                              selStepIndex++;
                                            });
                                          },
                                        ),
                                      if (selStepIndex == 1)
                                        ChooseFoodsScreen(
                                          restaurant: selectedVenue,
                                          onClickNext: () {
                                            setState(() {
                                              selStepIndex++;
                                            });
                                          },
                                        ),
                                      if (selStepIndex == 2)
                                        ConfirmReservation(
                                          restaurant: selectedVenue,
                                          errorMessage: strErrorMessage,
                                          onClickNext: () {
                                            checkTableAvailable();
                                          },
                                        ),
                                      if (selStepIndex == 3)
                                        ReserveCompleteScreen(),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (_isLoggedIn && restaurants.isEmpty)
                            Expanded(
                              child: Column(
                                children: [
                                  Spacer(),
                                  Image.asset(
                                    'assets/image/ic_venues_yellow.png',
                                    width: 64,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Text(
                                    '${'There are no any venues in your area, trying again ...'.tr}',
                                    style: robotoRegular.copyWith(
                                      fontSize: 16,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 48,
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          if (!_isLoggedIn)
                            Expanded(
                              child: Center(
                                child: Text(
                                  'You have to login to make reservation'.tr,
                                  style: robotoMedium,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    if (isLoading)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black87.withOpacity(0.3),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Processing...',
                                style: robotoMedium.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              );
            }),
          );
        },
      );
    });
  }

  Future<void> setGuestInfo() async {
    if (Get.find<UserController>().userInfoModel.fName == strGuestName &&
        Get.find<UserController>().userInfoModel.phone == strPhone &&
        Get.find<UserController>().userInfoModel.email == strEmail) {
      setState(() {
        selStepIndex++;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      UserInfoModel _updatedUser = UserInfoModel(
        fName: strGuestName,
        lName: Get.find<UserController>().userInfoModel.lName,
        email: strEmail,
        phone: strPhone,
      );
      await Get.find<UserController>()
          .updateUserInfo(
              _updatedUser, Get.find<AuthController>().getUserToken())
          .then((value) {
        setState(() {
          selStepIndex++;
        });
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  void checkTableAvailable() {
    if (Get.find<CartController>().cartList.isNotEmpty) {
      if (Get.find<ReservationController>().selTableIndex == -1) {
        showCustomSnackBar('Please reserve a table.'.tr, isError: false);
      } else {
        TableModel tableModel = Get.find<ReservationController>()
            .allTables[Get.find<ReservationController>().selTableIndex]
            .copyWith();
        var tableAvailable = tableModel.checkProductAvailableTimes(
          '${Get.find<ReservationController>().reservation.reserveDate}',
          '${Get.find<ReservationController>().reservation.startTime}',
          '${Get.find<ReservationController>().reservation.endTime}',
        );
        if (tableAvailable) {
          var checkSchedule = tableModel.checkSchedules(
            '${Get.find<ReservationController>().reservation.reserveDate}',
            '${Get.find<ReservationController>().reservation.startTime}',
            '${Get.find<ReservationController>().reservation.endTime}',
          );
          print('=== checkSchedule: $checkSchedule');
          if (checkSchedule) {
            setState(() {
              isLoading = true;
            });
            uploadOrderData();
          } else {
            showCustomSnackBar(
              'This time already taken, please take another time.'.tr,
            );
          }
        } else {
          showCustomSnackBar(
            'One or more products are no available.'.tr,
          );
        }
      }
    } else {
      showCustomSnackBar('Please select some foods.'.tr);
      setState(() {
        selStepIndex = 1;
      });
    }
  }

  void uploadOrderData() {
    if (Get.find<CartController>().cartList.isNotEmpty) {
      List<CartModel> _cartList = [];
      List<Cart> carts = [];
      _cartList.addAll(Get.find<CartController>().cartList);

      for (int index = 0; index < _cartList.length; index++) {
        CartModel cart = _cartList[index];
        List<int> _addOnIdList = [];
        List<int> _addOnQtyList = [];
        cart.addOnIds.forEach((addOn) {
          _addOnIdList.add(addOn.id);
          _addOnQtyList.add(addOn.quantity);
        });
        carts.add(
          Cart(
            cart.product.id,
            cart.product.id,
            cart.discountedPrice.toString(),
            '',
            cart.variation,
            cart.quantity,
            _addOnIdList,
            cart.addOns,
            _addOnQtyList,
          ),
        );
      }

      if (Get.find<ReservationController>().selVenueIndex != -1) {
        Restaurant _restaurant = Get.find<RestaurantController>()
            .restaurantModel
            .restaurants[Get.find<ReservationController>().selVenueIndex]
            .copyWith();

        Get.find<OrderController>().placeReserveOrder(
          PlaceOrderBody(
            cart: carts,
            couponDiscountAmount: Get.find<CouponController>().discount,
            distance: Get.find<OrderController>().distance,
            couponDiscountTitle: Get.find<CouponController>().discount > 0
                ? Get.find<CouponController>().coupon.title
                : null,
            scheduleAt:
                '${Get.find<ReservationController>().reservation.reserveDate} ${Get.find<ReservationController>().reservation.endTime}:00',
            orderAmount: Get.find<ReservationController>().total,
            orderNote:
                '${Get.find<ReservationController>().reservation.specialNotes}',
            orderType: 'reservation',
            paymentMethod: Get.find<OrderController>().paymentMethodIndex == 0
                ? 'cash_on_delivery'
                : Get.find<OrderController>().paymentMethodIndex == 1
                    ? 'digital_payment'
                    : Get.find<OrderController>().paymentMethodIndex == 2
                        ? 'wallet'
                        : 'digital_payment',
            couponCode: (Get.find<CouponController>().discount > 0 ||
                    (Get.find<CouponController>().coupon != null &&
                        Get.find<CouponController>().freeDelivery))
                ? Get.find<CouponController>().coupon.code
                : null,
            restaurantId: _cartList[0].product.restaurantId,
            addressType: 'other',
            contactPersonName:
                '${Get.find<ReservationController>().reservation.customerName}',
            contactPersonNumber:
                '${Get.find<ReservationController>().reservation.customerPhone}',
            road: '',
            house: '',
            floor: '',
            address: _restaurant.address,
            latitude: _restaurant.latitude,
            longitude: _restaurant.longitude,
            totalTaxAmount: Get.find<ReservationController>().totalTaxAmount,
            serviceCharge: Get.find<ReservationController>().serviceCharge,
            serverTip: Get.find<ReservationController>().serverTip,
            promo: Get.find<ReservationController>().promo,
            serverTipMethod: Get.find<ReservationController>().serverTipMethod,
            dmTips: '0',
            discountAmount: 0,
          ),
          _callback,
          Get.find<ReservationController>().total,
          Get.find<UserController>().userInfoModel.id,
        );
      } else {
        showCustomSnackBar('Please select a venue.'.tr);
      }
    } else {
      showCustomSnackBar('Please select some foods.'.tr);
      setState(() {
        selStepIndex = 1;
        isLoading = false;
      });
    }
  }

  void _callback(
    bool isSuccess,
    String message,
    String orderID,
    double amount,
  ) async {
    print('=== orderCreated: $isSuccess');
    if (isSuccess) {
      Get.find<ReservationController>().setOrderData(orderID, amount);
      TableModel tableModel = Get.find<ReservationController>()
          .allTables[Get.find<ReservationController>().selTableIndex]
          .copyWith();
      TableSchedule tableSchedule = TableSchedule(
        reserveDate:
            '${Get.find<ReservationController>().reservation.reserveDate}',
        startTime: '${Get.find<ReservationController>().reservation.startTime}',
        endTime: '${Get.find<ReservationController>().reservation.endTime}',
      );
      if (tableModel.schedules == null || tableModel.schedules.length == 0) {
        tableModel.schedules = [];
        tableModel.schedules.add(tableSchedule);
      } else {
        tableModel.schedules.add(tableSchedule);
      }
      Get.find<ReservationController>()
          .updateTable(tableModel)
          .then((value) async {
        if (value.isSuccess) {
          setState(() {
            selStepIndex++;
            isLoading = false;
          });

          Get.find<CartController>().clearCartList();
          Get.find<CouponController>().removeCouponData(false);

          Get.find<ReservationController>().setPaymentStatus('unpaid');
          Get.find<ReservationController>().postReservation().then((value) {
            Get.offNamed(
              RouteHelper.getPaymentReserveRoute(
                orderID,
                Get.find<UserController>().userInfoModel.id,
                amount,
              ),
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showCustomSnackBar(value.message);
        }
      });
    } else {
      setState(() {
        isLoading = false;
        strErrorMessage = message;
      });
    }
  }
}

Widget squareRectangleWidget(
  double screenWidth, {
  String title = '',
  String topTitle = '',
  int stepIndex = 0,
  BuildContext buildContext,
}) {
  double dotLineWidth = 52;
  return Container(
    width: screenWidth,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 30,
              child: Center(
                child: Text(
                  '${stepTitles[0]}',
                  style: robotoMedium.copyWith(
                    fontSize: 12,
                    color: stepIndex == 0
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Container(
              width: 64,
              height: 30,
              child: Center(
                child: Text(
                  '${stepTitles[1]}',
                  style: robotoMedium.copyWith(
                    fontSize: 12,
                    color: stepIndex == 1
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Container(
              width: 64,
              height: 30,
              child: Center(
                child: Text(
                  '${stepTitles[2]}',
                  style: robotoMedium.copyWith(
                    fontSize: 12,
                    color: stepIndex == 2
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Container(
              width: 64,
              height: 30,
              child: Center(
                child: Text(
                  '${stepTitles[3]}',
                  style: robotoMedium.copyWith(
                    fontSize: 12,
                    color: stepIndex == 3
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(
                  width: 1,
                  color: stepIndex == 0
                      ? Theme.of(buildContext).primaryColor
                      : Theme.of(buildContext).disabledColor,
                ),
              ),
              child: Center(
                child: Text(
                  '1',
                  style: robotoMedium.copyWith(
                    fontSize: 16,
                    color: stepIndex == 0
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: dotLineWidth,
              child: DottedLine(
                dashColor: Theme.of(buildContext).disabledColor,
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(
                  width: 1,
                  color: stepIndex == 1
                      ? Theme.of(buildContext).primaryColor
                      : Theme.of(buildContext).disabledColor,
                ),
              ),
              child: Center(
                child: Text(
                  '2',
                  style: robotoMedium.copyWith(
                    fontSize: 16,
                    color: stepIndex == 1
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: dotLineWidth,
              child: DottedLine(
                dashColor: Theme.of(buildContext).disabledColor,
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(
                  width: 1,
                  color: stepIndex == 2
                      ? Theme.of(buildContext).primaryColor
                      : Theme.of(buildContext).disabledColor,
                ),
              ),
              child: Center(
                child: Text(
                  '3',
                  style: robotoMedium.copyWith(
                    fontSize: 16,
                    color: stepIndex == 2
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: dotLineWidth,
              child: DottedLine(
                dashColor: Theme.of(buildContext).disabledColor,
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(
                  width: 1,
                  color: stepIndex == 3
                      ? Theme.of(buildContext).primaryColor
                      : Theme.of(buildContext).disabledColor,
                ),
              ),
              child: Center(
                child: Text(
                  '4',
                  style: robotoMedium.copyWith(
                    fontSize: 16,
                    color: stepIndex == 3
                        ? Theme.of(buildContext).primaryColor
                        : Theme.of(buildContext).disabledColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
      ],
    ),
  );
}

var stepTitles = [
  'Fill in Date & Time',
  'Choose Food',
  'Confirm & Pay',
  'Reservation Complete',
];
