import 'dart:convert';

import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/html_type.dart';
import 'package:efood_multivendor/view/base/image_viewer_screen.dart';
import 'package:efood_multivendor/view/base/not_found.dart';
import 'package:efood_multivendor/view/base/settings_page.dart';
import 'package:efood_multivendor/view/screens/address/add_address_screen.dart';
import 'package:efood_multivendor/view/screens/address/address_information.dart';
import 'package:efood_multivendor/view/screens/auth/phone_entery_screen.dart';
import 'package:efood_multivendor/view/screens/auth/sign_in_screen.dart';
import 'package:efood_multivendor/view/screens/auth/sign_up_screen.dart';
import 'package:efood_multivendor/view/screens/cart/cart_screen.dart';
import 'package:efood_multivendor/view/screens/category/category_product_screen.dart';
import 'package:efood_multivendor/view/screens/category/category_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/checkout_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/order_successful_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/payment_screen.dart';
import 'package:efood_multivendor/view/screens/chefs/all_featured_chefs.dart';
import 'package:efood_multivendor/view/screens/chefs/celeb_chefs_screen.dart';
import 'package:efood_multivendor/view/screens/chefs/chefs_screen.dart';
import 'package:efood_multivendor/view/screens/coupon/coupon_screen.dart';
import 'package:efood_multivendor/view/screens/cuisines/cuisine_product_screen.dart';
import 'package:efood_multivendor/view/screens/cuisines/cuisine_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:efood_multivendor/view/screens/food/item_campaign_screen.dart';
import 'package:efood_multivendor/view/screens/food/popular_food_screen.dart';
import 'package:efood_multivendor/view/screens/forget/forget_pass_screen.dart';
import 'package:efood_multivendor/view/screens/forget/new_pass_screen.dart';
import 'package:efood_multivendor/view/screens/forget/verification_screen.dart';
import 'package:efood_multivendor/view/screens/guest/guest_entry_screen.dart';
import 'package:efood_multivendor/view/screens/html/html_viewer_screen.dart';
import 'package:efood_multivendor/view/screens/interest/interest_screen.dart';
import 'package:efood_multivendor/view/screens/language/country_screen.dart';
import 'package:efood_multivendor/view/screens/language/language_screen.dart';
import 'package:efood_multivendor/view/screens/location/access_location_screen.dart';
import 'package:efood_multivendor/view/screens/location/map_screen.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/notification/notification_screen.dart';
import 'package:efood_multivendor/view/screens/onboard/onboarding_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_details_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_tracking_screen.dart';
import 'package:efood_multivendor/view/screens/payment_details/credit_card_view.dart';
import 'package:efood_multivendor/view/screens/payment_details/payment_details_screen.dart';
import 'package:efood_multivendor/view/screens/profile/profile_screen.dart';
import 'package:efood_multivendor/view/screens/profile/update_profile_screen.dart';
import 'package:efood_multivendor/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/make_reservation.dart';
import 'package:efood_multivendor/view/screens/reservations/payment_reserve_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/payment_track_reserve_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/reservation_details_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/reservation_screen.dart';
import 'package:efood_multivendor/view/screens/reservations/reserve_a_table.dart';
import 'package:efood_multivendor/view/screens/reservations/reserve_complete.dart';
import 'package:efood_multivendor/view/screens/reservations/widgets/reserve_cart_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/campaign_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_product_search_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/review_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/venue_product_page.dart';
import 'package:efood_multivendor/view/screens/search/search_screen.dart';
import 'package:efood_multivendor/view/screens/splash/splash_screen.dart';
import 'package:efood_multivendor/view/screens/support/support_screen.dart';
import 'package:efood_multivendor/view/screens/swushd_premium/swushd_venues_screen.dart';
import 'package:efood_multivendor/view/screens/update/update_screen.dart';
import 'package:efood_multivendor/view/screens/venues/all_featured_venues.dart';
import 'package:efood_multivendor/view/screens/venues/venues_screen.dart';
import 'package:efood_multivendor/view/screens/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/base/sign_in_root.dart';
import '../view/screens/favourite/favourite_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String country = '/country-setting';
  static const String onBoarding = '/on-boarding';
  static const String signInRoot = '/sign-in-root';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String phoneEntry = '/entry-phone';
  static const String verification = '/verification';
  static const String accessLocation = '/access-location';
  static const String guestSigninPage = '/guest-signin';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String search = '/search';
  static const String restaurant = '/restaurant';
  static const String orderDetails = '/order-details';
  static const String reserveDetails = '/reserve-details';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String reservations = '/reservations';
  static const String trackReservations = '/track-reservations';
  static const String reserveATable = '/reserve-a-table';
  static const String reserveAPlace = '/reserve-a-place';
  static const String reservePlaces = '/reserve-places';
  static const String reserveComplete = '/reserve-complete';
  static const String makeReservation = '/make-reservation';
  static const String updateProfile = '/update-profile';
  static const String coupon = '/coupon';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String addressInformation = '/address-information';
  static const String paymentDetails = '/payment-details';
  static const String creditCard = '/credit-card';
  static const String orderSuccess = '/order-successful';
  static const String payment = '/payment';
  static const String payment_reserve = '/payment-reserve';
  static const String payment_track_reserve = '/payment-track-reserve';
  static const String checkout = '/checkout';
  static const String orderTracking = '/track-order';
  static const String basicCampaign = '/basic-campaign';
  static const String html = '/html';
  static const String categories = '/categories';
  static const String cuisines = '/cuisines';
  static const String categoryProduct = '/category-product';
  static const String cuisineProduct = '/cuisine-product';
  static const String popularFoods = '/popular-foods';
  static const String venueFoods = '/venue-foods';
  static const String itemCampaign = '/item-campaign';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String reserveCart = '/reserve-cart';
  static const String chefs = '/chefs';
  static const String featuredChefsAll = '/featured-chefs-all';
  static const String featuredVenuesAll = '/featured-venues-all';
  static const String celebChefs = '/celebChefs';
  static const String venues = '/venues';
  static const String swushdVenues = '/swushd-venues';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String restaurantReview = '/restaurant-review';
  static const String allRestaurants = '/restaurants';
  static const String wallet = '/wallet';
  static const String searchRestaurantItem = '/search-Restaurant-item';
  static const String productImages = '/product-images';
  static const String referAndEarn = '/refer-and-earn';

  static const String home = 'home';

  static String getInitialRoute() => '$initial';

  static String getSplashRoute(int orderID) => '$splash?id=$orderID';

  static String getLanguageRoute(String page) => '$language?page=$page';

  static String getCountryRoute(String page) => '$country?page=$page';

  static String getOnBoardingRoute() => '$onBoarding';

  static String getSignInRootRoute() => '$signInRoot';

  static String getSignInRoute(String page) => '$signIn?page=$page';

  static String getSignUpRoute() => '$signUp';

  static String getVerificationRoute(
    String number,
    String token,
    String page,
    String pass,
  ) {
    return '$verification?page=$page&number=$number&token=$token&pass=$pass';
  }

  static String getEntryPhoneRoute(
    String strFName,
    String strLName,
    String strEmail,
    String strPassword,
    String strReferCode,
  ) {
    return '$phoneEntry?fName=$strFName&lName=$strLName&sEmail=$strEmail&sPass=$strPassword&referCode=$strReferCode';
  }

  static String getAccessLocationRoute(String page) =>
      '$accessLocation?page=$page';

  static String getGuestSignin() => '$guestSigninPage';

  static String getPickMapRoute(String page, bool canRoute) =>
      '$pickMap?page=$page&route=${canRoute.toString()}';

  static String getInterestRoute() => '$interest';

  static String getMainRoute(String page) => '$main?page=$page';

  static String getForgotPassRoute(
    bool fromSocialLogin,
    SocialLogInBody socialLogInBody,
  ) {
    String _data;
    if (fromSocialLogin) {
      _data = base64Encode(utf8.encode(jsonEncode(socialLogInBody.toJson())));
    }
    return '$forgotPassword?page=${fromSocialLogin ? 'social-login' : 'forgot-password'}&data=${fromSocialLogin ? _data : 'null'}';
  }

  static String getResetPasswordRoute(
    String phone,
    String token,
    String page,
  ) =>
      '$resetPassword?phone=$phone&token=$token&page=$page';

  static String getSearchRoute() => '$search';

  static String getRestaurantRoute(int id) => '$restaurant?id=$id';

  static String getOrderDetailsRoute(int orderID) {
    return '$orderDetails?id=$orderID';
  }

  static String getReserveDetailsRoute(int orderID) {
    return '$reserveDetails?id=$orderID';
  }

  static String getProfileRoute() => '$profile';

  static String getFavoritesRoute(String fromNav) => '$favorites?page=$fromNav';

  static String getReservations(String fromNav) =>
      '$reservations?page=$fromNav';

  static String getTrackReservations() => '$trackReservations';

  static String getReserveATable(String restaurantId) =>
      '$reserveATable?page=$restaurantId';

  static String getReserveAPlace() => '$reserveAPlace';

  static String getReservePlaces() => '$reservePlaces';

  static String getSettingsRoute() => '$settings';

  static String getMakeReservation() => '$makeReservation';

  static String getUpdateProfileRoute() => '$updateProfile';

  static String getCouponRoute() => '$coupon';

  static String getNotificationRoute() => '$notification';

  static String getMapRoute(
    AddressModel addressModel,
    String page,
  ) {
    List<int> _encoded = utf8.encode(
      jsonEncode(
        addressModel.toJson(),
      ),
    );
    String _data = base64Encode(_encoded);
    return '$map?address=$_data&page=$page';
  }

  static String getAddressInfoRoute() => '$addressInformation';

  static String getPaymentDetails() => '$paymentDetails';

  static String getCreditCardView() => '$creditCard';

  static String getOrderSuccessRoute(
    String orderID,
    String status,
    double amount,
  ) =>
      '$orderSuccess?id=$orderID&status=$status&amount=$amount';

  static String getPaymentRoute(
    String id,
    int user,
    double amount,
  ) =>
      '$payment?id=$id&user=$user&amount=$amount';

  static String getPaymentReserveRoute(
    String id,
    int user,
    double amount,
  ) =>
      '$payment_reserve?id=$id&user=$user&amount=$amount';

  static String getPaymentTrackReserveRoute(
    String id,
    int user,
    double amount,
  ) =>
      '$payment_track_reserve?id=$id&user=$user&amount=$amount';

  static String getCheckoutRoute(String page, int orderType) =>
      '$checkout?page=$page&orderType=$orderType';

  static String getReserveCompleteRoute() => '$reserveComplete';

  static String getOrderTrackingRoute(int id) => '$orderTracking?id=$id';

  static String getBasicCampaignRoute(BasicCampaignModel basicCampaignModel) {
    String _data = base64Encode(
      utf8.encode(
        jsonEncode(
          basicCampaignModel.toJson(),
        ),
      ),
    );
    return '$basicCampaign?data=$_data';
  }

  static String getHtmlRoute(String page) => '$html?page=$page';

  static String getCategoryRoute() => '$categories';

  static String getCuisinesRoute() => '$cuisines';

  static String getCategoryProductRoute(int id, String name) {
    List<int> _encoded = utf8.encode(name);
    String _data = base64Encode(_encoded);
    return '$categoryProduct?id=$id&name=$_data';
  }

  static String getCuisineProductRoute(int id, String name) {
    List<int> _encoded = utf8.encode(name);
    String _data = base64Encode(_encoded);
    return '$cuisineProduct?id=$id&name=$_data';
  }

  static String getPopularFoodRoute(bool isPopular) =>
      '$popularFoods?page=${'reviewed'}';

  static String getVenueFoodsRoute(String venueId) =>
      '$venueFoods?page=$venueId';

  static String getItemCampaignRoute() => '$itemCampaign';

  static String getSupportRoute() => '$support';

  static String getReviewRoute() => '$rateReview';

  static String getUpdateRoute(bool isUpdate) =>
      '$update?update=${isUpdate.toString()}';

  static String getCartRoute() => '$cart';

  static String getReserveCart() => '$reserveCart';

  static String getChefsRoute(String fromNav) => '$chefs?page=$fromNav';

  static String getFeaturedChefsAll() => '$featuredChefsAll';

  static String getFeaturedVenuesAll() => '$featuredVenuesAll';

  static String getCelebChefsRoute(String fromNav) =>
      '$celebChefs?page=$fromNav';

  static String getVenuesRoute(String fromNav) => '$venues?page=$fromNav';

  static String getSwushdVenuesRoute(String fromNav) =>
      '$swushdVenues?page=$fromNav';

  static String getAddAddressRoute(bool fromCheckout) =>
      '$addAddress?page=${fromCheckout ? 'checkout' : 'address'}';

  static String getEditAddressRoute(AddressModel address) {
    String _data = base64Url.encode(
      utf8.encode(
        jsonEncode(
          address.toJson(),
        ),
      ),
    );
    return '$editAddress?data=$_data';
  }

  static String getRestaurantReviewRoute(int restaurantID) =>
      '$restaurantReview?id=$restaurantID';

  static String getAllRestaurantRoute() => '$allRestaurants';

  static String getWalletRoute(bool fromWallet, String fromNav) =>
      '$wallet?page=${fromWallet ? 'wallet' : 'loyalty_points'}&fromNav=$fromNav}';

  static String getSearchRestaurantProductRoute(int productID) =>
      '$searchRestaurantItem?id=$productID';

  static String getItemImagesRoute(Product product) {
    String _data = base64Url.encode(
      utf8.encode(
        jsonEncode(
          product.toJson(),
        ),
      ),
    );
    return '$productImages?item=$_data';
  }

  static String getReferAndEarnRoute() => '$referAndEarn';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => DashboardScreen(pageIndex: 2),
    ),
    GetPage(
      name: splash,
      page: () => SplashScreen(
        orderID: Get.parameters['id'] == 'null' ? null : Get.parameters['id'],
      ),
    ),
    GetPage(
      name: language,
      page: () => ChooseLanguageScreen(
        fromMenu: Get.parameters['page'] == 'menu',
      ),
    ),
    GetPage(
      name: country,
      page: () => CountryScreen(fromMenu: Get.parameters['page'] == 'menu'),
    ),
    GetPage(
      name: onBoarding,
      page: () => OnBoardingScreen(),
    ),
    GetPage(
      name: signInRoot,
      page: () => SignInRootScreen(),
    ),
    GetPage(
      name: signIn,
      page: () => SignInScreen(
        pageString: Get.parameters['page'],
      ),
    ),
    GetPage(
      name: signUp,
      page: () => SignUpScreen(),
    ),
    GetPage(
        name: verification,
        page: () {
          List<int> _decode = base64Decode(
            Get.parameters['pass'].replaceAll(' ', '+'),
          );
          String _data = utf8.decode(_decode);
          return VerificationScreen(
            number: Get.parameters['number'],
            fromPhoneEntry: Get.parameters['page'] == phoneEntry,
            token: Get.parameters['token'],
            password: _data,
          );
        }),
    GetPage(
        name: phoneEntry,
        page: () {
          return PhoneEntryScreen(
            sFName: Get.parameters['fName'],
            sLName: Get.parameters['lName'],
            sEmail: Get.parameters['sEmail'],
            sPass: Get.parameters['sPass'],
            sReferCode: Get.parameters['referCode'],
          );
        }),
    GetPage(
      name: accessLocation,
      page: () => AccessLocationScreen(
        fromVerifyPhone: Get.parameters['page'] == verification,
        fromHome: Get.parameters['page'] == home,
        route: null,
      ),
    ),
    GetPage(
      name: guestSigninPage,
      page: () => GuestEntryScreen(),
    ),
    GetPage(
        name: pickMap,
        page: () {
          PickMapScreen _pickMapScreen = Get.arguments;
          bool _fromAddress = Get.parameters['page'] == 'add-address';
          return (_fromAddress && _pickMapScreen == null)
              ? NotFound()
              : _pickMapScreen != null
                  ? _pickMapScreen
                  : PickMapScreen(
                      fromSignUp: Get.parameters['page'] == signUp,
                      fromAddAddress: _fromAddress,
                      route: Get.parameters['page'],
                      canRoute: Get.parameters['route'] == 'true',
                    );
        }),
    GetPage(
      name: interest,
      page: () => InterestScreen(),
    ),
    GetPage(
      name: main,
      page: () => DashboardScreen(
        pageIndex: Get.parameters['page'] == home
            ? 2
            : Get.parameters['page'] == 'favourite'
                ? 1
                : Get.parameters['page'] == 'cart'
                    ? 0
                    : Get.parameters['page'] == 'order'
                        ? 3
                        : Get.parameters['page'] == 'menu'
                            ? 4
                            : 0,
      ),
    ),
    GetPage(
        name: forgotPassword,
        page: () {
          SocialLogInBody _data;
          if (Get.parameters['page'] == 'social-login') {
            List<int> _decode =
                base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
            _data = SocialLogInBody.fromJson(
              jsonDecode(
                utf8.decode(_decode),
              ),
            );
          }
          return ForgetPassScreen(
            fromSocialLogin: Get.parameters['page'] == 'social-login',
            socialLogInBody: _data,
          );
        }),
    GetPage(
      name: resetPassword,
      page: () => NewPassScreen(
        resetToken: Get.parameters['token'],
        number: Get.parameters['phone'],
        fromPasswordChange: Get.parameters['page'] == 'password-change',
      ),
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: restaurant,
      page: () {
        return Get.arguments != null
            ? Get.arguments
            : RestaurantScreen(
                restaurant: Restaurant(
                  id: int.parse(
                    Get.parameters['id'],
                  ),
                ),
              );
      },
    ),
    GetPage(
      name: orderDetails,
      page: () {
        return Get.arguments != null
            ? Get.arguments
            : OrderDetailsScreen(
                orderId: int.parse(Get.parameters['id'] ?? '0'),
                orderModel: null,
              );
      },
    ),
    GetPage(
      name: reserveDetails,
      page: () {
        return Get.arguments != null
            ? Get.arguments
            : ReserveDetailsScreen(
                orderModel: null,
              );
      },
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: reservations,
      page: () => ReservationScreen(
        fromNav: Get.parameters['page'] == 'fromNav',
      ),
    ),
    GetPage(
      name: trackReservations,
      page: () => Get.arguments != null ? Get.arguments : NotFound(),
    ),
    GetPage(
      name: reserveATable,
      page: () => ReserveTableScreen(
        restaurantID: Get.parameters['page'] ?? '',
      ),
    ),
    GetPage(
      name: reserveAPlace,
      page: () => Get.arguments != null ? Get.arguments : NotFound(),
    ),
    GetPage(
      name: reservePlaces,
      page: () => Get.arguments != null ? Get.arguments : NotFound(),
    ),
    GetPage(
      name: favorites,
      page: () => FavouriteScreen(
        fromNav: Get.parameters['page'] == 'fromNav',
      ),
    ),
    GetPage(
      name: settings,
      page: () => SettingsPage(),
    ),
    GetPage(
      name: makeReservation,
      page: () => MakeReservationScreen(),
    ),
    GetPage(
      name: updateProfile,
      page: () => UpdateProfileScreen(),
    ),
    GetPage(
      name: coupon,
      page: () => CouponScreen(),
    ),
    GetPage(
      name: notification,
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: map,
      page: () {
        List<int> _decode = base64Decode(
          Get.parameters['address'].replaceAll(' ', '+'),
        );
        AddressModel _data = AddressModel.fromJson(
          jsonDecode(utf8.decode(_decode)),
        );
        return MapScreen(
          fromRestaurant: Get.parameters['page'] == 'restaurant',
          address: _data,
        );
      },
    ),
    GetPage(
      name: addressInformation,
      page: () => AddressInformation(),
    ),
    GetPage(
      name: paymentDetails,
      page: () => PaymentDetailScreen(),
    ),
    GetPage(
      name: creditCard,
      page: () => CreditCardView(),
    ),
    GetPage(
      name: orderSuccess,
      page: () => OrderSuccessfulScreen(
        orderID: Get.parameters['id'],
        status: Get.parameters['status'].contains('success') ? 1 : 0,
        totalAmount: null,
      ),
    ),
    GetPage(
      name: payment,
      page: () => PaymentScreen(
        orderModel: OrderModel(
          id: int.parse(Get.parameters['id']),
          userId: int.parse(Get.parameters['user']),
          orderAmount: double.parse(
            Get.parameters['amount'],
          ),
        ),
      ),
    ),
    GetPage(
      name: payment_reserve,
      page: () => PaymentReserveScreen(
        orderModel: OrderModel(
          id: int.parse(Get.parameters['id']),
          userId: int.parse(Get.parameters['user']),
          orderAmount: double.parse(Get.parameters['amount']),
        ),
      ),
    ),
    GetPage(
      name: payment_track_reserve,
      page: () => PaymentTrackReserveScreen(
        orderModel: OrderModel(
          id: int.parse(Get.parameters['id']),
          userId: int.parse(Get.parameters['user']),
          orderAmount: double.parse(Get.parameters['amount']),
        ),
      ),
    ),
    GetPage(
      name: checkout,
      page: () {
        CheckoutScreen _checkoutScreen = Get.arguments;
        bool _fromCart = Get.parameters['page'] == 'cart';
        var _type = Get.parameters['orderType'] ?? 0;
        return _checkoutScreen != null
            ? _checkoutScreen
            : !_fromCart
                ? NotFound()
                : CheckoutScreen(
                    cartList: null,
                    fromCart: _fromCart,
                    orderType: int.parse(
                      _type,
                    ),
                  );
      },
    ),
    GetPage(
      name: reserveComplete,
      page: () => ReserveCompleteScreen(),
    ),
    GetPage(
      name: orderTracking,
      page: () => OrderTrackingScreen(
        orderID: Get.parameters['id'],
      ),
    ),
    GetPage(
        name: basicCampaign,
        page: () {
          BasicCampaignModel _data = BasicCampaignModel.fromJson(
            jsonDecode(
              utf8.decode(
                base64Decode(
                  Get.parameters['data'].replaceAll(' ', '+'),
                ),
              ),
            ),
          );
          return CampaignScreen(campaign: _data);
        }),
    GetPage(
      name: html,
      page: () => HtmlViewerScreen(
        htmlType: Get.parameters['page'] == 'terms-and-condition'
            ? HtmlType.TERMS_AND_CONDITION
            : Get.parameters['page'] == 'privacy-policy'
                ? HtmlType.PRIVACY_POLICY
                : HtmlType.ABOUT_US,
      ),
    ),
    GetPage(
      name: categories,
      page: () => CategoryScreen(),
    ),
    GetPage(
      name: cuisines,
      page: () => CuisineScreen(),
    ),
    GetPage(
      name: categoryProduct,
      page: () {
        List<int> _decode = base64Decode(
          Get.parameters['name'].replaceAll(' ', '+'),
        );
        String _data = utf8.decode(_decode);
        return CategoryProductScreen(
          categoryID: Get.parameters['id'],
          categoryName: _data,
        );
      },
    ),
    GetPage(
      name: cuisineProduct,
      page: () {
        List<int> _decode = base64Decode(
          Get.parameters['name'].replaceAll(' ', '+'),
        );
        String _data = utf8.decode(_decode);
        return CuisineProductScreen(
          cuisineId: Get.parameters['id'],
          cuisineName: _data,
        );
      },
    ),
    GetPage(
      name: popularFoods,
      page: () =>
          PopularFoodScreen(isPopular: Get.parameters['page'] == 'popular'),
    ),
    GetPage(
      name: venueFoods,
      page: () => VenueProductsScreen(
        venueId: Get.parameters['page'],
      ),
    ),
    GetPage(
      name: itemCampaign,
      page: () => ItemCampaignScreen(),
    ),
    GetPage(
      name: support,
      page: () => SupportScreen(),
    ),
    GetPage(
      name: update,
      page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true'),
    ),
    GetPage(
      name: cart,
      page: () => CartScreen(
        fromNav: false,
      ),
    ),
    GetPage(
      name: reserveCart,
      page: () => ReserveCartScreen(
        fromNav: false,
      ),
    ),
    GetPage(
      name: chefs,
      page: () => ChefsScreen(
        fromNav: Get.parameters['page'] == 'fromNav',
      ),
    ),
    GetPage(
      name: featuredChefsAll,
      page: () => AllFeaturedChefs(),
    ),
    GetPage(
      name: featuredVenuesAll,
      page: () => AllFeaturedVenuesScreen(),
    ),
    GetPage(
      name: celebChefs,
      page: () => CelebChefsScreen(
        fromNav: Get.parameters['page'] == 'fromNav',
      ),
    ),
    GetPage(
      name: venues,
      page: () => VenuesScreen(
        fromNav: Get.parameters['page'] == 'fromNav',
      ),
    ),
    GetPage(
      name: swushdVenues,
      page: () => SwushdVenuesScreen(
        fromNav: Get.parameters['page'] == 'fromNav',
      ),
    ),
    GetPage(
      name: addAddress,
      page: () =>
          AddAddressScreen(fromCheckout: Get.parameters['page'] == 'checkout'),
    ),
    GetPage(
      name: editAddress,
      page: () => AddAddressScreen(
        fromCheckout: false,
        address: AddressModel.fromJson(
          jsonDecode(
            utf8.decode(
              base64Url.decode(
                Get.parameters['data'].replaceAll(' ', '+'),
              ),
            ),
          ),
        ),
      ),
    ),
    GetPage(
      name: rateReview,
      page: () => Get.arguments != null ? Get.arguments : NotFound(),
    ),
    GetPage(
      name: restaurantReview,
      page: () => ReviewScreen(restaurantID: Get.parameters['id']),
    ),
    GetPage(
      name: allRestaurants,
      page: () => AllRestaurantScreen(),
    ),
    GetPage(
      name: wallet,
      page: () => WalletScreen(
        fromWallet: Get.parameters['page'] == 'wallet',
        fromNav: Get.parameters['fromNav'] == 'fromNav',
      ),
    ),
    GetPage(
      name: searchRestaurantItem,
      page: () => RestaurantProductSearchScreen(
        storeID: Get.parameters['id'],
      ),
    ),
    GetPage(
      name: productImages,
      page: () => ImageViewerScreen(
        product: Product.fromJson(
          jsonDecode(
            utf8.decode(
              base64Url.decode(
                Get.parameters['item'].replaceAll(' ', '+'),
              ),
            ),
          ),
        ),
      ),
    ),
    GetPage(
      name: referAndEarn,
      page: () => ReferAndEarnScreen(),
    ),
  ];

  static Widget getRoute(navigateTo) {
    return AccessLocationScreen(
      fromVerifyPhone: false,
      fromHome: false,
      route: Get.currentRoute,
    );
  }
}
