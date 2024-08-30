// To parse this JSON data, do
//
//     final enterprise = enterpriseFromJson(jsonString);

import 'dart:convert';

Enterprise enterpriseFromJson(String str) =>
    Enterprise.fromJson(json.decode(str));

String enterpriseToJson(Enterprise data) => json.encode(data.toJson());

class Enterprise {
  List<EnterpriseDetail> enterpriseDetails;
  int totalRecords;

  Enterprise({
    required this.enterpriseDetails,
    required this.totalRecords,
  });

  factory Enterprise.fromJson(Map<String, dynamic> json) => Enterprise(
        enterpriseDetails: List<EnterpriseDetail>.from(
            json["enterprise_details"]
                .map((x) => EnterpriseDetail.fromJson(x))),
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "enterprise_details":
            List<dynamic>.from(enterpriseDetails.map((x) => x.toJson())),
        "totalRecords": totalRecords,
      };
}

class EnterpriseDetail {
  String id;
  String name;
  String address;
  String status;
  String phoneNumber;
  String pinCode;
  String webSite;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  String? updatedBy;

  EnterpriseDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
    required this.phoneNumber,
    required this.pinCode,
    required this.webSite,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
  });

  factory EnterpriseDetail.fromJson(Map<String, dynamic> json) =>
      EnterpriseDetail(
        id: json["_id"],
        name: json["name"],
        address: json["address"],
        status: json["status"],
        phoneNumber: json["phoneNumber"],
        pinCode: json["pinCode"],
        webSite: json["webSite"],
        createdBy: json["createdBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
        "status": status,
        "phoneNumber": phoneNumber,
        "pinCode": pinCode,
        "webSite": webSite,
        "createdBy": createdBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "updatedBy": updatedBy,
      };
}

class AddEnterprise {
  String name;
  String mobileNo;
  String address;
  String pincode;
  String webiste;
  String status;

  AddEnterprise({
    required this.name,
    required this.mobileNo,
    required this.address,
    required this.pincode,
    required this.webiste,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': mobileNo,
      'address': address,
      'pinCode': pincode,
      'webSite': webiste,
      'status': status,
    };
  }
}
