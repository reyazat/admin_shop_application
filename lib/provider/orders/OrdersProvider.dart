import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/OrdersModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/orders/OrdersState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class OrdersProvider extends ChangeNotifier {

  OrdersState ordersState;
  List<OrdersModel> _ordersList = [];

  int _page = 1;
  String _searchText = '';
  String _searchFilter = 'Order Num';

  String get searchText => _searchText;
  String get searchFilter => _searchFilter;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  set searchFilter(String value) {
    _searchFilter = value;
    notifyListeners();
  }

  List<OrdersModel> get ordersList => _ordersList;

  OrdersProvider() {
    ordersState = OrdersInitial();
  }

  void init() async {
    NotificationService.dismiss();
    await searchOrders();
  }

  Future<void> searchOrders() async {
    this._page = 1;
    ordersState = OrdersLoading();
    var data = {
      "filter_customer": "",
      "filter_order_id": "",
      "filter_order_status_id": "",
      "sort": "o.date_added",
      "order": "DESC",
      "page" : "1"
    };
    if(_searchText != '') {
      if(_searchFilter == 'Order Num') {
        searchText = _searchText.replaceAll("#", '');
        data['filter_order_id'] = _searchText;
      }
      else if(_searchFilter == 'Customer') {
        data['filter_customer'] = _searchText;
      }
    }

    await AppNetwork.postData('${Parameters.hostAPI}myapi/order', body: data).then((value)
    {
      if(value.success == true) {
        List getList = value.response['orders'];
        _ordersList = getList.map((i) => OrdersModel.fromJson(i)).toList();
        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    ordersState = OrdersLoaded();
  }

  Future<void> otherPageOrders({int pagePlus}) async {
    if(pagePlus!=null && pagePlus >0){
      this._page = this._page + pagePlus;
    }else this._page = 1;
    var data = {
      "filter_customer": "",
      "filter_order_id": "",
      "filter_order_status_id": "",
      "sort": "o.date_added",
      "order": "DESC",
      "page" : this._page
    };
    if(_searchText != '') {
      if(_searchFilter == 'Order Num') {
        searchText = _searchText.replaceAll("#", '');
        data['filter_order_id'] = _searchText;
      }
      else if(_searchFilter == 'Customer') {
        data['filter_customer'] = _searchText;
      }
    }

    await AppNetwork.postData('${Parameters.hostAPI}myapi/order', body: data).then((value)
    {
      if(value.success == true) {
        List getList = value.response['orders'];
        for(var item in getList){
          ordersList.add(OrdersModel.fromJson(item));
        }
        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
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
        _ordersList[index].statusColor = value.response['status_color'];
        _ordersList[index].orderStatus = value.response['name'];
        ShowMessageService.closeLoading();
        notifyListeners();
      } else {
        ShowMessageService.closeLoading();
        ShowMessageService.showErrorMsg(value.response);
      }
    });
  }



}
