import 'package:flutter/material.dart';

class OverlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            child: Image.asset(
              'assets/image/logo.png',
              width: 7,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}
