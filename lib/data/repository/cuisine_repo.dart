import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CuisineRepo {
  final ApiClient apiClient;
  CuisineRepo({@required this.apiClient});

  Future<Response> getCuisinesList() async {
    return await apiClient.getData(AppConstants.CUISINES_URI);
  }

  Future<Response> getCuisineProductList(
    String categoryID,
    int offset,
    String type,
  ) async {
    return await apiClient.getData(
      '${AppConstants.CUISINE_PRODUCT_URI}$categoryID?limit=10&offset=$offset&type=$type',
    );
  }

  Future<Response> getCuisineRestaurantList(
    String categoryID,
    int offset,
    String type,
  ) async {
    return await apiClient.getData(
      '${AppConstants.CUISINE_RESTAURANT_URI}$categoryID?limit=10&offset=$offset&type=$type',
    );
  }
}
