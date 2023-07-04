import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/CouponModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/coupon/CouponState.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class CouponProvider extends ChangeNotifier {
  CouponState _state;
  List<CouponModel> coupons = [];

  String sort = 'name.ASC';

  final sortValues = [
    ['name.ASC', 'Name (asc)'],
    ['name.DESC', 'Name (desc)'],
    ['code.ASC', 'Code (asc)'],
    ['code.DESC', 'Code (desc)'],
    ['date_end.ASC', 'End date (asc)'],
    ['date_end.DESC', 'End date (desc)'],
  ];

  CouponState get state => _state;

  set state (CouponState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getCouponList() async {
    state = CouponLoading();
    ShowMessageService.showLoading();
    var data = {
      "search": "",
      "sort": sort.split('.')[0],
      "order": sort.split('.')[1],
    };
    await AppNetwork.postData('${Parameters.hostAPI}myapi/setting/getcouponlists', body: data).then((response) {
      if (response.success == true) {
        coupons = CouponModel.getListFromJson(response.response['coupons']);
        state = CouponLoaded();
      } else {
        ShowMessageService.showErrorMsg(response.response);
      }
    });
  }

  Future<void> deleteCoupon(int id) async {
    ShowMessageService.showLoading();
    var data = {
      "coupon_id": id,
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/setting/deleteCoupon', body: data).then((response) {
      if (response.success == true) {
        getCouponList();
      } else {
        ShowMessageService.showErrorMsg(response.response);
      }
    });
  }

  Future<void> addEditCoupon(Map data) async {
    ShowMessageService.showLoading();

    await AppNetwork.postData('${Parameters.hostAPI}myapi/setting/add_editcode', body: data).then((response) {
      if (response.success == true) {
        getCouponList();
      } else {
        ShowMessageService.showErrorMsg(response.response);
      }
    });
  }
}
