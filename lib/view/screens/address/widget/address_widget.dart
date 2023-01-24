import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function onRemovePressed;
  final Function onEditPressed;
  final Function onTap;

  AddressWidget({
    @required this.address,
    @required this.fromAddress,
    this.onRemovePressed,
    this.onEditPressed,
    this.onTap,
    this.fromCheckout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.isDesktop(context)
                ? Dimensions.PADDING_SIZE_DEFAULT
                : Dimensions.PADDING_SIZE_SMALL,
          ),
          decoration: BoxDecoration(
            color: fromCheckout ? null : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            border: fromCheckout
                ? Border.all(color: Theme.of(context).disabledColor, width: 1)
                : null,
            boxShadow: fromCheckout
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey[Get.isDarkMode ? 800 : 200],
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
          ),
          child: address != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      address.addressType == 'home'
                          ? Icons.home_filled
                          : address.addressType == 'office'
                              ? Icons.work
                              : Icons.location_on,
                      size: ResponsiveHelper.isDesktop(context) ? 50 : 24,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text(
                                  address.contactPersonName ?? '',
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 12),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                  ),
                                  child: Text(
                                    address.addressType.tr,
                                    style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Text(
                                '${address.house}, ${address.road}',
                                style: robotoMedium.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Text(
                                '${address.aptNumber}, ${address.villageName}, Floor ${address.floor}',
                                style: robotoMedium.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Text(
                                '${address.address}',
                                style: robotoMedium.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ]),
                    ),
                    if (fromAddress)
                      Column(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            margin: EdgeInsets.only(
                              left: 12,
                              right: 12,
                              bottom: 12,
                            ),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                  size: ResponsiveHelper.isDesktop(context)
                                      ? 35
                                      : 22,
                                ),
                                onPressed: onEditPressed,
                              ),
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            margin: EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: ResponsiveHelper.isDesktop(context)
                                      ? 35
                                      : 22,
                                ),
                                onPressed: onRemovePressed,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
