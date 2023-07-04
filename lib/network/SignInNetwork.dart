import 'dart:convert';

import 'package:smartshopadmin/models/InitModel.dart';
import 'package:smartshopadmin/network/DioClient.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class SignInNetwork {
  Future<InitModel> signIn(body) async {
    InitModel result;
    try {
      final response = await DioClient()
          .getDio()
          .post('${Parameters.hostAPI}myapi/credential/signin', data: jsonEncode(body))
          .catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        result = InitModel.fromJson(response.data);
      } else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    return result;
  }

  Future<InitModel> signOut(body) async {
    InitModel result;
    try {
      final response = await DioClient()
          .getDio()
          .post('${Parameters.hostAPI}myapi/credential/signout', data: jsonEncode(body))
          .catchError((e) {
        LoggerService.logger.e(e);
      });
      if (response.statusCode == 200) {
        result = InitModel.fromJson(response.data);
      } else {
        LoggerService.logger.w(response.statusMessage);
      }
    } catch (e) {
      LoggerService.logger.e(e);
    }
    return result;
  }

}
