import 'dart:convert';

import 'package:get/get.dart';
import 'package:wallpapers/app/data/settings.dart';
import 'package:wallpapers/app/utils/cryptography.dart';

class RelatedProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) {
        var list = [];
        map.forEach((_, value) => list.add("$value"));
        return list;
      }
      if (map is List) {
        return map;
      }
    };
    httpClient.defaultContentType = "application/json";
    var headers = {'Accept': "application/json"};
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(headers);
      return request;
    });
    httpClient.baseUrl = Cryptography.decryptFernet(urir);
  }

  Future<List<String>> getRelated(String keyword) async {
    Map<String, dynamic> body = {
      'query': keyword,
    };
    final res = await post('/api/related', body);
    var list = <String>[];
    if (res.body == null) {
      return list;
    }
    (jsonDecode("${res.bodyString}")).forEach((element) {
      list.add(element);
    });
    return list;
  }
}
