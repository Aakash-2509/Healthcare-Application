import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/screen/profile_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global/app_string.dart';
import 'widget/logout_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool isDarkMode = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = SharedPreferenceManager().getrole();

    Future<void> showLogoutDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              Appstring.logout,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 20),
            ),
            content: Text(
              Appstring.logoutString,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(Appstring.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
        },
      );
    }

    void toggleTheme() {
      setState(() {
        isDarkMode = !isDarkMode;
        if (isDarkMode) {
          AdaptiveTheme.of(context).setDark();
        } else {
          AdaptiveTheme.of(context).setLight();
        }
        Fluttertoast.showToast(
          msg: isDarkMode ? Appstring.darkModeOn : Appstring.lightModeOn,
        );
      });
    }

    Widget _buildSettingsContent(int index) {
      switch (index) {
        case 0:
          return const ProfileScreen();
        case 1:
          return Center(
            child: Card(
              elevation: 50,
              shadowColor: Colors.black,
              child: SizedBox(
                width: 500,
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 108,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/splash/contactus.jpg"),
                          radius: 100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        Appstring.reachOutUs,
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: 26,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: '${Appstring.email} :',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 18,
                                ),
                            children: [
                              TextSpan(
                                text: Appstring.contactEmail,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path: Appstring.contactEmail,
                                    );
                                    if (await canLaunchUrl(emailUri)) {
                                      await launchUrl(emailUri);
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: Appstring.launchEmailError,
                                      );
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );

        case 2:
          return Center(
            child: Card(
              elevation: 50,
              shadowColor: Colors.black,
              child: SizedBox(
                width: 700,
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 108,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/splash/medical-logo.jpg"),
                          radius: 100,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        Appstring.adhiriyaAI,
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: 26,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          Appstring.aboutUs,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                fontSize: 18,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        case 3:
          return const Center(child: LogoutDialog());
        default:
          return Center(
            child: Text(
              Appstring.otherContentText,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontSize: 20,
                  ),
            ),
          );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: Row(
        children: [
          NavigationRail(
            indicatorColor: Theme.of(context).colorScheme.surfaceTint,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            backgroundColor: ConstColors.darkGrey,
            destinations: [
              NavigationRailDestination(
                icon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                label: Text(
                  Appstring.profile,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.call_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                selectedIcon: Icon(
                  Icons.call_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                label: Text(
                  Appstring.contactUs,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                selectedIcon: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                label: Text(
                  Appstring.aboutUsText,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.logout_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                selectedIcon: Icon(
                  Icons.logout_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                label: Text(
                  Appstring.logout,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
            ],
          ),
          const VerticalDivider(
              thickness: 1, width: 1, color: ConstColors.black),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              child: _buildSettingsContent(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
