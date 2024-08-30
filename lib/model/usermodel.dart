import 'dart:convert';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNo;
  final String password;
  final String countryCode;
  final String role;
  // final String? gender;
  // final String? dob;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    required this.password,
    required this.countryCode,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNo': mobileNo,
      'password': password,
      // 'gender': gender,
      //  'dob': dob,
      'countryCode': countryCode,
      'roleId': role,
    };
  }
}

class UserData {
  final String id;

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? profileImage;
  final String? notificationToken;
  // final String role;
  RoleId roleId;
  final String? dob;
  final String? gender;
  final int? countryCode;
  final String createdAt;
  final String updatedAt;
  // final int version;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImage,
    this.notificationToken,
    // required this.role,
    required this.roleId,
    this.dob,
    this.gender,
    this.countryCode,
    required this.createdAt,
    required this.updatedAt,
    // required this.version,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'] ?? json['mobileNo'],
      profileImage: json['profileImage'],
      notificationToken: json['notification_token'] ?? "",
      // role: json['role'],
      roleId: RoleId.fromJson(json["roleId"]),
      dob: json['dob'],
      gender: json['gender'],
      countryCode: json['countryCode'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      // version: json['__v'],
    );
  }
}

// To parse this JSON data, do

//   final userDataa = userDataaFromJson(jsonString);

UserDataa userDataaFromJson(String str) => UserDataa.fromJson(json.decode(str));

String userDataaToJson(UserDataa data) => json.encode(data.toJson());

class UserDataa {
  List<UserDatum> userData;
  int totalRecords;

  UserDataa({
    required this.userData,
    required this.totalRecords,
  });

  factory UserDataa.fromJson(Map<String, dynamic> json) => UserDataa(
        userData: List<UserDatum>.from(
            json["userData"].map((x) => UserDatum.fromJson(x))),
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "userData": List<dynamic>.from(userData.map((x) => x.toJson())),
        "totalRecords": totalRecords,
      };
}

class UserDatum {
  final double? height;
  final double? weight;
  final String? empId;
  final String? deviceId;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNo;
  final String? profileImage;
  final String? dob;
  final String? gender;
  final int? countryCode;
  // final List<Token> tokens;
  // final String? notificationToken;
  // final String role;
  RoleId roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDatum({
    required this.height,
    required this.weight,
    required this.empId,
    this.deviceId,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    this.profileImage,
    this.dob,
    this.gender,
    this.countryCode,
    // required this.tokens,
    // this.notificationToken,
    // required this.role,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDatum.fromJson(Map<String, dynamic> json) => UserDatum(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        mobileNo: json["mobileNo"],
        profileImage: json["profileImage"],
        dob: json["dob"],
        gender: json["gender"],
        height: json["height"],
        weight: json["weight"],
        empId: json["empId"],
        deviceId: json["deviceId"],
        countryCode: json["countryCode"],
        // tokens: List<Token>.from(json["tokens"].map((x) => Token.fromJson(x))),
        // notificationToken: json["notificationToken"],
        // role: json["roleId"],
        roleId: RoleId.fromJson(json["roleId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "weight": weight,
        "empId": empId,
        "deviceId": deviceId,
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "mobileNo": mobileNo,
        // "password": password,
        // "profileImage": profileImage,
        // "dob": dob.toIso8601String(),
        "gender": gender,
        "countryCode": countryCode,
        // "tokens": List<dynamic>.from(tokens.map((x) => x.toJson())),
        // "notification_token": notificationToken,
        "role": roleId.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class RoleId {
  String id;
  String name;

  RoleId({
    required this.id,
    required this.name,
  });

  factory RoleId.fromJson(Map<String, dynamic> json) => RoleId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Token {
  String token;
  String id;

  Token({
    required this.token,
    required this.id,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        token: json["token"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "_id": id,
      };
}
