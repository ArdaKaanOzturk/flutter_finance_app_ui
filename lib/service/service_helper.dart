import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dribble_finance_app_design/service/service_util.dart';
//import 'package:dio_http_cache/dio_http_cache.dart';
//import 'package:flutter/foundation.dart' show kDebugMode;

String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJSZWFsbmV0QXBpIFRva2VuIiwianRpIjoiMmE2MjM1MjEtYTI5My00ZTUyLWIxZTYtMWNkOTgwYjJjNDNhIiwiVXNlclByb2ZpbGVJZCI6IjQwMDciLCJVc2VyQmFzZUlkIjoiNDAzOSIsIkJyYW5kSWQiOiIxIiwiU2luZ2xlQWdlbnRJZCI6IjE3OCIsIlJvbGVJZCI6IjgiLCJSb2xlVHlwZSI6Ik9mZmljZUJyb2tlciIsIkN1cnJlbnRMYW5ndWFnZSI6IlR1cmtpc2giLCJleHAiOjIzMTQ3NTA4MzIsImlzcyI6IlJlYWxuZXRBcGkuU2VjdXJpdHkuQmVhcmVyIiwiYXVkIjoiUmVhbG5ldEFwaS5TZWN1cml0eS5CZWFyZXIifQ.8RKiaNsqgL2JPPq_jZkQelJh9VEpYQvybRYyWeVjfp8" ;

 BaseOptions options = BaseOptions(
   baseUrl: "http://realnetapi.emlaksistemi.com",
//   connectTimeout: 20000,
   receiveTimeout: const Duration(seconds: 5),
 );

 Dio dio = Dio(options);

 class ApiBaseHelper {
   static ApiBaseHelper? _instance;
   static ApiBaseHelper get instance {
     _instance ??= ApiBaseHelper._init();
     return _instance!;
   }

   ApiBaseHelper._init();

   ApiBaseHelper() {
     //dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: 'http://www.google.com')).interceptor);

/*     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient dioClient) {
        dioClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
 dio.interceptors.add(InterceptorsWrapper(onError: (DioError e, handler) {
   return e.error;
 }));
 dio.interceptors.add(LogInterceptor(responseBody: false, requestBody: true));*/
   }

  Future<dynamic> get(String endpoint) async {
    try {
      //var tokenBox = Hive.box('tokenBox');
      // var _deviceLocaleBox = Hive.box('deviceLocaleBox');
      //var accessToken = tokenBox.get('accessToken');
      // var deviceLocale = _deviceLocaleBox.get('deviceLocale');
      final res = await dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': "Bearer $token",
          },
        ),
      );
      if (res.statusCode == 401) {
        var statCode = res.statusCode;
        return statCode;
      }
      return res.data;
    } on DioError catch (e) {
      //  FirebaseCrashlytics.instance.recordError(e, null);
      var data = e.response?.data;
      if (data != null) {
        if (data is Map<String, dynamic>) {
          throw FetchDataException(e.response?.data['message']);
        } else {
          throw FetchDataException(e.message);
        }
      } else {
        throw FetchDataException('Bir hata oluştu! URL : ${e.requestOptions.path} , DATA : ${e.requestOptions.data}');
      }
    }
  }
  }