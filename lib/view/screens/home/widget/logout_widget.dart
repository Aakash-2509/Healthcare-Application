import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        Appstring.logout,
        style:
            Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 20),
      ),
      content: Text(
        Appstring.logoutString,
        style:
            Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 20),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(Appstring.yes),
          onPressed: () async {
            await SharedPreferenceManager().clearPreferences();
            final userRole = await SharedPreferenceManager().getrole();
            final uid = await SharedPreferenceManager().getUserId();
            ref.invalidate(categoriesProvider(const Tuple3("", 1, 10)));
            Get.offAllNamed('/signin');
            Fluttertoast.showToast(msg: Appstring.loggedOutMsg);
          },
        ),
      ],
    );
  }
}
