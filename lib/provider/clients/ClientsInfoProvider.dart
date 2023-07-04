import 'package:flutter/material.dart';
import 'package:smartshopadmin/models/ClientsInfoModel.dart';
import 'package:smartshopadmin/network/AppNetwork.dart';
import 'package:smartshopadmin/provider/clients/ClientsInfoState.dart';
import 'package:smartshopadmin/services/NotificationService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class ClientsInfoProvider extends ChangeNotifier {

  ClientsInfoState clientsInfoState;
  ClientsInfoModel _clientInfo;

  List<RewardPointsModel> _points = [];
  int _pointsPage = 1;
  String _totalPoints;

  ClientsInfoModel get clientInfo => _clientInfo;

  String get totalPoints => _totalPoints;
  List<RewardPointsModel> get points => _points;

  ClientsInfoProvider() {
    clientsInfoState = ClientsInfoInitial();
    init();
  }

  void init() async {
    NotificationService.dismiss();
  }

  Future<void> getClientInfo(customerId) async
  {
    clientsInfoState = ClientsInfoLoading();

    var data = {"customer_id": customerId};

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients/clientinfo', body: data).then((value)
    {
      if(value.success == true) {
        _clientInfo = ClientsInfoModel.fromJson(value.response);

        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    clientsInfoState = ClientsInfoLoaded();
  }

  Future<void> _fetchRewardPoints(customerId) async
  {
    var data = {"customer_id": customerId, "page": _pointsPage};

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients/getrewards', body: data).then((value)
    {
      if(value.success == true) {
        _totalPoints = value.response['balance'];

        value.response['rewards'].forEach((element) {
          RewardPointsModel pointItem = RewardPointsModel.fromJson(element);
          _points.add(pointItem);
        });

        notifyListeners();
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });
  }

  void getRewardPoints(customerId) async
  {
    clientsInfoState = ClientsInfoLoading();
    _pointsPage = 1;
    _points = [];

    await _fetchRewardPoints(customerId);
    clientsInfoState = ClientsInfoLoaded();
  }

  void loadingPagePoints(customerId) async
  {
    _pointsPage++;
    await _fetchRewardPoints(customerId);
  }

  Future<void> deleteRewardPoint({customerId, int rewardId}) async
  {
    ShowMessageService.showLoading();

    var data = {
      "customer_id": customerId,
      "reward_id": rewardId,
      "page": "1"
    };

    await AppNetwork.postData('${Parameters.hostAPI}myapi/clients/deleteReward', body: data).then((value)
    {
      if(value.success == true) {
        getRewardPoints(customerId);

        ShowMessageService.showSuccessMsg(Constants.deleteRewardPointSuccessMsg);
      } else {
        ShowMessageService.showErrorMsg(value.response);
      }
    });

    ShowMessageService.closeLoading();
  }

}
