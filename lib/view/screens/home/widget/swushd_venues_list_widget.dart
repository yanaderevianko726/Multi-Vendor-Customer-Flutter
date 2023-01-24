import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwushdVenuesListWidget extends StatefulWidget {
  const SwushdVenuesListWidget({Key key}) : super(key: key);
  @override
  _SwushdVenuesListWidgetState createState() => _SwushdVenuesListWidgetState();
}

class _SwushdVenuesListWidgetState extends State<SwushdVenuesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 168,
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 20,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [yellowDark, yellowLight, yellowBright],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 5,
            left: -88,
            child: Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 64,
            left: -72,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              Image.asset(
                'assets/image/ic_diamond.png',
                width: 32,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Premium Venues',
                style: robotoBold.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Text(
                  'SWUSHD Venues provides a real-time online reservation network.',
                  style: robotoMedium.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.getSwushdVenuesRoute(
                      '',
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    'Vew All',
                    style: robotoMedium.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
