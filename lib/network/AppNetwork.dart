import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:smartshopadmin/models/ContactLessOrderInfoModel.dart';
import 'package:smartshopadmin/models/ContactlessModel.dart';
import 'package:smartshopadmin/models/InitModel.dart';
import 'package:smartshopadmin/models/OrderInfoModel.dart';
import 'package:smartshopadmin/network/DioClient.dart';
import 'package:smartshopadmin/provider/Auth/AuthHelper.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Constants.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class AppNetwork {

  static Future<InitModel> getData(String url, {params}) async {
    InitModel result;

    try {
      final response = await DioClient().getDio().get(url,
        queryParameters: params ?? {},
      ).catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        print(response.data.toString());
        result = InitModel.fromJson(response.data);
      }else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    BotToast.closeAllLoading();
    return result;
  }

  static Future<InitModel> postData(String url, {body}) async {
    InitModel result;

    try {
      final response = await DioClient().getDio().post(url,
        data: jsonEncode(body),
          queryParameters: {
            "user_token": await AuthHelper.getToken() ?? '',
            "user_id": await AuthHelper.getUserId() ?? '',
            "useragent": 'app',
          }
      ).catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        print(response.data.toString());
        result = InitModel.fromJson(response.data);
      }else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    BotToast.closeAllLoading();
    return result;
  }

  static Future<ContactlessModel> getContactless(String url, {params}) async {
    ContactlessModel result;

    try {
      final response = await DioClient().getDio().get(url,
        queryParameters: params ?? {},
        options: Options(
          headers: {"Authorization": Constants.contactlessAuthorization},
        ),
      ).catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        result = ContactlessModel.fromJson(response.data);
      }else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    BotToast.closeAllLoading();
    return result;
  }

  static Future<ContactlessModel> postContactless(String url, {body}) async {
    ContactlessModel result;

    try {
      final response = await DioClient().getDio().post(url,
        data: jsonEncode(body),
        options: Options(
          headers: {"Authorization": Constants.contactlessAuthorization},
        ),
      ).catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        print(response.data.toString());
        result = ContactlessModel.fromJson(response.data);
      }else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    BotToast.closeAllLoading();
    return result;
  }

  Future<OrderInfoModel> getOrderInfo(body) async {
    OrderInfoModel result;
    try {
      final response = await DioClient()
          .getDio()
          .post('${Parameters.hostAPI}myapi/order/info', data: jsonEncode(body),
          queryParameters: {
            "user_token": await AuthHelper.getToken() ?? '',
            "user_id": await AuthHelper.getUserId() ?? '',
            "useragent": 'app',
          })
          .catchError((e) {
        LoggerService.logger.e(e);
      });
      print(response.toString());
      if (response.statusCode == 200) {
        if(response.data['success'] == true)
            result = OrderInfoModel.fromJson(response.data['response']);
        else
          ShowMessageService.showErrorMsg(response.data['response']);
      } else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    return result;
  }

  Future<List> getContactLessOrders(params) async {
    List result = [];
    try {
      final response = await DioClient()
          .getDio()
          .get('https://api.contactlessorder.co.uk/order/list',
          queryParameters: params,
        options: Options(
          headers: {"Authorization": Constants.contactlessAuthorization},
        ),
          )
          .catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        result = response.data['data'];
      } else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    return result;
  }

  Future<Map> changeContactLessOrder(int orderId,params) async {
    Map result = {};
    try {
      final response = await DioClient()
          .getDio()
          .put('https://api.contactlessorder.co.uk/order/$orderId',
          queryParameters: params,
          options: Options(
            headers: {"Authorization": Constants.contactlessAuthorization},
        ),
      ).catchError((e) {
        LoggerService.logger.e(e);
      });
      print(response.toString());
      if (response.statusCode == 200) {
        result = response.data;
      } else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    return result;
  }

  Future<ContactLessOrderInfoModel> getContactLessOrderInfo(int orderId) async {
    ContactLessOrderInfoModel result;
    try {
      final response = await DioClient()
          .getDio()
          .get('https://api.contactlessorder.co.uk/order/$orderId',
        queryParameters: {"site_id":"1"},
        options: Options(
          headers: {"Authorization": Constants.contactlessAuthorization},
        ),
      )
          .catchError((e) {
        LoggerService.logger.e(e);
      });

      if (response.statusCode == 200) {
          result = ContactLessOrderInfoModel.fromJson(response.data['data']);
      } else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    return result;
  }

}