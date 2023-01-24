import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/data/repository/restaurant_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cuisine_controller.dart';

class RestaurantController extends GetxController implements GetxService {
  final RestaurantRepo restaurantRepo;

  RestaurantController({
    @required this.restaurantRepo,
  });

  RestaurantModel _restaurantModel;
  Restaurant _restaurant;
  List<Restaurant> _restaurantFeaturedList = [];
  List<Restaurant> _restaurantPremiumList = [];
  List<Restaurant> _restaurantPopularList = [];
  ProductModel _restaurantProductModel;
  ProductModel _restaurantSearchProductModel;
  List<Product> _restaurantProducts = [];
  int _categoryIndex = 0;
  List<CategoryModel> _categoryList = [];
  bool _isLoading = false;
  String _restaurantType = 'all';
  List<ReviewModel> _restaurantReviewList = [];
  bool _foodPaginate = false;
  int _foodPageSize;
  List<int> _foodOffsetList = [];
  int _foodOffset = 1;
  String _type = 'all'; // all, take_away, delivery
  String _searchType = 'all';
  String _searchText = '';
  List<Schedules> _openTimes = [];

  RestaurantModel get restaurantModel => _restaurantModel;
  List<Restaurant> get restaurantFeaturedList => _restaurantFeaturedList;
  List<Restaurant> get restaurantPremiumList => _restaurantPremiumList;
  List<Restaurant> get popularRestaurantList => _restaurantPopularList;
  Restaurant get restaurant => _restaurant;
  ProductModel get restaurantProductModel => _restaurantProductModel;
  ProductModel get restaurantSearchProductModel =>
      _restaurantSearchProductModel;
  List<Product> get restaurantProducts => _restaurantProducts;
  int get categoryIndex => _categoryIndex;
  List<CategoryModel> get categoryList => _categoryList;
  bool get isLoading => _isLoading;
  String get restaurantType => _restaurantType;
  List<ReviewModel> get restaurantReviewList => _restaurantReviewList;
  bool get foodPaginate => _foodPaginate;
  int get foodPageSize => _foodPageSize;
  int get foodOffset => _foodOffset;
  String get type => _type;
  String get searchType => _searchType;
  String get searchText => _searchText;
  List<Schedules> get openTimes => _openTimes;

  void setRestaurant(Restaurant __restaurant) {
    _restaurant = __restaurant;
  }

