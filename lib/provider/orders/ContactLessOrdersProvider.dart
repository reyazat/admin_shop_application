import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/ContactLessOrdersModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/orders/ContactLessOrdersState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';

class ContactLessOrdersProvider extends ChangeNotifier {

  ContactLessOrdersState contactLessOrdersState;
  List<ContactLessOrdersModel> _ordersList = [];

  int _startList = 0;
  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  List<ContactLessOrdersModel> get ordersList => _ordersList;

  ContactLessOrdersProvider() {
    contactLessOrdersState = ContactLessOrdersInitial();
    init();
  }

  void init() async {
    NotificationService.dismiss();
    await searchOrders();
  }

  Future<void> searchOrders() async
  {
    contactLessOrdersState = ContactLessOrdersLoading();
    _startList = 0;
    _ordersList = [];

    await _fetchOrders();
    contactLessOrdersState = ContactLessOrdersLoaded();
  }

  void loadingPage() async
  {
    _startList = _startList + 15;
    await _fetchOrders();
  }
  Future<void> _fetchOrders() async {
    var queryParameters = {
      "filtering":'[{"name":"status","value":"Processing,Preparing,Dispatched,Completed,Canceled,Refunded"}]',
      "length":"15",
      "order[0][dir]":"desc",
      "order[0][name]":"created_at",
      "start": _startList,
    };
    if(_searchText != '') {
      queryParameters['search[value]'] = _searchText.trim();
    }
    

    await AppNetwork().getContactLessOrders(queryParameters).then((value)
    {
      for(var item in value){
        ordersList.add(ContactLessOrdersModel.fromJson(item));
      }
      notifyListeners();

    });

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
        _ordersList[index].statusColor = value['status_color'];
        _ordersList[index].orderStatus = status;
        ShowMessageService.closeLoading();
        notifyListeners();
      } else {
        ShowMessageService.closeLoading();
        ShowMessageService.showErrorMsg(value['message']);
      }
    });
  }



}
