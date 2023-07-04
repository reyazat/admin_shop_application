
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshopadmin/models/ContactLessOrderInfoModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';

class ContactLessOrderInfoProvider with ChangeNotifier, DiagnosticableTreeMixin {
  ContactLessOrderInfoModel _orderInfo;
  ContactLessOrderInfoState orderInfoState;
  int initToggleSwitch = 9;

  ContactLessOrderInfoModel get orderInfo=>_orderInfo;
  ContactLessOrderInfoProvider(){
    orderInfoState = ContactLessOrderInfoInitial();
    this.init();
  }

  void init() async {
    await this.checkConnection();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt("loginStatus");
    if (value != 1) {
      orderInfoState = ContactLessOrderInfoLogOut();
    }else{
      NotificationService.dismiss();
    }
  }

  Future<void> checkConnection() async {
    final connection = await DataConnectionChecker().connectionStatus;
    if(connection == DataConnectionStatus.disconnected){
      print("Last results: ${DataConnectionChecker().lastTryResults}");
      orderInfoState = ContactLessOrderInfoNetworkError();
    }
  }

  Future<void> getOrderInfo(orderId) async {
    orderInfoState = ContactLessOrderInfoLoading();
    await AppNetwork().getContactLessOrderInfo(orderId).then((response) async {
      this._orderInfo = response;
      notifyListeners();
    }).catchError((error) {
      LoggerService.logger.e(error);
    });
    orderInfoState = ContactLessOrderInfoLoaded();
  }

  Future<void> changeStatus(int index, int orderId, String status) async
  {
    ShowMessageService.showLoading();
    var data = {
      "site_id": "1",
      "details[status]": "$status",
    };
    await AppNetwork().changeContactLessOrder(orderId, data).then((value)
    {
      if(value['status'] == 'success') {
        _orderInfo.status = status;
        ShowMessageService.closeLoading();
        notifyListeners();
      } else {
        ShowMessageService.closeLoading();
        ShowMessageService.showErrorMsg(value['message']);
      }
    });
  }


}
abstract class ContactLessOrderInfoState  {
  List<Object> get props;
  const ContactLessOrderInfoState();
}

class ContactLessOrderInfoInitial extends ContactLessOrderInfoState {
  @override
  List<Object> get props => [];
}

class ContactLessOrderInfoLoading extends ContactLessOrderInfoState {
  @override
  List<Object> get props => [];
}

class ContactLessOrderInfoLogOut extends ContactLessOrderInfoState {
  @override
  List<Object> get props => [];
}

class ContactLessOrderInfoLoaded extends ContactLessOrderInfoState {
  @override
  List<Object> get props => [];
}

class ContactLessOrderInfoNetworkError extends ContactLessOrderInfoState {
  @override
  List<Object> get props => [];
}