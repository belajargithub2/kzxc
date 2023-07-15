class PictureModel {
  int? nextCursor;
  List<Prompts>? prompts;
  List<Images>? images;
  int? count;

  PictureModel({this.nextCursor, this.prompts, this.images, this.count});

  PictureModel.fromJson(Map<String, dynamic> json) {
    nextCursor = json['nextCursor'];
    if (json['prompts'] != null) {
      prompts = <Prompts>[];
      json['prompts'].forEach((v) {
        prompts!.add(Prompts.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nextCursor'] = nextCursor;
    if (prompts != null) {
      data['prompts'] = prompts!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class Prompts {
  String? id;
  String? prompt;
  String? negativePrompt;
  String? timestamp;
  bool? grid;
  String? seed;
  String? model;
  int? width;
  int? height;
  bool? isPrivate;
  List<Images>? images;

  Prompts(
      {this.id,
      this.prompt,
      this.negativePrompt,
      this.timestamp,
      this.grid,
      this.seed,
      this.model,
      this.width,
      this.height,
      this.isPrivate,
      this.images});

  Prompts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prompt = json['prompt'];
    negativePrompt = json['negativePrompt'];
    timestamp = json['timestamp'];
    grid = json['grid'];
    seed = json['seed'];
    model = json['model'];
    width = json['width'];
    height = json['height'];
    isPrivate = json['is_private'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prompt'] = prompt;
    data['negativePrompt'] = negativePrompt;
    data['timestamp'] = timestamp;
    data['grid'] = grid;
    data['seed'] = seed;
    data['model'] = model;
    data['width'] = width;
    data['height'] = height;
    data['is_private'] = isPrivate;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? id;
  String? promptid;
  int? width;
  int? height;
  int? upscaledWidth;
  int? upscaledHeight;
  String? userid;
  String? url;

  Images({
    this.id,
    this.promptid,
    this.width,
    this.height,
    this.upscaledWidth,
    this.upscaledHeight,
    this.userid,
    this.url,
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promptid = json['promptid'];
    width = json['width'];
    height = json['height'];
    upscaledWidth = json['upscaled_width'];
    upscaledHeight = json['upscaled_height'];
    userid = json['userid'];
    url = "https://image.lexica.art/full_jpg/${json['id']}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['promptid'] = promptid;
    data['width'] = width;
    data['height'] = height;
    data['upscaled_width'] = upscaledWidth;
    data['upscaled_height'] = upscaledHeight;
    data['userid'] = userid;
    data['url'] = url;
    return data;
  }
}
