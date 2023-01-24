import 'package:efood_multivendor/theme/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';

class CreditCardView extends StatefulWidget {
  const CreditCardView({Key key}) : super(key: key);

  @override
  State<CreditCardView> createState() => _CreditCardViewState();
}

class _CreditCardViewState extends State<CreditCardView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var cardNumber = '';
  var expiryDate = '';
  var cardHolderName = '';
  var cvvCode = '';
  var isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
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
                      '${'Credit Card'.tr}',
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
              SizedBox(
                height: 220,
                child: CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  cardBgColor: yellowDark,
                  onCreditCardWidgetChange: (creditCardBrand) {},
                ),
              ),
              CreditCardForm(
                formKey: formKey,
                expiryDate: expiryDate,
                cardNumber: cardNumber,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                onCreditCardModelChange: onCreditCardModelChange,
                obscureCvv: true,
                obscureNumber: true,
                cardNumberDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder Name',
                ),
                themeColor: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 18,
              ),
              InkWell(
                onTap: () {
                  if (formKey.currentState.validate()) {
                    print('valid!');
                    showValidDialog(
                        context, "Valid", "Your card successfully valid !!!");
                  } else {
                    print('invalid!');
                  }
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Container(
                    width: 128,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      color: yellowDark,
                    ),
                    child: Center(
                      child: Text(
                        'Validate',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void showValidDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff1b447b),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text(
                "Ok",
                style: TextStyle(fontSize: 18, color: Colors.cyan),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
