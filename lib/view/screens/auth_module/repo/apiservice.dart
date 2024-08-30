// view/screens/auth_module/repo/apiservice.dart
import 'dart:developer';
import 'dart:developer';

import 'package:adhiriya_ai_webapp/global/global.dart';
import 'package:adhiriya_ai_webapp/model/doctormodel.dart';
import 'package:adhiriya_ai_webapp/model/enterprisemodel.dart';
import 'package:adhiriya_ai_webapp/model/healthcarecenter.dart';
import 'package:adhiriya_ai_webapp/model/usermodel.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/model/category.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/model/categorydetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';

import '../../../../constansts/const_colors.dart';
import '../../../../repo/api_call.dart';

class AuthRepo {
  API api = API();

  Future signUpUser(User user) async {
    try {
      final response = await api.sendRequest.post(
        Global.signup,
        data: user.toJson(),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Failed to sign up');
        return false;
      }
    } on DioException catch (error) {
      // Handle other Dio exceptions if necessary
      Fluttertoast.showToast(
        msg: " ${error.response?.data["Error"]}",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ConstColors.black,
        textColor: ConstColors.backgroundColor,
        fontSize: 16.0,
      );
      return false;
    } catch (error, stackTrace) {
      print("Error signing up user: $error $stackTrace");
      // Handle unexpected errors
      return false;
    }
  }

