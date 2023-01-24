import 'package:get/get.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context.width >= 1300 ? 14 : 10;
  static double fontSizeSmall = Get.context.width >= 1300 ? 16 : 12;
  static double fontSizeDefault = Get.context.width >= 1300 ? 18 : 14;
  static double fontSizeLarge = Get.context.width >= 1300 ? 20 : 16;
  static double fontSizeExtraLarge = Get.context.width >= 1300 ? 22 : 18;
  static double fontSizeOverLarge = Get.context.width >= 1300 ? 28 : 24;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;
  static const double PADDING_SIZE_OVER_LARGE = 30.0;

  static double widthOfChefVenueCell = 280.0;
  static const double HEIGHT_OF_CHEF_CELL = 264.0;

  static const double WIDTH_OF_FOOD_CELL = 212.0;
  static const double HEIGHT_OF_FOOD_CELL = 198.0;
  static const double HEIGHT_OF_FOOD_IMAGE_CELL = 128.0;

  static const double WIDTH_OF_RESTAURANT_CELL = 200.0;
  static const double HEIGHT_OF_RESTAURANT_CELL = 178.0;
  static const double HEIGHT_OF_RESTAURANT_IMAGE_CELL = 108.0;

  static const double RADIUS_SMALL = 6.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static const double RADIUS_EXTRA_LARGE = 20.0;

  static const double VENUE_WIDTH_ADJUSTMENT = 0.84;

  static const double WEB_MAX_WIDTH = 1170;
}
