import 'package:dio/dio.dart';
import 'package:smartshopadmin/network/NetworkExceptions.dart';
import 'package:smartshopadmin/services/ShowMessageService.dart';
import 'package:smartshopadmin/values/Parameters.dart';

class DioClient {
  Dio _dio;
  static final DioClient _instance = DioClient._internal();

  factory DioClient(){
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio()
      ..options.connectTimeout =10000
      ..options.receiveTimeout =5000
      ..options.receiveDataWhenStatusError = true
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json',
      };
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest:(options, handler){
          // Do something before request is sent
          return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: return `dio.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: return `dio.reject(dioError)`
        },
        onResponse:(response,handler) {
          // Do something with response data
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: return `dio.reject(dioError)`
        },
        onError: (DioError e, handler) {
          ShowMessageService.showErrorMsg(NetworkExceptions.getErrorMessage(e));
          return  handler.next(e);//continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: return `dio.resolve(response)`.
        }
    ));
  }
  Dio getDio() {
    return _dio;
  }

}