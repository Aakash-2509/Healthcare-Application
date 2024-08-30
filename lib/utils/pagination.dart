// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';

// import '../view/screens/allusers/screen/allusers_screen.dart';
// import '../view/screens/allusers/screen/adduser_screen.dart';
// import '../view/screens/allusers/screen/edituser.dart';
// import '../view/screens/auth_module/reset/resetpassword.dart';
// import '../view/screens/auth_module/signin/signin_screen.dart';
// import '../view/screens/home/screen/addcategoriesscreen.dart';
// import '../view/screens/home/screen/bottomnavigation.dart';
// import '../view/screens/home/categorydetailsscreen.dart';
// import '../view/screens/home/homescreen.dart';
// import '../view/screens/profile/screen/profile_screen.dart';
// import '../view/screens/splash/splash_screen.dart';
// import '../sharedpreference/sharedpreference.dart';
// import '../view/screens/profile/repo/provider.dart';

// class AppRoutes {
//   static final routes = [
//     GetPage(
//       name: '/',
//       page: () => SplashScreen(),
//     ),
//     GetPage(
//       name: '/signin',
//       page: () => SigninScreen(),
//     ),
//     GetPage(
//       name: '/resetpassword',
//       page: () => ResetPassword(),
//     ),
//     GetPage(
//       name: '/profile',
//       page: () => ProfileScreen(),
//     ),
//     GetPage(
//       name: '/alluserscreen',
//       page: () => AllusersScreen(),
//     ),
//     GetPage(
//       name: '/adduser',
//       page: () => AdduserScreen(),
//     ),
//     GetPage(
//       name: '/edituser/:id',
//       page: () => EditUser(
//         user: Get.parameters['id'] != null
//             ? ProviderContainer().read(usersProvider).value?.firstWhere((user) => user.id == Get.parameters['id'])
//             : null,
//         onSave: () {
//           ProviderContainer().refresh(usersProvider);
//           Get.back(); // Navigate back after save
//         },
//       ),
//     ),
//     GetPage(
//       name: '/home',
//       page: () => FutureBuilder<String>(
//         future: SharedPreferenceManager().getrole(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(); // Show a loading indicator while waiting
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}'); // Handle error
//           } else if (snapshot.hasData) {
//             final userRole = snapshot.data!;
//             return Homescreen(role: userRole);
//           } else {
//             return Text('No role found'); // Handle no data
//           }
//         },
//       ),
//       children: [
//         GetPage(
//           name: '/home/category/:id',
//           page: () => CategoryDetailsScreen(
//             categoryId: Get.parameters['id'],
//           ),
//         ),
//         GetPage(
//           name: '/home/profile',
//           page: () => ProfileScreen(),
//         ),
//         GetPage(
//           name: '/home/alluserscreen',
//           page: () => AllusersScreen(),
//         ),
//         GetPage(
//           name: '/home/addcategory',
//           page: () => AddCategoryScreen(),
//         ),
//       ],
//     ),
//   ];
// }
