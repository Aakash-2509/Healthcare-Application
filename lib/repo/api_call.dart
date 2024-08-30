// // import 'package:dio/dio.dart';
// // import 'package:talker_dio_logger/talker_dio_logger.dart';
// // import '../global/global.dart';



// // class API {
// //   final Dio _dio = Dio();

// //   API() {
// //     _dio.options.baseUrl = Global.hostUrl;
// //     _dio.interceptors.add(TalkerDioLogger(
// //         settings: const TalkerDioLoggerSettings(
// //           printRequestHeaders: true,
// //           printResponseHeaders: true,
// //           printResponseMessage: true,
// //         ),
// //     ),);
// //   }

// //   Dio get sendRequest => _dio;
// // }



// // api.dart

// import 'package:dio/dio.dart';
// import 'package:talker_dio_logger/talker_dio_logger.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../global/global.dart';
// import '../model/usermodel.dart';


// class API {
//   final Dio _dio = Dio();

//   API() {
//     _dio.options.baseUrl = Global.hostUrl;
//     _dio.interceptors.add(TalkerDioLogger(
//       settings: const TalkerDioLoggerSettings(
//         printRequestHeaders: true,
//           printResponseHeaders: true,
//           printResponseMessage: true,
//       ),
//     ));
//   }

//   Dio get sendRequest => _dio;

//   Future<bool> signUpUser(User user) async {
//     try {
//       final response = await _dio.post(Global.signup, 
      
//       data: user.toJson());
//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(msg: 'Sign up successful!');
//         return true;
//       } else {
//         Fluttertoast.showToast(msg: 'Failed to sign up');
//         return false;
//       }
//     } catch (e) {
//       print('Error signing up: $e');
//       Fluttertoast.showToast(msg: 'Error signing up');
//       return false;
//     }
//   }
// }

// final apiProvider = Provider((ref) => API());



// api.dart

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../global/global.dart';
import '../model/usermodel.dart';

class API {
  final Dio _dio = Dio();

  API() {
    _dio.options.baseUrl = Global.hostUrl;
    _dio.interceptors.add(TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
      ),
    ));
  }

  Dio get sendRequest => _dio;




}
