import 'package:efood_multivendor/overlay_screen.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/sharedpref_util.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:efood_multivendor/view/screens/venues/widgets/home_celeb_chefs_view.dart';
import 'package:efood_multivendor/view/screens/venues/widgets/home_chefs_view.dart';
import 'package:efood_multivendor/view/screens/venues/widgets/home_restaurants_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget/home_main_widget.dart';
import 'widget/home_reservations_view.dart';
import 'widget/home_top_view.dart';

class HomeScreen extends StatefulWidget {
  final Function openDrawer;

  const HomeScreen({
    Key key,
    this.openDrawer,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  bool isAppActive = true;
  bool isOverlayOpen = false;

  var featuredCount = 0;
  var restaurantOffset = 1;
  var greetingTitle = '';
  var offset = 1;
  var limit = 10;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {});
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("-----\napp in resumed-------");
        if (isOverlayOpen) {
          Navigator.of(context).pop();
          isOverlayOpen = false;
        }
        bool isAppInForeground = await SharedPrefUtil().getAppInForeground();
        if (isAppInForeground) {
          SharedPrefUtil().setAppInForeground(false);
          return;
        }
        print("isAppActive--------++++" + isAppActive.toString());
        if (!isAppActive) {
          isAppActive = true;
        }
        break;
      case AppLifecycleState.inactive:
        print("-----\napp in inactive-----");
        if (!isOverlayOpen) {
          print("-----\nisOverlayOpen ----- $isOverlayOpen");
          isOverlayOpen = true;
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => OverlayScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        break;
      case AppLifecycleState.paused:
        print("-----\napp in paused-----");
        isAppActive = false;
        break;
      case AppLifecycleState.detached:
        print("-----\napp in detached-----");
        bool isAppInForeground = await SharedPrefUtil().getAppInForeground();
        if (!isAppInForeground) {
          isAppActive = false;
        }
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageIndex > 0) {
          setState(() {
            pageIndex = 0;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'back_press_again_to_exit'.tr,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(
                Dimensions.PADDING_SIZE_SMALL,
              ),
            ),
          );
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: mounted
              ? Column(
                  children: [
                    HomeTopView(
                      openDrawer: () {
                        widget.openDrawer();
                      },
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await DashboardScreen.loadData(false, offset, limit);
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (pageIndex == 0)
                                HomeMainWidget(
                                  onClickSubMain: (_index) {
                                    setState(() {
                                      pageIndex = _index;
                                    });
                                  },
                                ),
                              if (pageIndex == 1)
                                HomeRestaurantsView(
                                  kindIndex: 0,
                                ),
                              if (pageIndex == 2) HomeChefsView(),
                              if (pageIndex == 3)
                                HomeRestaurantsView(
                                  kindIndex: 1,
                                ),
                              if (pageIndex == 4)
                                HomeRestaurantsView(
                                  kindIndex: 2,
                                ),
                              if (pageIndex == 5) HomeReservationsView(),
                              if (pageIndex == 6) HomeCelebChefsView(),
                              if (pageIndex == 7)
                                HomeRestaurantsView(
                                  kindIndex: 3,
                                ),
                              if (pageIndex == 8)
                                HomeRestaurantsView(
                                  kindIndex: 4,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
