import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/vendor_model.dart';
import 'package:efood_multivendor/data/repository/vendor_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorController extends GetxController implements GetxService {
  final VendorRepo vendorRepo;
  VendorController({
    @required this.vendorRepo,
  });

  List<Vendor> _allVendorList = [];
  List<Vendor> _featuredVendorList = [];
  List<Vendor> _anotherVendorList = [];
  bool _isLoading = false;

  List<Vendor> get allVendorList => _allVendorList;
  List<Vendor> get featuredVendorList => _featuredVendorList;
  List<Vendor> get anotherVendorList => _anotherVendorList;
  bool get isLoading => _isLoading;

  Future<void> getVendorList(bool reload) async {
    if (reload) {
      _allVendorList = [];
      _featuredVendorList = [];
      update();
    }
    Response response = await vendorRepo.getVendorList();
    if (response.statusCode == 200) {
      List<dynamic> respMap = response.body;
      _allVendorList = [];
      _featuredVendorList = [];
      _anotherVendorList = [];
      respMap.forEach((element) {
        Map<String, dynamic> vendorMap = element;
        Vendor vendor = Vendor.fromJson(vendorMap);
        _allVendorList.add(vendor);
        if (vendor.vFeatured > 0) {
          _featuredVendorList.add(vendor);
        } else {
          _anotherVendorList.add(vendor);
        }
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Vendor getVendor(int venueId) {
    Vendor vendor = Vendor();
    if (_allVendorList.isNotEmpty) {
      int index = _allVendorList
          .indexWhere((element) => element.restaurantId == venueId);
      if (index != -1) {
        vendor = _allVendorList[index];
      }
    }
    return vendor;
  }
}
