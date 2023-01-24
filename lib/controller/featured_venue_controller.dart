import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/featured_restaurant.dart';
import 'package:efood_multivendor/data/repository/featured_venue_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeaturedVenueController extends GetxController implements GetxService {
  final FeaturedVenueRepo featuredVenueRepo;
  FeaturedVenueController({
    @required this.featuredVenueRepo,
  });

  List<FeaturedRestaurant> _featuredVenuesList = [];
  bool _isLoading = false;
  int _pageSize;
  int _offset = 1;
  String _type = 'all';

  List<FeaturedRestaurant> get featuredVenuesList => _featuredVenuesList;
  bool get isLoading => _isLoading;
  int get pageSize => _pageSize;
  int get offset => _offset;
  String get type => _type;

  Future<void> getFeaturedVenueList(bool reload) async {
    Response response = await featuredVenueRepo.getCuisineRestaurantList();
    if (response.statusCode == 200) {
      print('featured venues response: ${response.body}');
      loadFromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  loadFromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      _featuredVenuesList = [];
      json['restaurants'].forEach((v) {
        FeaturedRestaurant featured = FeaturedRestaurant.fromJson(v);
        _featuredVenuesList.add(featured);
      });
    }
  }
}
