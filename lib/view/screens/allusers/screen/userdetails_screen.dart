


// import 'package:adhiriya_ai_webapp/view/screens/allusers/screen/edituser.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../../../../constansts/const_colors.dart';
// import '../../../../model/usermodel.dart';
// import '../../../widgets/custom_roundedbutton.dart';
// import '../../auth_module/repo/apiservice.dart';
// import '../../profile/repo/provider.dart';

// class UserdetailsScreen extends ConsumerStatefulWidget {
//   final String userId;

//   const UserdetailsScreen({super.key, required this.userId});

//   @override
//   ConsumerState<UserdetailsScreen> createState() => _UserdetailsScreenState();
// }

// class _UserdetailsScreenState extends ConsumerState<UserdetailsScreen> {
//   late Future<UserData> userFuture;

//   @override
//   void initState() {
//     super.initState();
//     userFuture = ref.read(apiProvider).fetchUserDetails(widget.userId);
//   }

//   void _refreshUserDetails() {
//     setState(() {
//       userFuture = ref.read(apiProvider).fetchUserDetails(widget.userId);
//     });
//   }

//   void _showDeleteConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete User'),
//           content: const Text('Are you sure you want to delete this user?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Yes'),
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close the dialog
//                 bool success =
//                     await ref.read(apiProvider).deleteUser(widget.userId);
//                 if (success) {
//                   Fluttertoast.showToast(msg: 'User deleted successfully');
//                   Navigator.of(context).pop(); // Close the details screen
//                 } else {
//                   Fluttertoast.showToast(msg: 'Failed to delete user');
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Details'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           ref.refresh(usersProvider);
//           _refreshUserDetails();
//         },
//         child: FutureBuilder<UserData>(
//           future: userFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData) {
//               return const Center(child: Text('User not found'));
//             } else {
//               final user = snapshot.data!;
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: Colors.grey.shade200,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Name: ${user.name}',
//                               style: const TextStyle(fontSize: 18)),
//                           const SizedBox(height: 10),
//                           Text('Email: ${user.email}',
//                               style: const TextStyle(fontSize: 18)),
//                           const SizedBox(height: 10),
//                           Text('Phone: ${user.phone}',
//                               style: const TextStyle(fontSize: 18)),
//                           const SizedBox(height: 10),
//                           Text('Role: ${user.role}',
//                               style: const TextStyle(fontSize: 18)),
//                           const SizedBox(height: 10),
//                           Text('Created At: ${user.createdAt}',
//                               style: const TextStyle(fontSize: 18)),
//                           const SizedBox(height: 10),
//                           Text('Updated At: ${user.updatedAt}',
//                               style: const TextStyle(fontSize: 18)),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         RoundedButton(
//                           press: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EditUser(
//                                   user: user,
//                                    onSave: _refreshUserDetails,
//                                 ),
//                               ),
//                             );
//                           },
//                           text: const Text('Edit',
//                               style: TextStyle(color: Colors.white)),
//                           color: Colors.blue,
//                           width: 150.w,
//                         ),
//                         RoundedButton(
//                           // press: () {
//                           //   _showDeleteConfirmationDialog(context);
//                           // },

//                           press: () async {
//                 Navigator.of(context).pop(); // Close the dialog
                

//                 bool success = await ref.read(apiProvider).deleteUser(widget.userId);
// if (success) {
//   Fluttertoast.showToast(msg: 'User deleted successfully');

//     ref.refresh(usersProvider);
//   Navigator.of(context).pop(); // Close the details screen
// } else {
//   Fluttertoast.showToast(msg: 'Failed to delete user');
// }
//               },
//                           text: const Text('Delete',
//                               style: TextStyle(color: Colors.white)),
//                           color: Colors.red,
//                           width: 150.w,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
