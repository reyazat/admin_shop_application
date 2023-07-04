
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smartshopadmin/services/LoggerService.dart';
import 'package:smartshopadmin/values/Constants.dart';

class NetworkExceptions  {
  static String getErrorMessage(error) {
    var errorMessage = Constants.defaultError;
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              LoggerService.logger.e("Request Cancelled");
              break;
            case DioErrorType.connectTimeout:
              errorMessage = Constants.noInternet;
              LoggerService.logger.e("Connection request timeout");
              break;
            case DioErrorType.other:
              errorMessage = Constants.noInternet;
              LoggerService.logger.e(Constants.noInternet);
              break;
            case DioErrorType.receiveTimeout:
              LoggerService.logger.e("Send timeout in connection with API server");
              break;
            case DioErrorType.response:
              switch (error.response.statusCode) {
                case 400:
                  LoggerService.logger.e("Unauthorised request");
                  break;
                case 401:
                  LoggerService.logger.e("Unauthorised request 401");
                  break;
                case 403:
                  LoggerService.logger.e("Unauthorised request 403");
                  break;
                case 404:
                  LoggerService.logger.e("Not found");
                  break;
                case 409:
                  LoggerService.logger.e("Error due to a conflict");
                  break;
                case 408:
                  LoggerService.logger.e("Connection request timeout");
                  break;
                case 500:
                  LoggerService.logger.e("Internal Server Error");
                  break;
                case 503:
                  LoggerService.logger.e("Service unavailable");
                  break;
                default:
                  var responseCode = error.response.statusCode;
                  LoggerService.logger.e("Received invalid status code: $responseCode");
              }
              break;
            case DioErrorType.sendTimeout:
              LoggerService.logger.e("Send timeout in connection with API server");
              break;
          }
        } else if (error is SocketException) {
          errorMessage = Constants.noInternet;
          LoggerService.logger.e(Constants.noInternet);
        } else {
          LoggerService.logger.e("Unexpected error occurred");
        }
      } on FormatException catch (_) {
        LoggerService.logger.e("Bad Request");
      } catch (_) {
        LoggerService.logger.e("Unexpected error occurred");
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        LoggerService.logger.e(error.toString());
      } else {
        LoggerService.logger.e(error.toString());
      }
    }
    return errorMessage;
  }


}