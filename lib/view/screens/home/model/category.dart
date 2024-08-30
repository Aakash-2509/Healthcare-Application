// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

// import 'dart:convert';

// Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

// String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  List<CategoryElement> categories;
  int totalRecords;

  Category({
    required this.categories,
    required this.totalRecords,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categories: List<CategoryElement>.from(
            json["categories"].map((x) => CategoryElement.fromJson(x))),
        totalRecords: json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "total_records": totalRecords,
      };
}

class CategoryElement {
  String id;
  String name;
  String keyName;
  String description;
  String status;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  CategoryElement({
    required this.id,
    required this.name,
    required this.keyName,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) =>
      CategoryElement(
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
        "name": first_name + last_name,
      };
}
