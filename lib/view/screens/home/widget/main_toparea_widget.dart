import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTopareaWidget extends StatefulWidget {
  final double middlePadding;
  final Function onClickSubMain;
  const MainTopareaWidget({
    Key key,
    this.middlePadding = 6,
    this.onClickSubMain,
  }) : super(key: key);
  @override
  _MainTopareaWidgetState createState() => _MainTopareaWidgetState();
}

class _MainTopareaWidgetState extends State<MainTopareaWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [        
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topCellContainer(
                asset: 'assets/image/ic_venues_blue.png',
                title: 'Restaurants'.tr,
                color: blueDark,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(1);
                  // Get.toNamed(
                  //   RouteHelper.getVenuesRoute(''),
                  // );
                },
              ),
              topCellContainer(
                asset: 'assets/image/ic_home_chef.png',
                title: 'chefs'.tr,
                color: primaryRed,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(2);
                  // Get.toNamed(
                  //   RouteHelper.getChefsRoute(''),
                  // );
                },
              ),
              topCellContainer(
                asset: 'assets/image/ic_venues.png',
                title: 'Venues'.tr,
                color: orangeLight,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(3);
                  // Get.toNamed(
                  //   RouteHelper.getVenuesRoute(''),
                  // );
                },
              ),
              topCellContainer(
                asset: 'assets/image/ic_rentals.png',
                title: 'Hotels'.tr,
                color: blueDeep,
                iconWidth: 30,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(4);
                  // Get.toNamed(
                  //   RouteHelper.getVenuesRoute(''),
                  // );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topCellContainer(
                asset: 'assets/image/ic_reservations1.png',
                title: 'Reservations'.tr,
                color: blueDark,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(5);
                  // Get.toNamed(
                  //   RouteHelper.getReservations(
                  //     'fromNav',
                  //   ),
                  // );
                },
              ),
              topCellContainer(
                asset: 'assets/image/ic_celeb.png',
                title: 'Celeb Chefs'.tr,
                color: primaryRed,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(6);
                  // Get.toNamed(
                  //   RouteHelper.getCelebChefsRoute(
                  //     '',
                  //   ),
                  // );
                },
              ),
              topCellContainer(
                asset: 'assets/image/ic_home_elitev_enues.png',
                title: 'Elite Venues'.tr,
                color: orangeLight,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(7);
                  // Get.toNamed(
                  //   RouteHelper.getSwushdVenuesRoute(
                  //     '',
                  //   ),
                  // );
                },
              ),
              topCellContainer(
                asset: 'assets/image/ic_hotels.png',
                title: 'Venue Rentals'.tr,
                color: blueDeep,
                iconWidth: 32,
                mContext: context,
                onCLickCell: () {
                  widget.onClickSubMain(8);
                  // Get.toNamed(
                  //   RouteHelper.getVenuesRoute(''),
                  // );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget topCellContainer({
    String asset,
    String title,
    Color color,
    double iconWidth = 36,
    BuildContext mContext,
    Function onCLickCell,
  }) {
    double screenWidth = MediaQuery.of(mContext).size.width;
    double mainHorPadding = 14;
    double topCellWidth =
        (screenWidth - mainHorPadding * 2 - widget.middlePadding * 3) /
            4 *
            0.95;
    double topCellHeight = 98;
    Dimensions.widthOfChefVenueCell = MediaQuery.of(mContext).size.width * 0.86;
    return InkWell(
      onTap: () {
        onCLickCell();
      },
      child: Container(
        width: topCellWidth,
        height: topCellHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: topCellWidth - 6,
              height: topCellWidth - 6,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 800 : 200],
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ],
              ),
              child: Center(
                child: Image.asset(
                  asset,
                  width: iconWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              title,
              style: robotoMedium.copyWith(
                fontSize: 10,
                color: color != null
                    ? color
                    : Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
