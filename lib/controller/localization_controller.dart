import 'dart:convert';

import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/language_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  LocalizationController(
      {@required this.sharedPreferences, @required this.apiClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode,
      AppConstants.languages[0].countryCode);
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    AddressModel _addressModel;
    try {
      _addressModel = AddressModel.fromJson(
          jsonDecode(sharedPreferences.getString(AppConstants.USER_ADDRESS)));
    } catch (e) {}
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.TOKEN),
      _addressModel == null ? null : _addressModel.zoneIds,
      locale.languageCode,
    );
    saveLanguage(_locale);
    if (Get.find<LocationController>().getUserAddress() != null) {
      DashboardScreen.loadData(true, 1, 10);
    }
    update();
  }

  void setCountry(String countryName) {
    saveCountry(countryName);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
            AppConstants.languages[0].languageCode,
        sharedPreferences.getString(AppConstants.COUNTRY_CODE) ??
            AppConstants.languages[0].countryCode);
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(
        AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode);
  }

  void saveCountry(String countryName) async {
    sharedPreferences.setString(AppConstants.COUNTRY_NAME, countryName);
  }

  int _selectedIndex = 0;
  int _selectedCountryIndex = 0;
  int get selectedIndex => _selectedIndex;
  int get selectedCountryIndex => _selectedCountryIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void setSelectCountryIndex(int index) {
    _selectedCountryIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = [];
      _languages = AppConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      AppConstants.languages.forEach((language) async {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      });
    }
    update();
  }
}
