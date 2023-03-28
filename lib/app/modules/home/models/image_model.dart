class Images {
  String? id;
  String? title;
  String? url;

  Images({this.id, this.title, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
