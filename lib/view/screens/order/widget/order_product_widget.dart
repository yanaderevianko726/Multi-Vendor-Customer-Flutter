import 'package:dotted_line/dotted_line.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProductWidget extends StatelessWidget {
  final OrderModel order;
  final OrderDetailsModel orderDetails;
  OrderProductWidget({@required this.order, @required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    double tPrice = 0;
    String _addOnText = '';
    orderDetails.addOns.forEach((addOn) {
      _addOnText = _addOnText +
          '${(_addOnText.isEmpty) ? '' : ', \n'}${addOn.name} (${addOn.quantity} x \$${addOn.price})';
      tPrice += addOn.price * addOn.quantity;
    });
    tPrice += orderDetails.price * orderDetails.quantity;

    // String _variationText = '';
    // if(orderDetails.variation.length > 0) {
    //   List<String> _variationTypes = orderDetails.variation[0].type.split('-');
    //   if(_variationTypes.length == orderDetails.foodDetails.choiceOptions.length) {
    //     int _index = 0;
    //     orderDetails.foodDetails.choiceOptions.forEach((choice) {
    //       _variationText = _variationText + '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
    //       _index = _index + 1;
    //     });
    //   }else {
    //     _variationText = orderDetails.foodDetails.variations[0].type;
    //   }
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderDetails.foodDetails.image != null &&
                    orderDetails.foodDetails.image.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Dimensions.RADIUS_SMALL,
                      ),
                      child: CustomImage(
                        height: 64,
                        width: 64,
                        fit: BoxFit.cover,
                        image:
                            '${orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/'
                            '${orderDetails.foodDetails.image}',
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderDetails.foodDetails.name,
                    style: robotoMedium.copyWith(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      '${orderDetails.quantity} x \$${orderDetails.price}',
                      style: robotoMedium.copyWith(
                          fontSize: 13,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(0.8)),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    '${'addons'.tr}: ',
                    style: robotoMedium.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '\$${tPrice.toStringAsFixed(2)}',
                style: robotoMedium,
              ),
            ),
          ],
        ),
        _addOnText.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 80),
                    Flexible(
                      child: Text(
                        _addOnText,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        // orderDetails.foodDetails.variations.length > 0
        //     ? Padding(
        //         padding:
        //             EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //         child: Row(children: [
        //           SizedBox(width: 60),
        //           Text('${'variations'.tr}: ',
        //               style: robotoMedium.copyWith(
        //                   fontSize: Dimensions.fontSizeSmall)),
        //           Flexible(
        //             child: Text(
        //               _variationText,
        //               style: robotoRegular.copyWith(
        //                 fontSize: Dimensions.fontSizeSmall,
        //                 color: Theme.of(context).disabledColor,
        //               ),
        //             ),
        //           ),
        //         ]),
        //       )
        //     : SizedBox(),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            bottom: 14,
            top: 14,
          ),
          child: DottedLine(
            dashColor: Theme.of(context).disabledColor,
          ),
        ),
      ],
    );
  }
}
