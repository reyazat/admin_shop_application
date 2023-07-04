
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshopadmin/models/OrderInfoModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class OrderInfoProvider with ChangeNotifier, DiagnosticableTreeMixin {
  OrderInfoModel _orderInfo;
  OrderInfoState orderInfoState;
  int initToggleSwitch = 9;

  OrderInfoModel get orderInfo=>_orderInfo;
  OrderInfoProvider(){
    orderInfoState = OrderInfoInitial();
    this.init();
  }

  void init() async {
    await this.checkConnection();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("loginStatus");
    if (value != 1) {
      orderInfoState = OrderInfoLogOut();
    }else{
      NotificationService.dismiss();
    }
  }

  Future<void> checkConnection() async {
    final connection = await DataConnectionChecker().connectionStatus;
    if(connection == DataConnectionStatus.disconnected){
      print("Last results: ${DataConnectionChecker().lastTryResults}");
      orderInfoState = OrderInfoNetworkError();
    }
  }

  Future<void> getOrderInfo(orderId) async {
    orderInfoState = OrderInfoLoading();
    await AppNetwork().getOrderInfo({"order_id":"$orderId"}).then((response) async {
      this._orderInfo = response;
      orderInfoState = OrderInfoLoaded();
      notifyListeners();
    }).catchError((error) {
      orderInfoState = OrderInfoLoaded();
      LoggerService.logger.e(error);
    });

  }

  Future<void> changeStatus(int index, String orderId, int statusId) async
  {
    ShowMessageService.showLoading();
    var data = {
      "order_id": "$orderId",
      "order_status_id": "$statusId",
      "comment": "",
      "inform": "true",
    };
    await AppNetwork.postData('${Parameters.hostAPI}myapi/order/changestatus', body: data).then((value)
    {
      if(value.success == true) {
        _orderInfo.statusColor = value.response['status_color'];
        _orderInfo.orderStatus = value.response['name'];
        ShowMessageService.closeLoading();
        notifyListeners();
      } else {
        ShowMessageService.closeLoading();
        ShowMessageService.showErrorMsg(value.response);
      }
    });
  }

}
abstract class OrderInfoState  {
  List<Object> get props;
  const OrderInfoState();
}

class OrderInfoInitial extends OrderInfoState {
  @override
  List<Object> get props => [];
}

class OrderInfoLoading extends OrderInfoState {
  @override
  List<Object> get props => [];
}

class OrderInfoLogOut extends OrderInfoState {
  @override
  List<Object> get props => [];
}

class OrderInfoLoaded extends OrderInfoState {
  @override
  List<Object> get props => [];
}

class OrderInfoNetworkError extends OrderInfoState {
  @override
  List<Object> get props => [];
}