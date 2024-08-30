import 'package:adhiriya_ai_webapp/utils/pagination.dart';
import 'package:adhiriya_ai_webapp/view/screens/alldoctorsscreen/screen/adddoctorscreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/alldoctorsscreen/screen/alldoctorscreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/alldoctorsscreen/screen/editdoctorscreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/allenterprisescreen/addenterprisescreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/allenterprisescreen/allenterprisescreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/allenterprisescreen/editenterprisescreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/allhealthcarecenterscreen/screens/addcenterscreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/allhealthcarecenterscreen/screens/allhealthcarecenterscreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/allhealthcarecenterscreen/screens/edithealthcarecenterscreen.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/settingscreen.dart';
// import 'package:adhiriya_ai_webapp/view/screens/auth_module/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sharedpreference/sharedpreference.dart';
import '../view/screens/allusers/screen/adduser_screen.dart';
import '../view/screens/allusers/screen/allusers_screen.dart';
import '../view/screens/allusers/screen/edituser.dart';
import '../view/screens/auth_module/reset/resetpassword.dart';
import '../view/screens/auth_module/signin/signin_screen.dart';
import '../view/screens/auth_module/signup/signup_screen.dart';
import '../view/screens/home/categorydetailsscreen.dart';
import '../view/screens/home/homescreen.dart';
import '../view/screens/home/screen/addcategoriesscreen.dart';
import '../view/screens/profile/screen/profile_screen.dart';
import '../view/screens/splash/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: '/alluserscreen',
        page: () => const AllusersScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/alldoctorscreen',
        page: () => const Alldoctorscreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/adddoctorscreen',
        page: () => const Addadoctorscreen(),
        transition: Transition.noTransition),
    GetPage(
      name: '/editcategory/:id',
      page: () => CategoryDetailsScreen(
        categoryId: Get.parameters['id'],
      ),
    ),
    GetPage(
        name: '/edituser',
        page: () => EditUser(
              user: Get.arguments['user'],
              onSave: Get.arguments['onSave'],
            ),
        transition: Transition.noTransition),
    // GetPage(
    //   name: '/edituser/:id',
    //   page: () => EditUser(
    //     user: Get.find<UsersController>()
    //         .users
    //         .firstWhere((user) => user.id == Get.parameters['id']),
    //     onSave: () {
    //       Get.find<UsersController>().refreshUsers();
    //     },
    //   ),
    // ),
    GetPage(
        name: '/profile',
        page: () => const ProfileScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/addcategory',
        page: () => AddCategoryScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/signin',
        page: () => const SigninScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/',
        page: () => FutureBuilder<String>(
              future: SharedPreferenceManager().getrole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle error
                } else if (snapshot.hasData) {
                  final userRole = snapshot.data!;
                  // return Homescreen(role: userRole);
                  return const AllusersScreen();
                } else {
                  return const Text('No role found'); // Handle no data
                }
              },
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/resetpassword',
        page: () => const ResetPassword(),
        transition: Transition.noTransition),
    GetPage(
        name: '/adduser',
        page: () => const AdduserScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/signup',
        page: () => const SignupScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/editdoctor',
        page: () => Editdoctorscreen(
              doctor: Get.arguments['doctor'],
              onSave: Get.arguments['onSave'],
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/allhealthcarecenter',
        page: () => const Allhealthcarecenterscreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/editcenter',
        page: () => Editcenterscreen(
              center: Get.arguments['center'],
              onSave: Get.arguments['onSave'],
            ),
        transition: Transition.noTransition),
    GetPage(
        name: '/addcenterscreen',
        page: () => const Addcenterscreen(),
        transition: Transition.noTransition),
    GetPage(
        name: '/setting',
        page: () => const SettingsScreen(),
        transition: Transition.noTransition),
    GetPage(
      name: '/allenterprisescreen',
      page: () => const Allenterprisescreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/addenterprisescreen',
      page: () => const Addenterprisescreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/editenterprisescreen',
      page: () => Editenterprisescreen(
        enterprise: Get.arguments['enterprise'],
        onSave: Get.arguments['onSave'],
      ),
      transition: Transition.noTransition,
    ),
  ];
}
