class Doctor {
  List<DoctorDatum> doctorData;
  int total_records;

  Doctor({
    required this.doctorData,
    required this.total_records,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
        doctorData: (json['doctorData'] as List)
            .map((data) => DoctorDatum.fromJson(data))
            .toList(),
        total_records: json['totalRecords']);
  }
}

class DoctorDatum {
  String id;
  String name;
  String email;
  String mobileNo;
  String address;
  int pincode;
  dynamic profileImage;
  String gender;
  List<String> speciality;
  List<String> availableHospital;
  // bool isDelete;
  DateTime createdAt;
  DateTime updatedAt;
  // int v;

  DoctorDatum({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.address,
    required this.pincode,
    required this.profileImage,
    required this.gender,
    required this.speciality,
    required this.availableHospital,
    // required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    // required this.v,
  });

  factory DoctorDatum.fromJson(Map<String, dynamic> json) {
    return DoctorDatum(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobileNo: json['mobileNo'],
      address: json['address'], // Change dynamic to String
      pincode: json['pincode'],
      profileImage: json['profileImage'],
      gender: json['gender'],
      speciality: List<String>.from(json['speciality']),
      availableHospital: List<String>.from(json['availableHospital']),
      // isDelete: json['isDelete'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      // v: json['__v'],
    );
  }
}

class AddDoctor {
  String name;
  String email;
  String mobileNo;
  String address;
  String pincode;
  String? profileImage;
  String? gender;
  String speciality;
  String availableHospital;

  AddDoctor({
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.address,
    this.profileImage,
    required this.gender,
    required this.availableHospital,
    required this.speciality,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobileNo': mobileNo,
      'address': address,
      'profileImage': profileImage,
      'pincode': pincode,
      'gender': gender,
      'speciality': speciality,
      'availableHospital': availableHospital,
    };
  }
}
