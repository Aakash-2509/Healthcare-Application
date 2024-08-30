// To parse this JSON data, do
//
//     final healthCareCenter = healthCareCenterFromJson(jsonString);

import 'dart:convert';

HealthCareCenter healthCareCenterFromJson(String str) =>
    HealthCareCenter.fromJson(json.decode(str));

String healthCareCenterToJson(HealthCareCenter data) =>
    json.encode(data.toJson());

class HealthCareCenter {
  List<HealthCareCenterDatum> healthCareCenterData;
  int total_records;

  HealthCareCenter({
    required this.healthCareCenterData,
    required this.total_records,
  });

  factory HealthCareCenter.fromJson(Map<String, dynamic> json) =>
      HealthCareCenter(
          healthCareCenterData: List<HealthCareCenterDatum>.from(
              json["healthCareCenterData"]
                  .map((x) => HealthCareCenterDatum.fromJson(x))),
          total_records: json['totalRecords']);

  Map<String, dynamic> toJson() => {
        "healthCareCenterData":
            List<dynamic>.from(healthCareCenterData.map((x) => x.toJson())),
      };
}

class HealthCareCenterDatum {
  String id;
  String name;
  String email;
  String contact;
  String address;
  int pincode;
  List<String> speciality;
  String time;
  // bool isDelete;
  DateTime createdAt;
  DateTime updatedAt;
  // int v;

  HealthCareCenterDatum({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.pincode,
    required this.speciality,
    required this.time,
    // required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    // required this.v,
  });

  factory HealthCareCenterDatum.fromJson(Map<String, dynamic> json) =>
      HealthCareCenterDatum(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        contact: json["contact"],
        address: json["address"],
        pincode: json["pincode"],
        speciality: List<String>.from(json["speciality"].map((x) => x)),
        time: json["time"],
        // isDelete: json["isDelete"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        // v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "contact": contact,
        "address": address,
        "pincode": pincode,
        "speciality": List<dynamic>.from(speciality.map((x) => x)),
        "time": time,
        // "isDelete": isDelete,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        // "__v": v,
      };
}

class AddCenter {
  String name;
  String email;
  String mobileNo;
  String address;
  String pincode;
  String speciality;
  String time;

  AddCenter({
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.address,
    required this.speciality,
    required this.pincode,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'contact': mobileNo,
      'address': address,
      'pincode': pincode,
      'speciality': speciality,
      "time": time,
    };
  }
}
