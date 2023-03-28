import 'package:wallpapers/app/modules/home/models/wall_model.dart';
import 'package:get/get.dart';

class WallProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) {
        return WallModel.fromJson(map);
      }
      if (map is List) {
        return map.map((item) => WallModel.fromJson(item)).toList();
      }
    };
    httpClient.defaultContentType = "application/json";
    var headers = {'Accept': "application/json"};
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(headers);
      return request;
    });
    httpClient.baseUrl = 'https://wall.ihsanbagus.com';
  }

  Future<WallModel> findWall(String keyword, int page) async {
    Map<String, dynamic> body = {
      'query': keyword,
      'page': page,
    };
    final res = await post('/api', body);
    if (res.body == null) {
      return WallModel();
    }
    return res.body;
  }
}
