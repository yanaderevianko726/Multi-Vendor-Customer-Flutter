import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/topBarContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CelebChefsScreen extends StatefulWidget {
  final bool fromNav;
  final Function openDrawer;
  const CelebChefsScreen({
    Key key,
    this.fromNav = false,
    this.openDrawer,
  }) : super(key: key);

  static Future<void> getProductList(bool reload, {int offset = 1}) async {
    await Get.find<ProductController>()
        .getPopularProductList(reload, 'all', offset: offset);
  }

  @override
  State<CelebChefsScreen> createState() => _CelebChefsScreenState();
}

class _CelebChefsScreenState extends State<CelebChefsScreen> {
  List<Product> featuredProducts = [];
  List<Product> restProducts = [];
  int featuredCount = 0, restCount = 0, offset = 1;

  Future<void> getVendorsList() async {
    await CelebChefsScreen.getProductList(false, offset: offset);
  }

  @override
  void initState() {
    super.initState();
    getVendorsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProductController>(builder: (productController) {
        featuredCount = 0;
        restCount = 0;

        if (productController.productList != null &&
            productController.productList.isNotEmpty) {
          print('=== restaurants: ${productController.productList.length}');
          featuredProducts = [];
          restProducts = [];
          productController.productList.forEach((productTmp) {
            if (productTmp.featured == 1) {
              featuredProducts.add(productTmp.copyWith());
            } else {
              restProducts.add(productTmp.copyWith());
            }
          });
          featuredCount = featuredProducts.length;
          restCount = restProducts.length;
        }
        return Column(
          children: [
            TopBarContainer(
              title: 'celeb_chefs_title'.tr,
              fromNav: widget.fromNav,
              onCLickBack: () {
                Get.back();
              },
              openDrawer: () {
                widget.openDrawer();
              },
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_SMALL,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await CelebChefsScreen.getProductList(false, offset: offset);
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      featuredCount > 0
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'featured_celebs'.tr,
                                    style: robotoMedium.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      restCount > 0
                          ? Column(
                              children: [
                                for (int index = 0; index < restCount; index++)
                                  Container()
                              ],
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
