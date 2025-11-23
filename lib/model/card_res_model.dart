// To parse this JSON data, do
//
//     final cardResModel = cardResModelFromJson(jsonString);

import 'dart:convert';

List<CardResModel> cardResModelFromJson(String str) => List<CardResModel>.from(
  json.decode(str).map((x) => CardResModel.fromJson(x)),
);

String cardResModelToJson(List<CardResModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CardResModel {
  final String? id;
  final String? type;
  final int? priority;
  final Data? data;

  CardResModel({this.id, this.type, this.priority, this.data});

  factory CardResModel.fromJson(Map<String, dynamic> json) => CardResModel(
    id: json["id"],
    type: json["type"],
    priority: json["priority"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "priority": priority,
    "data": data?.toJson(),
  };
}

class Data {
  final String? title;
  final String? description;

  Data({this.title, this.description});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(title: json["title"], description: json["description"]);

  Map<String, dynamic> toJson() => {"title": title, "description": description};
}
