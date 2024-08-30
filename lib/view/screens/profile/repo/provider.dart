import 'package:adhiriya_ai_webapp/model/doctormodel.dart';
import 'package:adhiriya_ai_webapp/model/healthcarecenter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/usermodel.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../auth_module/repo/apiservice.dart';

final userProvider = FutureProvider<UserDatum>((ref) async {
  final userId = await SharedPreferenceManager().getUserId();
  final apiService = AuthRepo();
  return apiService.fetchUserDetails(userId);
});
final usersProvider = FutureProvider<UserDataa>((ref) async {
  final authRepo = ref.read(apiProvider);
  return await authRepo.fetchAllUsers();
});
final doctorProvider = FutureProvider<Doctor>((ref) async {
  final authRepo = ref.read(apiProvider);
  return await authRepo.fetchAllDoctors();
});
final doctordetailProvider = FutureProvider<DoctorDatum>((ref) async {
  final userId = await SharedPreferenceManager().getUserId();
  final apiService = AuthRepo();
  return apiService.fetchDoctorDetails(userId);
});

final healthcarecenterprovider = FutureProvider<HealthCareCenter>((ref) async {
  final authRepo = ref.read(apiProvider);
  return await authRepo.fetchAllHealthCareCenter();
});

final usernameProvider = FutureProvider<String>((ref) async {
  return await SharedPreferenceManager().getfirstname();
  // return await SharedPreferenceManager().getlastname();
});
