import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../sharedpreference/sharedpreference.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String userid = "";
  String role = "";
  String token = "";
  int splashtime = 3;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: splashtime), () async {
      final uid = await SharedPreferenceManager().getUserId();
      final uderrole = await SharedPreferenceManager().getrole();
      final usertoken = await SharedPreferenceManager().getToken();
      role = uderrole;
      token = usertoken;

      userid = uid;

      if (userid == '') {
        Get.toNamed('/signin');
        // context.pushReplacement('/signin');
      } else {
        // Get.toNamed("/signin");

           Get.offAllNamed('/');
        Get.toNamed('/signin');
        // context.pushReplacement('/home', extra: role);
        // context.pushReplacement('/categorydetail');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash/Ellipse 1.png'),
      ),
    );
  }
}
