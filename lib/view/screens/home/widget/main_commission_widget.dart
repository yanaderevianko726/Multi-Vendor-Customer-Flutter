import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCommissionWidget extends StatefulWidget {
  const MainCommissionWidget({Key key}) : super(key: key);
  @override
  _MainCommissionWidgetState createState() => _MainCommissionWidgetState();
}

class _MainCommissionWidgetState extends State<MainCommissionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 348,
      color: Colors.yellow,
      child: Stack(
        children: [
          Image.asset(
            'assets/image/private_chefs.jpeg',
            width: MediaQuery.of(context).size.width,
            height: 348,
            fit: BoxFit.cover,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 348,
            color: Colors.black.withOpacity(0.5),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.36,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.2, color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Prevate Chefs'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Text(
                  'chefs_outstanding_cooks'.tr,
                  style: robotoBold.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    'Become a SWUSHD Kitchens Private Chef, sell your creations to your neighborhood with the SWUSHD app and start earning money from your health service-approved home kitchen!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Text(
                  '7% ${'commission_fee_on_sales'.tr}',
                  style: robotoBold.copyWith(
                    color: browLight,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      RouteHelper.getAddAddressRoute(
                        false,
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.48,
                    height: 44,
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'join_now'.tr,
                        style: robotoBold.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
