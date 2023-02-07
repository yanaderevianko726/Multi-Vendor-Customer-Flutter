import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PaymentBottomSheet extends StatefulWidget {
  final bool isUpdate;

  PaymentBottomSheet({
    this.isUpdate = false,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController cardNumController = TextEditingController();
  final TextEditingController mmController = TextEditingController();
  final TextEditingController yyController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final FocusNode cardNumNode = FocusNode();
  final FocusNode mmNode = FocusNode();
  final FocusNode yyNode = FocusNode();
  final FocusNode cvvNode = FocusNode();
  final FocusNode firstNameNode = FocusNode();
  final FocusNode lastNameNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mmWidth = (MediaQuery.of(context).size.width - 64) / 3;
    double topRadius = 22;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: ResponsiveHelper.isMobile(context)
            ? BorderRadius.vertical(
                top: Radius.circular(
                  topRadius,
                ),
              )
            : BorderRadius.all(
                Radius.circular(
                  Dimensions.RADIUS_EXTRA_LARGE,
                ),
              ),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.3,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Icon(
                            Icons.close,
                            size: 26,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 32,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topRadius),
                      topRight: Radius.circular(topRadius),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add another credit/debit card'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 22,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).disabledColor,
                            ),borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: CustomTextField(
                            hintText: 'Card Number'.tr,
                            controller: cardNumController,
                            focusNode: cardNumNode,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 22,),
                        Row(
                          children: [
                            Text(
                              'Expires On'.tr,
                              style: robotoRegular.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: mmWidth,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).disabledColor,
                                  ),borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: CustomTextField(
                                hintText: 'MM'.tr,
                                controller: mmController,
                                focusNode: mmNode,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                              ),
                            ),
                            SizedBox(width: 12,),
                            Container(
                              width: mmWidth,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).disabledColor,
                                  ),borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: CustomTextField(
                                hintText: 'YY'.tr,
                                controller: yyController,
                                focusNode: yyNode,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).disabledColor,
                              ),borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: CustomTextField(
                            hintText: 'CVV/CVS'.tr,
                            controller: cvvController,
                            focusNode: cvvNode,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 18,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).disabledColor,
                              ),borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: CustomTextField(
                            hintText: 'First Name'.tr,
                            controller: firstNameController,
                            focusNode: firstNameNode,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 18,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).disabledColor,
                              ),borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: CustomTextField(
                            hintText: 'Last Name'.tr,
                            controller: lastNameController,
                            focusNode: lastNameNode,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 18,),
                        Container(
                          width: double.infinity,
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 14,
                              right: 14,
                            ),
                            child: CustomButton(
                              height: 44,
                              buttonText: '+ Add another credit/debit card'.tr,
                              radius: 12,
                              margin: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL,
                              ),
                              onPressed: () {
                                _onTapAddPayment(context);
                              },
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartSnackBar(bool showCheckOutBtn) {
    print('=== viewCart.showCheckoutBtn: $showCheckOutBtn');
    ScaffoldMessenger.of(Get.context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        action: SnackBarAction(
            label: 'view_cart'.tr,
            textColor: Colors.white,
            onPressed: () {
              if (showCheckOutBtn) {
                Get.toNamed(
                  RouteHelper.getCartRoute(),
                );
              } else {
                Get.toNamed(
                  RouteHelper.getReserveCart(),
                );
              }
            }),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        ),
        content: Text(
          'item_added_to_cart'.tr,
          style: robotoMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  void _onTapAddPayment(BuildContext context) {

  }
}
