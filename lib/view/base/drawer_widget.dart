import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/splash_controller.dart';
import '../../controller/user_controller.dart';
import '../../util/styles.dart';

class DrawerWidget extends StatelessWidget {
  final int index;
  final Function onClickDrawerItem;
  const DrawerWidget({
    Key key,
    this.onClickDrawerItem,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double outCircleR = 60;
    double innerPadding = 3;
    double innerCircleR = outCircleR - innerPadding;
    double fSize = 16;
    double iSize = 20;
    double itemVPadding = 4;
    double itemHPadding = 16;
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 220,
            child: Container(
              margin: EdgeInsets.only(left: 18, top: 32),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: outCircleR * 2,
                          height: outCircleR * 2,
                          margin: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: GetBuilder<UserController>(
                                builder: (userController) {
                                  return CachedNetworkImage(
                                    imageUrl:
                                        '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                        '/${(userController.userInfoModel != null) ? userController.userInfoModel.image : ''}',
                                    width: (innerCircleR - 3) * 2,
                                    height: (innerCircleR - 3) * 2,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/image/placeholder.jpg',
                                      width: (innerCircleR - 2) * 2,
                                      height: (innerCircleR - 2) * 2,
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/image/placeholder.jpg',
                                      width: (innerCircleR - 2) * 2,
                                      height: (innerCircleR - 2) * 2,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Container(
                      child: Row(
                        children: [
                          GetBuilder<UserController>(
                            builder: (userController) {
                              return Text(
                                '${Get.find<UserController>().userInfoModel == null ? '' : Get.find<UserController>().userInfoModel.fName + ' ' + Get.find<UserController>().userInfoModel.lName}',
                                style: robotoMedium.copyWith(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 22,
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(0);
                  },
                  child: Container(
                    height: 44,
                    color: index == 0
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 0 ? 'assets/image/ic_user_red.png' : 'assets/image/ic_user_white.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'account_title'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 0
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(1);
                  },
                  child: Container(
                    height: 44,
                    color: index == 1
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 1 ? 'assets/image/ic_hart.png' : 'assets/image/ic_heart_outline.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'favorites_title'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 1
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(2);
                  },
                  child: Container(
                    height: 44,
                    color: index == 2
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 2 ? 'assets/image/ic_reservation_red.png' : 'assets/image/ic_reservation.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'reservations_title'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 2
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(3);
                  },
                  child: Container(
                    height: 44,
                    color: index == 3
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 3 ? 'assets/image/ic_special_red.png' : 'assets/image/ic_special.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'vouchers_title'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 3
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     onClickDrawerItem(4);
                //   },
                //   child: Container(
                //     height: 44,
                //     color: index == 4
                //         ? Colors.white
                //         : Theme.of(context).primaryColor,
                //     padding: EdgeInsets.symmetric(
                //         horizontal: itemHPadding, vertical: 6),
                //     margin: EdgeInsets.symmetric(vertical: itemVPadding),
                //     child: Row(
                //       children: [
                //         Image.asset(
                //           '${index == 4 ? 'assets/image/language_red.png' : 'assets/image/language_white.png'}',
                //           width: iSize,
                //           fit: BoxFit.fitWidth,
                //         ),
                //         SizedBox(
                //           width: 12,
                //         ),
                //         Text(
                //           'language'.tr,
                //           style: TextStyle(
                //             fontSize: fSize,
                //             color: index == 4
                //                 ? Theme.of(context).primaryColor
                //                 : Colors.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 48,
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(5);
                  },
                  child: Container(
                    height: 44,
                    color: index == 5
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 5 ? 'assets/image/ic_help_red.png' : 'assets/image/ic_help.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'help_support'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 5
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(6);
                  },
                  child: Container(
                    height: 44,
                    color: index == 6
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 6 ? 'assets/image/ic_share_red.png' : 'assets/image/ic_share_white.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'share'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 6
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onClickDrawerItem(7);
                  },
                  child: Container(
                    height: 44,
                    color: index == 7
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: itemHPadding, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: itemVPadding),
                    child: Row(
                      children: [
                        Image.asset(
                          '${index == 7 ? 'assets/image/ic_logout_red.png' : 'assets/image/ic_logout.png'}',
                          width: iSize,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'logout'.tr,
                          style: TextStyle(
                            fontSize: fSize,
                            color: index == 7
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
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
