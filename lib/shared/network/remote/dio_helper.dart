
import 'package:dio/dio.dart';

class DioHelper{
  //start Create object dio from Dio class
  static late Dio dio;
//end Create object dio from Dio class
////start Create method for object dio from Dio class
static init()
{
  dio = Dio(
    BaseOptions(
      //enable for news app
      //baseUrl: 'https://newsapi.org/',

      //enable for login shop app
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,

    ),
  );
}
// start Get Data
static Future<Response> getData({
  required String url,
   Map<String, dynamic>? query,
  String lang = 'en',
  String? token,
})async
{
  dio.options.headers =
  {
    'Content-Type' : 'application/json',
    'lang': lang,
    'Authorization' : token??'',
  };


  return await dio.get(
    url,
    queryParameters: query,
  );
}
// End Get Data

  // start Post Data
static Future<Response> postData({
  required String url,
  required Map<String, dynamic> data,
  Map<String, dynamic>? query,
  String lang = 'en',
  String? token,
}) async
{
  dio.options.headers =
  {
    'Content-Type' : 'application/json',
    'lang': lang,
    'Authorization' : token??'',
  };
  return dio.post(
    url,
    queryParameters: query,
    data: data,
  );
}
// End Post Data

  // start update Data
  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async
  {
    dio.options.headers =
    {
      'Content-Type' : 'application/json',
      'lang': lang,
      'Authorization' : token??'',
    };
    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
// End update Data
}