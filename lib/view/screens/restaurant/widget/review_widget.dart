import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  ReviewWidget({
    @required this.review,
    @required this.hasDivider,
  });

  @override
  Widget build(BuildContext context) {
    var createdAt = '';
    if (review.createdAt != null) {
      createdAt = review.createdAt.split('T')[0];
    }
    return Column(children: [
      Row(children: [
        ClipOval(
          child: CustomImage(
            image:
                '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${review.foodImage ?? ''}',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        Expanded(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.foodName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                Row(
                  children: [
                    RatingBar(
                      rating: review.rating.toDouble(),
                      ratingCount: null,
                      size: 15,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      '$createdAt',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  review.customerName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                  ),
                ),
                Text(
                  review.comment,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ]),
        ),
      ]),
      (hasDivider && ResponsiveHelper.isMobile(context))
          ? Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                bottom: 14,
                top: 8,
                left: 56,
              ),
              child: DottedLine(
                dashColor: Theme.of(context).disabledColor,
              ),
            )
          : SizedBox(),
    ]);
  }
}
