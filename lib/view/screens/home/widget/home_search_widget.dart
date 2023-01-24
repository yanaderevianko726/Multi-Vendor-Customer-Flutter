import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSearchWidget extends StatefulWidget {
  final String searchText;
  final String hintText;
  final Function onChangeText;
  const HomeSearchWidget({
    Key key,
    this.searchText = '',
    this.onChangeText,
    this.hintText,
  }) : super(key: key);

  @override
  State<HomeSearchWidget> createState() => _HomeSearchWidgetState();
}

class _HomeSearchWidgetState extends State<HomeSearchWidget> {
  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCtrl.text = widget.searchText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
            Dimensions.RADIUS_SMALL,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[Get.isDarkMode ? 800 : 200],
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Row(children: [
          Icon(
            Icons.search,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          Expanded(
            child: CustomTextField(
              hintText: widget.hintText,
              controller: searchCtrl,
              inputType: TextInputType.emailAddress,
              divider: false,
              fontSize: 14,
              onChanged: (_text) {
                widget.onChangeText(searchCtrl.text);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
