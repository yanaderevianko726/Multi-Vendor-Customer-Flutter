import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'main_commission_widget.dart';
import 'main_toparea_widget.dart';

class HomeMainWidget extends StatefulWidget {
  final Function onClickSubMain;
  const HomeMainWidget({Key key, this.onClickSubMain}) : super(key: key);
  @override
  _HomeMainWidgetState createState() => _HomeMainWidgetState();
}

class _HomeMainWidgetState extends State<HomeMainWidget> {
  TextEditingController ctrlSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var strHour = DateFormat.H().format(DateTime.now());
    var intHour = int.parse(strHour);

    var greetingTitle = 'good_morning'.tr;
    if (intHour >= 12 && intHour < 19) {
      greetingTitle = 'good_afternoon'.tr;
    } else if (intHour >= 19) {
      greetingTitle = 'good_evening'.tr;
    }
    double middlePadding = 6;
    return SizedBox(
      width: Dimensions.WEB_MAX_WIDTH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              right: 14,
              left: 14
            ),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)), 
                color: mainGrey
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 24,
                    color: Colors.black54,
                  ),
                  Expanded(
                    child: MyTextField(
                      fillColor: mainGrey,
                      hintText: 'Search by Restaurant, Cuisine, Categories or Dish'.tr,
                      inputType:
                          TextInputType.name,
                      controller: ctrlSearch,
                      capitalization:
                          TextCapitalization
                              .words,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<UserController>(builder: (userController) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 12, top: 12, bottom: 5),
              child: Text(
                '$greetingTitle${Get.find<UserController>().userInfoModel == null ? '' : ', ${Get.find<UserController>().userInfoModel.fName.split(' ')[0]}'}!',
                style: robotoMedium.copyWith(
                  fontSize: 18,
                  color: Colors.black87.withOpacity(0.65),
                ),
              ),
            );
          }),
          SizedBox(
            height: 12,
          ),
          MainTopareaWidget(
            middlePadding: middlePadding,
            onClickSubMain: (_index) {
              widget.onClickSubMain(_index);
            },
          ),
          SizedBox(
            height: 24,
          ),
          MainCommissionWidget(),
          SizedBox(
            height: 12,
          ),
          // CuisineView(),
          // FeaturedChefsView(
          //   cuisineIndex: 0,
          // ),
          // FeaturedVenueView(),
          // SwushdVenuesListWidget(),
          // PremiumVenueView(),
          // SizedBox(
          //   height: 12,
          // ),
          // FeaturedRentalsLogoWidge(),
          // SizedBox(
          //   height: 24,
          // ),
          // MainCommissionWidget(),
          // SizedBox(
          //   height: 12,
          // ),
        ],
      ),
    );
  }
}
