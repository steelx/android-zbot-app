
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert' as convert;

class ApiClient {
  final Client _client;
  final String _api;
  final Map<String, String> _additionalHeaders;
  final Map<String, String> _additionalCreateParameters;

  ApiClient(this._client, this._api):_additionalHeaders={}, _additionalCreateParameters = {};

  ApiClient._(this._client, this._api, this._additionalHeaders, this._additionalCreateParameters);

  Future<T> get<T>(String path) async {
    var api = _api.endsWith("/") ? _api.substring(0, _api.length-1) : _api;
    var processedPath = path.startsWith("/") ? path : "/$path";
    print("$api$processedPath");
    var response = await _client.get("$api$processedPath", headers: {"Content-Type": ContentType.json.mimeType,..._additionalHeaders});
    print("$processedPath :: ${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300){
      return convert.jsonDecode(response.body) as T;
    }
    throw response.statusCode;
  }

  Future<T> post<T>(String path, Map<String,dynamic> body) async{
    var api = _api.endsWith("/") ? _api.substring(0, _api.length-1) : _api;
    var processedPath = path.startsWith("/") ? path : "/$path";
    var response = await _client.post("$api$processedPath", headers: {"Content-Type": ContentType.json.mimeType,..._additionalHeaders}, body: convert.jsonEncode(body));
    if (response.statusCode >= 200 && response.statusCode < 300){
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }
    throw response.statusCode;
  }

  Future<T> postWithoutBody<T>(String path) async{
    var api = _api.endsWith("/") ? _api.substring(0, _api.length-1) : _api;
    var processedPath = path.startsWith("/") ? path : "/$path";
    var response = await _client.post("$api$processedPath", headers: {"Content-Type": ContentType.json.mimeType,..._additionalHeaders});
    if (response.statusCode >= 200 && response.statusCode < 300){
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }
    throw response.statusCode;
  }

  Future<T> put<T>(String path, Map<String,dynamic> body) async{
    var api = _api.endsWith("/") ? _api.substring(0, _api.length-1) : _api;
    var processedPath = path.startsWith("/") ? path : "/$path";
    var response = await _client.put("$api$processedPath", headers: {"Content-Type": ContentType.json.mimeType,..._additionalHeaders}, body: convert.jsonEncode(body));
    print("response");
    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode < 300){
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }
    throw response.statusCode;
  }

  Future<T> create<T>(String path, Map<String,dynamic> body) async{
    var api = _api.endsWith("/") ? _api.substring(0, _api.length-1) : _api;
    var processedPath = path.startsWith("/") ? path : "/$path";
    var response = await _client.post("$api$processedPath", headers: {"Content-Type": ContentType.json.mimeType,..._additionalHeaders}, body: convert.jsonEncode({...body,..._additionalCreateParameters}));
    if (response.statusCode >= 200 && response.statusCode < 300){
      return (response.body.isEmpty ? response.body : convert.jsonDecode(response.body)) as T;
    }
    throw response.statusCode;
  }

  Future<String> postForHeader(String path, Map<String,dynamic> body, String expectedHeader) async{
    var api = _api.endsWith("/") ? _api.substring(0, _api.length-1) : _api;
    var processedPath = path.startsWith("/") ? path : "/$path";
    var response = await _client.post(
        "$api$processedPath",
        headers: {
          "Content-Type": ContentType.json.mimeType,
          ..._additionalHeaders,
        },
        body: convert.jsonEncode(body)
    );
    if (response.statusCode >= 200 && response.statusCode < 300){
      return response.headers[expectedHeader];
    }
    throw response.statusCode;
  }

  ApiClient withAdditionalHeaders(Map<String, String> additionalHeaders) {
    return ApiClient._(
        _client,
        _api,
        additionalHeaders,
        {}
    );
  }

  ApiClient withAdditionalCreateParameters(Map<String, String> createParameters) {
    return ApiClient._(
      _client,
      _api,
      _additionalHeaders,
      createParameters,
    );
  }

}
