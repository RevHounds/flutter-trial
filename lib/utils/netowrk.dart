import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class NetworkUtils{
  static NetworkUtils _instance = new NetworkUtils.internal();
  NetworkUtils.internal();
  factory NetworkUtils() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url){
    return http.get(url).then((http.Response response){
      final String res = response.body;
      final int statusCode = response.statusCode;

      if(statusCode < 200 || statusCode > 400 || json == null){
        throw new Exception("Error while fetching data on get method...");
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {headers, Map body, encoding}) async {
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    String res = await response.transform(utf8.decoder).join();
    return _decoder.convert(res);

    // return http
    //   .post(url, body: body, headers: {"content-type":"application/json"})
    //   .then((http.Response response){
    //     final String res = response.body;
    //     final int statusCode = response.statusCode;
    //     print(body.toString());
    //     if(statusCode < 200 || statusCode > 400 || json == null)
    //       throw new Exception("Error while fetching data on post method...");
    //     return _decoder.convert(res);
    //   });
  }
}