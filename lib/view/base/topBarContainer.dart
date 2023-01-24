import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBarContainer extends StatelessWidget {
  final bool fromNav;
  final String title;
  final Function onCLickBack;
  final BuildContext context;
  final Function openDrawer;

  const TopBarContainer({
    Key key,
    this.fromNav,
    this.onCLickBack,
    this.context,
    this.openDrawer,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: !fromNav ? 84 : MediaQuery.of(context).viewPadding.top + 60,
        padding: EdgeInsets.only(
          top: !fromNav ? 30 : MediaQuery.of(context).viewPadding.top,
        ),
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
            if (!fromNav)
              InkWell(
                onTap: () {
                  onCLickBack();
                },
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                  ),
                ),
              ),
            if (fromNav)
              GestureDetector(
                onTap: () {
                  if (openDrawer != null) openDrawer();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Spacer(),
            Text(
              '$title',
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
            Spacer(),
            SizedBox(
              width: 24,
              height: 24,
              child: InkWell(
                onTap: () => Get.toNamed(
                  RouteHelper.getCartRoute(),
                ),
                child: Badge(
                  badgeContent: Text(
                    '${cartController.cartList != null && cartController.cartList.isNotEmpty ? cartController.cartList.length : 0}',
                    style: robotoRegular.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  child: Image.asset(
                    'assets/image/ic_cart.png',
                    width: 22,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      );
    });
  }
}
