import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adhiriya_ai_webapp/repo/api_call.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constansts/const_colors.dart';
import 'constansts/text_styles.dart';
import 'scrollable.dart';
import 'utils/routegetx.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
AdaptiveThemeMode? savedThemeMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp(
  //      options: DefaultFirebaseOptions.currentPlatform, //Firebase initialization
  //     );

  await GetStorage.init(); //local storage initialization
  savedThemeMode = await AdaptiveTheme.getThemeMode(); //Theme initialization
  //await NotificationService.initialize(); //firebase notification initialization
  // AndroidInitializationSettings androidSetting =
  //     const AndroidInitializationSettings(
  //         "@drawable/ic_stat_ic_notification"); // android local notification initialization
  // DarwinInitializationSettings iosSetting = const DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  //   requestCriticalPermission: true,
  // ); // IOS local notification initialization
  // InitializationSettings initializationSettings =
  //     InitializationSettings(android: androidSetting, iOS: iosSetting);
  // bool? initialized =
  //     await notificationsPlugin.initialize(initializationSettings);
  // if (Platform.isAndroid) {
  //   log('Notification : Android');
  //   notificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()!
  //       .requestNotificationsPermission(); // requesting notification permission to above android 12 phones
  // }
  // log('Notification : $initialized');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); // setting device Orientation
  String? usertoken = await SharedPreferenceManager().getToken();
  bool isDarkMode = await SharedPreferenceManager().getThemeMode() ?? false;
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('mr', 'IN'),
        Locale('te', 'IN'),
      ],
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: const Locale('en', 'US'),
      child: ProviderScope(
        child: MyApp(
          isLoggedIn: usertoken != null && usertoken.isNotEmpty,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1920, 1080), // device size
        useInheritedMediaQuery: true, //for keyboard not overlapp
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return AdaptiveTheme(
            light: ThemeData(
              useMaterial3: true,
              // scaffoldBackgroundColor: ConstColors.scaffoldColor,
              colorScheme: lightColorScheme,
              fontFamily: GoogleFonts.inter().fontFamily,
              textTheme: getLightTextTheme(),
            ),
            dark: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                fontFamily: GoogleFonts.inter().fontFamily,
                textTheme: getDarkTextTheme()),
            initial: savedThemeMode ?? AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => GetMaterialApp(
              scrollBehavior: MyCustomScrollBehavior(),
              //  routerConfig: router,
              getPages: AppPages.routes,
              debugShowCheckedModeBanner: false,
              title: 'Adhiriya',
              theme: theme,
              darkTheme: darkTheme,
              initialRoute: '/signin',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              transitionDuration: const Duration(milliseconds: 0),
            ),
          );
        });
  }
}