  Future<Category> fetchCategories(String role,
      {String searchQuery = '', int page = 1, int size = 10}) async {
    final usertoken = await SharedPreferenceManager().getToken();
    String url =
        'https://sample-basic-api.onrender.com/categories?page=$page&size=$size';

    if (searchQuery.isNotEmpty) {
      url += '&searchBy=name&searchValue=$searchQuery';
    }

    try {
      final response = await api.sendRequest.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $usertoken",
          },
        ),
      );
      if (response.statusCode == 200) {
        log(response.data.toString());
        return Category.fromJson(response.data);
      } else {
        log('Error: ${response.statusCode}, ${response.statusMessage}');
        throw Exception('Failed to load categories');
      }
    } catch (e, stackTrace) {
      log("Error: $e, StackTrace: $stackTrace");
      throw Exception('Error is: $e, StackTrace: $stackTrace');
    }
  }

  // Future<Category> fetchCategories(String role,
  //     {String searchQuery = ''}) async {
  //   final usertoken = await SharedPreferenceManager().getToken();
  //   String url = 'https://sample-basic-api.onrender.com/categories';
  //   // if (searchQuery.isNotEmpty) {
  //   //   url += '?searchBy=name&searchValue=$searchQuery';
  //   // }
  //   if (searchQuery.isNotEmpty) {
  //     url += '?searchBy=name&searchValue=$searchQuery';
  //   }

  //   try {
  //     final response = await api.sendRequest.get(
  //       url,
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $usertoken",
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       log(response.data.toString());
  //       return Category.fromJson(response.data);
  //     } else {
  //       log('Error: ${response.statusCode}, ${response.statusMessage}');
  //       throw Exception('Failed to load categories');
  //     }
  //   } catch (e, stackTrace) {
  //     log("Error: $e, StackTrace: $stackTrace");
  //     throw Exception('Error is: $e, StackTrace: $stackTrace');
  //   }
  // }

  Future<void> addCategory({
    required String name,
    required String keyName,
    required String description,
    required String status,
  }) async {
    const String url = 'https://sample-basic-api.onrender.com/category';
    final dynamic token = await SharedPreferenceManager().getToken();

    try {
      Response response = await api.sendRequest.post(
        url,
        data: {
          'name': name,
          'key_name': keyName,
          'description': description,
          'status': status,
        },
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      if (response.statusCode == 201) {
        log('Category added successfully');
      } else {
        log('Failed to add category');
      }
    } catch (e, StackTrace) {
      log('Error adding category: $e, $StackTrace');
    }
  }

  Future<CategoryDetails> fetchCategoryById(dynamic categoryId) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      // Make API call to fetch category details by ID
      final usertoken = await SharedPreferenceManager().getToken();
      Response response = await api.sendRequest.get(
        'https://sample-basic-api.onrender.com/category?id=$categoryId',
        options: Options(
          headers: {
            'Authorization': "Bearer $usertoken",
          },
        ),
      );
      if (response.statusCode == 200) {
        // Parse the response data
        log("Data ${response.data}");
        return CategoryDetails.fromJson(response.data['category_details']);
      } else {
        log("Error");
        throw Exception('Failed to load category details');
      }
    } catch (e, StackTrace) {
      log("Error: $e,$StackTrace");
      throw Exception('Error is : $e,$StackTrace');
    }
  }

  Future<void> editCategory({
    required dynamic categoryId,
    required String name,
    required String description,
    required String keyname,
    required String status,
  }) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      // Make API call to edit category details
      final usertoken = await SharedPreferenceManager().getToken();
      Response response = await api.sendRequest.patch(
        'https://sample-basic-api.onrender.com/category?id=$categoryId',
        data: {
          'name': name,
          'description': description,
          'key_name': keyname,
          'status': status,
        },
        options: Options(
          headers: {
            'Authorization': "Bearer $usertoken",
          },
        ),
      );
      if (response.statusCode == 200) {
        // Edit successful
        log('Category edited successfully');
      } else {
        throw Exception('Failed to edit category');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteCategory(dynamic categoryId) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      final usertoken = await SharedPreferenceManager().getToken();
      final response = await api.sendRequest.delete(
        'https://sample-basic-api.onrender.com/category?id=$categoryId',
        options: Options(
          headers: {
            'Authorization': "Bearer $usertoken",
          },
        ),
      );
      if (response.statusCode == 200) {
        log('Category deleted successfully');
        return true;
      } else {
        throw Exception('Failed to delete category');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('DioError Response: ${e.response?.statusCode}');
        log('DioError Response data: ${e.response?.data}');
        log('DioError Response headers: ${e.response?.headers}');
      } else {
        log('DioError Request: ${e.requestOptions}');
        log('DioError Message: ${e.message}');
      }
      throw Exception('Error: $e');
    }
  }

  Future<bool> resetPassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      final response = await api.sendRequest.post(
        Global.reset,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Password reset successful!');
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Failed to reset password');
        return false;
      }
    }
    // catch (e) {
    //   print('Error resetting password: $e');
    //   Fluttertoast.showToast(msg: 'Error resetting password');
    //   return false;
    // }
    on DioException catch (error) {
      // Handle other Dio exceptions if necessary
      // Fluttertoast.showToast(
      //   msg: " ${error.response?.data["message"]}",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 0,
      //   backgroundColor: ConstColors.black,
      //   textColor: ConstColors.backgroundColor,
      //   fontSize: 16.0,
      // );

      Fluttertoast.showToast(
        msg: " ${error.response?.data["message"]}",
      );
      return false;
    } catch (error, stackTrace) {
      print("Error resetting password: $error $stackTrace");
      // Handle unexpected errors
      return false;
    }
  }

  Future<UserDatum> fetchUserDetails(String userId) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.get(
        'user?id=$userId',
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return UserDatum.fromJson(response.data['userData']);
        // return UserDataa(
        // dob: response.data['userData']['dob'],
        // gender: response.data['userData']['gender'],
        // id: response.data['userData']['_id'],
        // firstName: response.data['userData']['firstName'],
        // lastName: response.data['userData']['lastName'],
        // email: response.data['userData']['email'],
        // phone: response.data['userData']['mobileNo'],
        // notificationToken: response.data['userData']['notification_token'],
        // role: response.data['userData']['role'],
        // createdAt: response.data['userData']['createdAt'],
        // updatedAt: response.data['userData']['updatedAt'],
        // version: response.data['userData']['__v'],
        // );
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error, stackTrace) {
      print("error for address is this $error $stackTrace");
      rethrow;
    }
  }

  Future<UserDataa> fetchAllUsers({int page = 1, int size = 10}) async {
    final usertoken = await SharedPreferenceManager().getToken();

    print(
        " usertocken.......................................................$usertoken");
    String url =
        'https://sample-basic-api.onrender.com/user?page=$page&size=$size';

    try {
      final response = await api.sendRequest.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        // List<dynamic> responseData = response.data['userData'];
        // List<UserDataa> users =
        //     responseData.map((user) => UserDataa.fromJson(user)).toList();
        return UserDataa.fromJson(response.data);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error, stackTrace) {
      print("error fetching users: $error $stackTrace");
      rethrow;
    }
  }

  Future<bool> updateUser(
    String userId,
    String firstname,
    String lastname,
    String dob,
    String gender,
    String phone,
  ) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.put(
        'https://sample-basic-api.onrender.com/user?id=$userId',
        data: {
          'firstName': firstname,
          'mobileNo': phone,
          'lastName': lastname,
          'dob': dob,
          'gender': gender,
        },
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error, stackTrace) {
      print("Error updating user: $error $stackTrace");
      rethrow;
    }
  }

  Future<bool> deleteUser(String userId) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.delete(
        'https://sample-basic-api.onrender.com/user?id=$userId',
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error, stackTrace) {
      print("Error deleting user: $error $stackTrace");
      rethrow;
    }
  }

  Future<Doctor> fetchAllDoctors({int page = 1, int size = 10}) async {
    final usertoken = await SharedPreferenceManager().getToken();

    print(
        " usertocken.......................................................$usertoken");
    String url =
        'https://sample-basic-api.onrender.com/doctor?page=$page&size=$size';

    try {
      final response = await api.sendRequest.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['doctorData'];
        // List<DoctorDatum> users =

        // responseData.map((user) => DoctorDatum.fromJson(user)).toList();
        // return users;
        return Doctor.fromJson(response.data);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error, stackTrace) {
      print("error fetching doctors: $error $stackTrace");
      rethrow;
    }
  }

  Future addDoctor(AddDoctor doctor) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      final response = await api.sendRequest.post(
        Global.adddoctor,
        data: doctor.toJson(),
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Failed to add doctor');
        return false;
      }
    } catch (e) {
      print('Error adding doctor: $e');
      Fluttertoast.showToast(msg: 'Error adding doctor');
      return false;
    }
  }

  Future<bool> updateDoctor(
    String userId,
    String name,
    String phone,
    String address,
    String pincode,
    String speciality,
    String availableHospital,
    String gender,
  ) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.put(
        'https://sample-basic-api.onrender.com/doctor?id=$userId',
        data: {
          'name': name,
          'phone': phone,
          'address': address,
          'pincode': pincode,
          'speciality': speciality,
          'availableHospital': availableHospital,
          'gender': gender,
        },
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error, stackTrace) {
      print("Error updating user: $error $stackTrace");
      rethrow;
    }
  }

  Future<DoctorDatum> fetchDoctorDetails(String doctorId) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.get(
        'dcotor?id=$doctorId',
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return DoctorDatum(
          id: response.data['doctorData']['_id'],
          name: response.data['doctorData']['name'],
          email: response.data['doctorData']['email'],
          mobileNo: response.data['doctorData']['mobileNo'],
          createdAt: response.data['doctorData']['createdAt'],
          updatedAt: response.data['doctorData']['updatedAt'],
          address: response.data['doctorData']['address'],
          availableHospital: response.data['doctorData']['availableHospital'],
          gender: response.data['doctorData']['gender'],
          pincode: response.data['doctorData']['pincode'],
          profileImage: response.data['doctorData']['profileImage'],
          speciality: response.data['doctorData']['speciality'],
          // isDelete: false,
          // v: response.data['doctorData']['__v'],
        );
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error, stackTrace) {
      print("error for address is this $error $stackTrace");
      rethrow;
    }
  }

  Future<bool> deleteDoctor(String userId) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.delete(
        'https://sample-basic-api.onrender.com/doctor?id=$userId',
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error, stackTrace) {
      print("Error deleting user: $error $stackTrace");
      rethrow;
    }
  }

  Future<HealthCareCenter> fetchAllHealthCareCenter(
      {int page = 1, int size = 10}) async {
    final usertoken = await SharedPreferenceManager().getToken();

    print(
        " usertocken.......................................................$usertoken");
    String url =
        'https://sample-basic-api.onrender.com/healthcareCenter?page=$page&size=$size';

    try {
      final response = await api.sendRequest.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['healthCareCenterData'];
        // List<HealthCareCenterDatum> users = responseData
        //     .map((user) => HealthCareCenterDatum.fromJson(user))
        //     .toList();
        // return users;
        return HealthCareCenter.fromJson(response.data);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error, stackTrace) {
      print("error fetching health centers: $error $stackTrace");
      rethrow;
    }
  }

  Future<bool> deleteCenter(String userId) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.delete(
        'https://sample-basic-api.onrender.com/healthcareCenter?id=$userId',
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error, stackTrace) {
      print("Error deleting user: $error $stackTrace");
      rethrow;
    }
  }

  Future<bool> updateCenter(
    String userId,
    String name,
    String phone,
    String address,
    String pincode,
    String speciality,
    String time,
  ) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.put(
        'https://sample-basic-api.onrender.com/healthcareCenter?id=$userId',
        data: {
          'name': name,
          'contact': phone,
          'address': address,
          'pincode': pincode,
          'speciality': speciality,
          'time': time,
        },
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update center');
      }
    } catch (error, stackTrace) {
      print("Error updating center: $error $stackTrace");
      rethrow;
    }
  }

  Future addCenter(AddCenter center) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      final response = await api.sendRequest.post(
        Global.addcenter,
        data: center.toJson(),
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        Fluttertoast.showToast(msg: 'Failed to add center');
        return false;
      }
    } catch (e) {
      print('Error adding center: $e');
      Fluttertoast.showToast(msg: 'Error adding center');
      return false;
    }
  }

  Future<Enterprise> fetchAllEnterprise({int page = 1, int size = 10}) async {
    final usertoken = await SharedPreferenceManager().getToken();

    print(
        " usertocken.......................................................$usertoken");
    String url =
        'https://sample-basic-api.onrender.com/enterprise?page=$page&size=$size';

    try {
      final response = await api.sendRequest.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['enterprise_details'];

        return Enterprise.fromJson(response.data);
      } else {
        throw Exception('Failed to load enterprise');
      }
    } catch (error, stackTrace) {
      print("error fetching enterprise: $error $stackTrace");
      rethrow;
    }
  }

  Future addEnterprise(AddEnterprise enterprise) async {
    final usertoken = await SharedPreferenceManager().getToken();
    try {
      final response = await api.sendRequest.post(
        Global.addenterprise,
        data: enterprise.toJson(),
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e, StackTrace) {
      print('Error adding center: $e $StackTrace');
      Fluttertoast.showToast(msg: 'Error adding enterprise');
      return false;
    }
  }

  Future<bool> deleteEnterprise(String enterpriseId) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.delete(
        'https://sample-basic-api.onrender.com/enterprise?id=$enterpriseId',
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete enterprise');
      }
    } catch (error, stackTrace) {
      print("Error deleting enterprise: $error $stackTrace");
      rethrow;
    }
  }

  Future<bool> updateEnterprise(
    String id,
    String name,
    String phone,
    String address,
    String pincode,
    String webSite,
    String status,
  ) async {
    final usertoken = await SharedPreferenceManager().getToken();

    try {
      final response = await api.sendRequest.patch(
        'https://sample-basic-api.onrender.com/enterprise?id=$id',
        data: {
          'name': name,
          'phoneNumber': phone,
          'address': address,
          'pinCode': pincode,
          'webSite': webSite,
          'status': status,
        },
        options: Options(headers: {
          "Authorization": "Bearer $usertoken",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update enterprise');
      }
    } catch (error, stackTrace) {
      print("Error updating center: $error $stackTrace");
      rethrow;
    }
  }
}

final apiProvider = Provider((ref) => AuthRepo());

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo();
});

