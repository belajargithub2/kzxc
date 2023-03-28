import 'package:wallpapers/app/modules/home/models/image_model.dart';

class WallModel {
  int? page;
  List<Images>? images;
  List<String>? related;

  WallModel({this.page, this.images, this.related});

  WallModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    related = json['related'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['related'] = related;
    return data;
  }
}