  Future<void> getRestaurantList(
    bool reload, {
    int limit = 10,
    int offset = 1,
  }) async {
    if (_restaurantModel == null) {
      _restaurantModel = new RestaurantModel();
    }
    Response response = await restaurantRepo.getRestaurantList(
      offset: offset,
      limit: limit,
      filterBy: _restaurantType,
    );
    if (response.statusCode == 200) {
      _restaurantModel = RestaurantModel.fromJson(response.body);
      _restaurantModel.totalSize =
          RestaurantModel.fromJson(response.body).totalSize;
      _restaurantModel.offset = RestaurantModel.fromJson(response.body).offset;
      _restaurantModel.restaurants = [];
      _restaurantModel.restaurants.addAll(
        RestaurantModel.fromJson(response.body).restaurants,
      );
      if (_restaurantModel.restaurants.length > 0) {
        _restaurantFeaturedList = [];
        _restaurantPremiumList = [];
        Get.find<CuisineController>().clearCuisines();
        _restaurantModel.restaurants.forEach((element) {
          Get.find<CuisineController>().addCuisine(element.cuisineId);
          if (element.featured > 0) {
            _restaurantFeaturedList.add(element);
          }
          if (element.venueType == 1) {
            _restaurantPremiumList.add(element);
          }
        });
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getPopularRestaurantList(
    bool reload, {
    int offset = 1,
    int limit = 10,
    String type = 'all',
  }) async {
    _type = type;
    if (reload) {
      _restaurantPopularList = [];
      update();
    }
    if (_restaurantPopularList.isEmpty || reload) {
      Response response = await restaurantRepo.getPopularRestaurantList(
        offset: offset,
        limit: limit,
        type: type,
      );
      if (response.statusCode == 200) {
        _restaurantPopularList = [];
        response.body.forEach(
          (restaurant) => _restaurantPopularList.add(
            Restaurant.fromJson(restaurant),
          ),
        );
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void setRestaurantType(String type) {
    _restaurantType = type;
    update();
  }

  void setCategoryList() {
    _categoryList = [];
    _categoryList.add(
      CategoryModel(id: 0, name: 'all'.tr),
    );

    if (Get.find<CategoryController>().categoryList != null &&
        _restaurantProducts != null) {
      _restaurantProducts.forEach((product) {
        int index = Get.find<CategoryController>()
            .categoryList
            .indexWhere((category) => category.id == product.categoryId);
        if (index != -1) {
          _categoryList.add(Get.find<CategoryController>().categoryList[index]);
        }
      });
    }
  }

  void initCheckoutData(int restaurantID) {
    if (_restaurant == null ||
        _restaurant.id != restaurantID ||
        Get.find<OrderController>().distance == null) {
      Get.find<CouponController>().removeCouponData(false);
      Get.find<OrderController>().clearPrevData();
      Get.find<RestaurantController>().getRestaurantDetails(
        Restaurant(id: restaurantID),
      );
    } else {
      Get.find<OrderController>().initializeTimeSlot(_restaurant);
    }
  }

  Future<Restaurant> getRestaurantDetails(Restaurant restaurant) async {
    _categoryIndex = 0;
    _restaurant = restaurant;
    print('=== _restaurant.name: ${_restaurant.name}');
    if (restaurant.name != null) {
      _restaurant = restaurant;
    } else {
      _isLoading = true;
      Response response = await restaurantRepo.getRestaurantDetails(
        restaurant.id.toString(),
      );
      if (response.statusCode == 200) {
        _restaurant = Restaurant.fromJson(response.body);
        Get.find<OrderController>().initializeTimeSlot(_restaurant);
        Get.find<OrderController>().getDistanceInMeter(
          LatLng(
            double.parse(
              Get.find<LocationController>().getUserAddress().latitude,
            ),
            double.parse(
              Get.find<LocationController>().getUserAddress().longitude,
            ),
          ),
          LatLng(
            double.parse(_restaurant.latitude),
            double.parse(_restaurant.longitude),
          ),
        );
      } else {
        ApiChecker.checkApi(response);
      }
      Get.find<OrderController>().setOrderType(
        _restaurant != null
            ? _restaurant.delivery
                ? 'delivery'
                : 'take_away'
            : 'delivery',
        notify: false,
      );

      _isLoading = false;
      update();
    }
    return _restaurant;
  }

  Future<void> getRestaurantProductList(
    int restaurantID,
    int offset,
    String type,
    bool notify,
  ) async {
    _foodOffset = offset;
    _type = type;
    if (offset == 1 || _restaurantProducts == null) {
      _foodOffset = 1;
      _foodOffsetList = [];
      _restaurantProducts = null;
    }
    if (notify) {
      update();
    }

    print('=== _restaurantProducts: $_restaurantProducts');
    if (!_foodOffsetList.contains(offset) || _restaurantProducts == null) {
      print('=== _foodOffset: $_foodOffset');
      Response response = await restaurantRepo.getRestaurantProductList(
        restaurantID,
        offset,
        _restaurant != null
            ? _restaurant.categoryIds != null
                ? _restaurant.categoryIds.length > 0 && _categoryIndex != 0
                    ? _categoryList[_categoryIndex].id
                    : 0
                : 0
            : 0,
        type,
      );
      if (response.statusCode == 200) {
        if (_foodOffset == 1 || _restaurantProducts == null) {
          _restaurantProducts = [];
        }
        _restaurantProducts.addAll(
          ProductModel.fromJson(response.body).products,
        );
        _foodPageSize = ProductModel.fromJson(response.body).totalSize;
        _foodPaginate = false;
        print('=== _restaurantProducts: $_restaurantProducts');

        if (!_foodOffsetList.contains(offset)) {
          _foodOffsetList.add(offset);
        }
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (_foodPaginate) {
        _foodPaginate = false;
        update();
      }
    }
  }

  void showFoodBottomLoader() {
    _foodPaginate = true;
    update();
  }

  void setFoodOffset(int offset) {
    _foodOffset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> getStoreSearchItemList(
      String searchText, String storeID, int offset, String type) async {
    if (searchText.isEmpty) {
      showCustomSnackBar('write_item_name'.tr);
    } else {
      _searchText = searchText;
      if (offset == 1 || _restaurantSearchProductModel == null) {
        _searchType = type;
        _restaurantSearchProductModel = null;
        update();
      }
      Response response = await restaurantRepo.getRestaurantSearchProductList(
          searchText, storeID, offset, type);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _restaurantSearchProductModel = ProductModel.fromJson(response.body);
        } else {
          _restaurantSearchProductModel.products
              .addAll(ProductModel.fromJson(response.body).products);
          _restaurantSearchProductModel.totalSize =
              ProductModel.fromJson(response.body).totalSize;
          _restaurantSearchProductModel.offset =
              ProductModel.fromJson(response.body).offset;
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void initSearchData() {
    _restaurantSearchProductModel = ProductModel(products: []);
    _searchText = '';
  }

  void setCategoryIndex(int index, {bool enUpdate = true}) {
    _categoryIndex = index;
    if (enUpdate) {
      update();
    }
  }

  Future<void> getRestaurantReviewList(String restaurantID) async {
    _restaurantReviewList = [];
    Response response =
        await restaurantRepo.getRestaurantReviewList(restaurantID);
    if (response.statusCode == 200) {
      _restaurantReviewList = [];
      response.body.forEach(
          (review) => _restaurantReviewList.add(ReviewModel.fromJson(review)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  bool isRestaurantClosed(bool today, int status, List<Schedules> schedules) {
    if (status == 0) {
      return true;
    }
    DateTime _date = DateTime.now();
    if (!today) {
      _date = _date.add(Duration(days: 1));
    }
    int _weekday = _date.weekday;
    if (_weekday == 7) {
      _weekday = 0;
    }
    if (schedules != null) {
      for (int index = 0; index < schedules.length; index++) {
        if (_weekday == schedules[index].day) {
          return false;
        }
      }
    }

    return true;
  }

  bool isRestaurantOpenNow(int status, List<Schedules> schedules) {
    print('=== schedules: ${schedules.toString()}');
    var closedChk = isRestaurantClosed(true, status, schedules);
    if (closedChk) {
      return false;
    }
    int _weekday = DateTime.now().weekday;
    if (_weekday == 7) {
      _weekday = 0;
    }
    for (int index = 0; index < schedules.length; index++) {
      print('=== openingTime $index: ${schedules[index].openingTime}');
      print('=== closingTime $index: ${schedules[index].closingTime}');
      if (_weekday == schedules[index].day &&
          DateConverter.isAvailable(
              schedules[index].openingTime, schedules[index].closingTime)) {
        return true;
      }
    }
    return false;
  }

  bool isOpenNow(Restaurant restaurant) {
    var isOpen = restaurant.status == 1 && restaurant.active;
    return isOpen;
  }

  double getDiscount(Restaurant restaurant) =>
      restaurant.discount != null ? restaurant.discount.discount : 0;

  String getDiscountType(Restaurant restaurant) => restaurant.discount != null
      ? restaurant.discount.discountType
      : 'percent';
}
