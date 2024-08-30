// view/widgets/appbar.dart
import 'dart:developer';
import 'dart:developer';
import 'dart:html' as html;
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/repo/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import '../../../../sharedpreference/sharedpreference.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final String role;

  const CustomAppBar({super.key, required this.title, required this.role});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    bool? savedThemeMode = await SharedPreferenceManager().getThemeMode();
    setState(() {
      isDarkMode = savedThemeMode ?? false;
    });
  }

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
              child: Text(
                Appstring.cancel,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                Appstring.yes,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 12),
              ),
              onPressed: () async {
                await SharedPreferenceManager().clearPreferences();
                final uderrole = await SharedPreferenceManager().getrole();
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

  void toggleTheme() async {
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

    await SharedPreferenceManager().setThemeMode(isDarkMode);
  }

  Future<void> downloadPDF() async {
    try {
      const url =
          'https://tourism.gov.in/sites/default/files/2019-04/dummy-pdf_2.pdf';
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'sample.pdf')
        ..setAttribute('target', '_blank')
        ..setAttribute('rel', 'noopener noreferrer')
        ..click();
      Fluttertoast.showToast(msg: Appstring.pdfOpened);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      log("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsyncValue = ref.watch(usernameProvider);

    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Get.offAllNamed('/');
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/splash/Ellipse 1.png'),
            radius: 20,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Get.toNamed('/');
        },
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
        ),
      ),
      actions: [
        Row(
          children: [
            InkWell(
              onTap: toggleTheme,
              child: Icon(
                isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTapDown: (TapDownDetails details) async {
                final result = await showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  items: [
                    PopupMenuItem<String>(
                      value: 'username',
                      child: usernameAsyncValue.when(
                        data: (username) => ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          title: Text(
                            username,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontSize: 15),
                          ),
                        ),
                        loading: () => ListTile(
                          leading: const CircularProgressIndicator(),
                          title: Text(Appstring.loading),
                        ),
                        error: (error, stack) => ListTile(
                          leading: const Icon(Icons.error),
                          title: Text(Appstring.error),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'download',
                      child: ListTile(
                        leading: Icon(
                          Icons.download,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        title: Text(
                          Appstring.download,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                    // PopupMenuItem<String>(
                    //   value: 'setting',
                    //   child: ListTile(
                    //     leading: Icon(
                    //       Icons.settings,
                    //       color: Theme.of(context).colorScheme.tertiary,
                    //     ),
                    //     title: Text(
                    //       Appstring.setting,
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .headlineMedium!
                    //           .copyWith(fontSize: 15),
                    //     ),
                    //   ),
                    // ),
                    PopupMenuItem<String>(
                      value: 'signout',
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        title: Text(
                          Appstring.signOut,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                );
                if (result == 'signout') {
                  await showLogoutDialog();
                } else if (result == 'username') {
                  Get.toNamed('/profile');
                }
                // else if (result == 'setting') {
                //   Get.toNamed('/setting');
                // }
                else if (result == 'download') {
                  await downloadPDF();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  radius: 20,
                  child: usernameAsyncValue.when(
                    data: (username) => Text(
                      username.isNotEmpty ? username[0] : "",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 20),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) =>
                        const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
