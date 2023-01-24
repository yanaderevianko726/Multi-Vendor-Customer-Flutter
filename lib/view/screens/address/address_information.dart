import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/address/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressInformation extends StatefulWidget {
  const AddressInformation({Key key}) : super(key: key);
  @override
  State<AddressInformation> createState() => _AddressInformationState();
}

class _AddressInformationState extends State<AddressInformation>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 84,
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 800 : 200],
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 22,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '${'address'.tr} ${'information'.tr}',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 48,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dimensions.PADDING_SIZE_SMALL,
          ),
          Expanded(
            child: AddressScreen(),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(
                RouteHelper.getAddAddressRoute(false),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              margin: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  'Add Address'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
