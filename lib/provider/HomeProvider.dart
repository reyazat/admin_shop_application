import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshopadmin/provider/HomeState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedIndex;
  HomeState homeState;
  GlobalKey<ConvexAppBarState> _appBarKey = GlobalKey<ConvexAppBarState>();

  get appBarKey => _appBarKey;

  get selectedIndex => _selectedIndex;

  HomeProvider() {
    this.homeState = HomeInitial();
    this.init();
  }

  Future<void> checkConnection() async {
    final connection = await DataConnectionChecker().connectionStatus;
    if (connection == DataConnectionStatus.disconnected) {
      print("Last results: ${DataConnectionChecker().lastTryResults}");
      this.homeState = HomeNetworkError();
    }
  }

  void init() async {
    await this.checkConnection();
    changeTab(2);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("loginStatus");
    if (value != 1) {
      this.homeState = HomeLogOut();
    } else {
      NotificationService.dismiss();
      this.homeState = HomeLoaded();
    }
  }

  changeTab(int index) {
    NotificationService.dismiss();
    _selectedIndex = index;
    _appBarKey.currentState.animateTo(index);
    notifyListeners();
  }

  close() {
    this._selectedIndex = 2;
    notifyListeners();
  }
}
