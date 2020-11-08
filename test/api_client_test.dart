import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'package:zbot_app/resources/api_client.dart';


void main(){

  test("get should make the request for a given URL and return the json response",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (request.headers["Content-Type"] == ContentType.json.mimeType){
        return Response("", HttpStatus.badRequest);
      }
      if (request.method != "GET"){
        return Response("", HttpStatus.methodNotAllowed);
      }
      if (request.url.toString() != "http://mydomain.com/v1/data"){
        return Response("", HttpStatus.notImplemented);
      }
      return Response(
          convert.jsonEncode([1,2,3,4]),
          HttpStatus.ok,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api);
    Future<List<dynamic>> response = client.get<List<dynamic>>(path);
    var data = await response;
    expect(data, [1,2,3,4]);

  });

  test("get should return status code as error on api failure",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      return Response("", HttpStatus.badRequest);
    });

    var client = ApiClient(mockClient, api);
    Future<List<dynamic>> response = client.get<List<dynamic>>(path);
    expect(response, throwsA(400));

  });


  test("post should make the request for a given URL and pass the json body",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (!request.headers["Content-Type"].contains(ContentType.json.mimeType)){
        return Response("", HttpStatus.badRequest);
      }
      if (request.method != "POST"){
        return Response("", HttpStatus.methodNotAllowed);
      }
      if (request.url.toString() != "http://mydomain.com/v1/data"){
        return Response("", HttpStatus.notImplemented);
      }
      if (request.body != convert.jsonEncode({"key":1})){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          "",
          HttpStatus.created,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api);
    Future<String> response = client.post<String>(path,{"key":1});
    var data = await response;
    expect(data, "");

  });

  test("post should return status code as error on api failure",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      return Response("", HttpStatus.badRequest);
    });

    var client = ApiClient(mockClient, api);
    Future<String> response = client.post<String>(path,{"key":1});
    expect(response, throwsA(400));

  });

  test("withAdditionalHeaders should return return ApiClient that sends get request with given additional headers",()async{
    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (request.headers["Content-Type"]?.contains(ContentType.json.mimeType) ?? false){
        return Response("", HttpStatus.badRequest);
      }
      if (request.headers["HeaderKey"] != "HeaderValue"){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          convert.jsonEncode({"id":"1"}),
          HttpStatus.ok,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api);
    var clientWithAdditionalHeaders = client.withAdditionalHeaders({"HeaderKey":"HeaderValue"});
    Map<String, dynamic> response = await clientWithAdditionalHeaders.get<Map<String, dynamic>>(path);
    expect({"id":"1"}, response);
  });

  test("withAdditionalHeaders should return return ApiClient that sends post request with given additional headers",()async{
    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (!request.headers["Content-Type"].contains(ContentType.json.mimeType)){
        return Response("", HttpStatus.badRequest);
      }
      if (request.headers["HeaderKey"] != "HeaderValue"){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          convert.jsonEncode({"id":"1"}),
          HttpStatus.ok,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api);
    var clientWithAdditionalHeaders = client.withAdditionalHeaders({"HeaderKey":"HeaderValue"});
    Map<String, dynamic> response = await clientWithAdditionalHeaders.post<Map<String, dynamic>>(path,{});
    expect({"id":"1"}, response);
  });


  test("postForHeader should make the post request and return the value of header",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (!request.headers["Content-Type"].contains(ContentType.json.mimeType)){
        return Response("", HttpStatus.badRequest);
      }
      if (request.method != "POST"){
        return Response("", HttpStatus.methodNotAllowed);
      }
      if (request.url.toString() != "http://mydomain.com/v1/data"){
        return Response("", HttpStatus.notImplemented);
      }
      if (request.body != convert.jsonEncode({"key":1})){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          "",
          HttpStatus.created,
          headers: {'content-type': 'application/json',"authorization":"authvalue"}
      );
    });

    var client = ApiClient(mockClient, api);
    Future<String> response = client.postForHeader(path,{"key":1},"authorization");
    var data = await response;
    expect(data, "authvalue");

  });

  test("postForHeader should return status code as error on api failure",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      return Response("", HttpStatus.badRequest);
    });

    var client = ApiClient(mockClient, api);
    Future<String> response = client.postForHeader(path,{"key":1},"authorization");
    expect(response, throwsA(400));

  });

  test("create should make the post request with additional post parameters and return the json response",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      if (!request.headers["Content-Type"].contains(ContentType.json.mimeType)){
        return Response("", HttpStatus.badRequest);
      }
      if (request.method != "POST"){
        return Response("", HttpStatus.methodNotAllowed);
      }
      if (request.url.toString() != "http://mydomain.com/v1/data"){
        return Response("", HttpStatus.notImplemented);
      }
      if (request.body != convert.jsonEncode({"key":1,"additional":"1234"})){
        return Response("", HttpStatus.badRequest);
      }
      return Response(
          "",
          HttpStatus.created,
          headers: {'content-type': 'application/json'}
      );
    });

    var client = ApiClient(mockClient, api).withAdditionalCreateParameters({"additional":"1234"});
    Future<String> response = client.create(path,{"key":1});
    var data = await response;
    expect(data, "");

  });

  test("create should return status code as error on api failure",()async{

    var api = "http://mydomain.com/v1/";
    var path ="/data";

    var mockClient = MockClient((request) async {
      return Response("", HttpStatus.badRequest);
    });

    var client = ApiClient(mockClient, api);
    Future<String> response = client.create(path,{"key":1});
    expect(response, throwsA(400));

  });

}
