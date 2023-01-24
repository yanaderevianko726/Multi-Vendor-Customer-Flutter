import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class FeaturedVenueRepo {
  final ApiClient apiClient;
  FeaturedVenueRepo({
    @required this.apiClient,
  });

  Future<Response> getCuisineRestaurantList({
    int offset = 1,
    int limit = 10,
    String type = 'all',
  }) async {
    return await apiClient.getData(
      '${AppConstants.FEATURED_VENUE_URI}?limit=$limit&offset=$offset',
    );
  }
}
