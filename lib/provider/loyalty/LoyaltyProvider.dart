import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/LoyaltyModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/loyalty/LoyaltyState.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class LoyaltyProvider extends ChangeNotifier {
  LoyaltyState _state;
  List<LoyaltyModel> loyaltyList = [];

  String sort = 'name.ASC';

  final sortValues = [
    ['name.ASC', 'Name (asc)'],
    ['name.DESC', 'Name (desc)'],
    ['code.ASC', 'Code (asc)'],
    ['code.DESC', 'Code (desc)'],
  ];

  LoyaltyState get state => _state;

  set state(LoyaltyState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getLoyaltyList() async {
    state = LoyaltyLoading();
    ShowMessageService.showLoading();
    var data = {
      "search": "",
      "sort": sort.split('.')[0],
      "order": sort.split('.')[1],
    };
    await AppNetwork.postData('${Parameters.hostAPI}myapi/setting/getloyaltylists', body: data)
        .then((response) {
      if (response.success == true) {
        loyaltyList = LoyaltyModel.getListFromJson(response.response['coupons']);
        state = LoyaltyLoaded();
      } else {
        ShowMessageService.showErrorMsg(response.response);
      }
    });
  }

  Future<void> deleteLoyalty(int id) async {
    ShowMessageService.showLoading();
    var data = {
      "coupon_id": id,
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/setting/deleteCoupon', body: data).then((response) {
      if (response.success == true) {
        getLoyaltyList();
      } else {
        ShowMessageService.showErrorMsg(response.response);
      }
    });
  }

  Future<void> addEditLoyalty(Map data) async {
    ShowMessageService.showLoading();

    await AppNetwork.postData('${Parameters.hostAPI}myapi/setting/add_editcode', body: data).then((response) {
      if (response.success == true) {
        getLoyaltyList();
      } else {
        ShowMessageService.showErrorMsg(response.response);
      }
    });
  }
}
