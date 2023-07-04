import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/ClientsModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/clients/ClientsState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class ClientsProvider extends ChangeNotifier {

  ClientsState clientsState;
  List<ClientsModel> _clients = [];
  int _page = 1;

  String _searchText = '';
  String _searchFilter = 'Email';

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

  List<ClientsModel> get clients => _clients;

  ClientsProvider() {
    clientsState = ClientsInitial();
  }

  void init() async {
    NotificationService.dismiss();
    await searchClients();
  }

  Future<void> _fetchClients() async
  {
    var data = {
      "filter_name": "",
      "filter_email": "",
      "sort": "c.date_added",
      "order": "DESC",
      "page": _page,
    };

    if(_searchText != '') {
      if(_searchFilter == 'Email') {
        data['filter_email'] = _searchText;
      }
      else if(_searchFilter == 'Name') {
        data['filter_name'] = _searchText;
      }
    }

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients', body: data).then((value)
    {
      if(value.success == true) {
        value.response['customers'].forEach((element) {
          ClientsModel clientItem = ClientsModel.fromJson(element);
          _clients.add(clientItem);
        });

        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });
  }

  Future<void> searchClients() async
  {
    clientsState = ClientsLoading();
    _page = 1;
    _clients = [];

    await _fetchClients().whenComplete((){
      clientsState = ClientsLoaded();
    }).onError((error, stackTrace){
      print(error.toString());
      clientsState = ClientsLoaded();
    });

  }

  void loadingPageClients() async
  {
    _page++;
    await _fetchClients();
  }

  Future<void> addRewardPoint({int index, customerId, comment, reward}) async
  {
    ShowMessageService.showLoading();

    var data = {
      "customer_id": customerId,
      "comment": comment,
      "reward": reward,
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients/addReward', body: data).then((value)
    {
      if(value.success == true) {
        _clients[index].rewardPoints = value.response;
        notifyListeners();
        ShowMessageService.showSuccessMsg(Constants.addRewardPointSuccessMsg);
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    ShowMessageService.closeLoading();
  }

  Future<void> addLoyalty({int index, customerId, customerCode}) async
  {
    ShowMessageService.showLoading();

    var data = {
      "customer_id": customerId,
      "customer_code": customerCode,
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients/addloyalty', body: data).then((value)
    {
      if(value.success == true) {
        _clients[index].loyaltyCode = value.response['loyaltycode'];
        notifyListeners();
        ShowMessageService.showSuccessMsg(Constants.addLoyaltySuccessMsg);
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    ShowMessageService.closeLoading();
  }

  Future<void> deleteLoyalty({int index, customerId}) async
  {
    ShowMessageService.showLoading();

    var data = {"customer_id": customerId};

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients/deleteloyalty', body: data).then((value)
    {
      if(value.success == true) {
        _clients[index].loyaltyCode = '';
        notifyListeners();
        ShowMessageService.showSuccessMsg(Constants.deleteLoyaltySuccessMsg);
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    ShowMessageService.closeLoading();
  }

}