final categoriesProvider =
    FutureProvider.family<Category, Tuple3<String, int, int>>((ref, params) {
  final searchQuery = params.item1;
  final currentPage = params.item2;
  final pageSize = params.item3;
  final role = SharedPreferenceManager().getrole;
  return AuthRepo()
      .fetchCategories(searchQuery, page: currentPage, size: pageSize);
});

final doctorsProvider =
    FutureProvider.family<Doctor, Tuple2<int, int>>((ref, params) {
  final currentPage = params.item1;
  final pageSize = params.item2;
  return AuthRepo().fetchAllDoctors(page: currentPage, size: pageSize);
});

final centersProvider =
    FutureProvider.family<HealthCareCenter, Tuple2<int, int>>((ref, params) {
  final currentPage = params.item1;
  final pageSize = params.item2;
  return AuthRepo().fetchAllHealthCareCenter(page: currentPage, size: pageSize);
});

final allUsersProvider =
    FutureProvider.family<UserDataa, Tuple2<int, int>>((ref, params) {
  final currentPage = params.item1;
  final pageSize = params.item2;
  return AuthRepo().fetchAllUsers(page: currentPage, size: pageSize);
});
final allenterprise =
    FutureProvider.family<Enterprise, Tuple2<int, int>>((ref, params) {
  final currentPage = params.item1;
  final pageSize = params.item2;
  return AuthRepo().fetchAllEnterprise(page: currentPage, size: pageSize);
});
