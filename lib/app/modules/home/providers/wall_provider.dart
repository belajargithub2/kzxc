import 'package:get/get.dart';
import 'package:wallpapers/app/data/settings.dart';
import 'package:wallpapers/app/modules/home/models/picture_model.dart';
import 'package:wallpapers/app/utils/cryptography.dart';

class WallProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) {
        return PictureModel.fromJson(map);
      }
      if (map is List) {
        return map.map((item) => PictureModel.fromJson(item)).toList();
      }
    };
    httpClient.defaultContentType = "application/json";
    var headers = {'Accept': "application/json"};
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(headers);
      return request;
    });
    httpClient.baseUrl = Cryptography.decryptFernet(uriw);
  }

  Future<PictureModel> findWall(String keyword, int page) async {
    Map<String, dynamic> body = {
      "text": keyword,
      "searchMode": "images",
      "source": "search",
      "cursor": page,
      "model": Cryptography.decryptFernet(mod)
    };
    final res = await post('/api/infinite-prompts', body);
    if (res.body == null) {
      return PictureModel();
    }
    return res.body;
  }
}
