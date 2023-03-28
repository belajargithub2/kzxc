class ResponseModel {
  int? code;
  bool? success;
  String? message;
  dynamic data;

  ResponseModel({this.code, this.success, this.message, this.data});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final datas = <String, dynamic>{};
    datas['code'] = code;
    datas['success'] = success;
    datas['message'] = message;
    datas['data'] = data;
    return datas;
  }
}
