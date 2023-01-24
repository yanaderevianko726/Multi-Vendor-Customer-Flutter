import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class VendorRepo {
  final ApiClient apiClient;
  VendorRepo({@required this.apiClient});

  Future<Response> getVendorList() async {
    return await apiClient.getData('${AppConstants.VENDOR_LIST_URI}');
  }
}
