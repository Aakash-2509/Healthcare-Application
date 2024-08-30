// To parse this JSON data, do
//
//     final categoryDetail = categoryDetailFromJson(jsonString);

import 'dart:convert';

CategoryDetail categoryDetailFromJson(String str) =>
    CategoryDetail.fromJson(json.decode(str));

String categoryDetailToJson(CategoryDetail data) => json.encode(data.toJson());

class CategoryDetail {
  CategoryDetails categoryDetails;

  CategoryDetail({
    required this.categoryDetails,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        categoryDetails: CategoryDetails.fromJson(json["category_details"]),
      );

  Map<String, dynamic> toJson() => {
        "category_details": categoryDetails.toJson(),
      };
}

class CategoryDetails {
  String id;
  String name;
  String keyName;
  String description;
  String status;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  CategoryDetails({
    required this.id,
    required this.name,
    required this.keyName,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      CategoryDetails(
        id: json["_id"],
        name: json["name"],
        keyName: json["key_name"],
        description: json["description"],
        status: json["status"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "key_name": keyName,
        "description": description,
        "status": status,
        "created_by": createdBy.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class CreatedBy {
  String id;
  String first_name;
  String last_name;

  CreatedBy({
    required this.id,
    required this.first_name,
    required this.last_name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        first_name: json["firstName"],
        last_name: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": first_name,
        "lastName": last_name,
      };
}
