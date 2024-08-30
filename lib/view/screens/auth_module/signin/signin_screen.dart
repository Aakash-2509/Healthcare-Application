import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../global/global.dart';
import '../../../../repo/api_call.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../profile/repo/provider.dart';
// Assuming you have a signup screen

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  String? errorMessage;

  API api = API();

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await api.sendRequest.post(
        Global.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        final String userId = response.data['_id'];
        final String role = response.data['roleName'];
        final String token = response.data['accessToken'];
        final String firstname = response.data['firstName'];
        final String lastname = response.data['lastName'];
        await SharedPreferenceManager().setrole(role);
        await SharedPreferenceManager().setToken(token);
        await SharedPreferenceManager().setfirstname(firstname);
        await SharedPreferenceManager().setlastname(lastname);
        await SharedPreferenceManager().setUserId(userId.toString());
        final uid = await SharedPreferenceManager().getUserId();
        final userrole = await SharedPreferenceManager().getrole();
        final usertoken = await SharedPreferenceManager().getToken();
        final name = await SharedPreferenceManager().getfirstname();
        print("uersid .......................................$usertoken");
        print("uersid .......................................$uid");
        print("uersid .......................................$userrole");
        print("uersid .......................................$name");
        ref.refresh(userProvider);
        ref.refresh(usersProvider);

        return {
          'success': true,
          'role': response.data['role'],
        };
      } else if (response.data['role'] == 'User') {
        setState(() {
          var exceptionString = Appstring.loginerrors;
          Fluttertoast.showToast(msg: exceptionString);
        });
        return {'success': false};
      } else {
        Fluttertoast.showToast(msg: Appstring.failedToLogin);
        return {'success': false};
      }
    } on DioException catch (error) {
      // Handle other Dio exceptions if necessary
      Fluttertoast.showToast(
        msg: " ${error.response?.data["message"]}",
      );
      return {'success': false};
    } catch (error, stackTrace) {
      print("Error signing in user: $error $stackTrace");
      // Handle unexpected errors
      return {'success': false};
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Email validation regex
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LayoutBuilder(builder: (context, constraints) {
        double availablewidth = constraints.maxWidth;
        double availableheight = constraints.maxHeight;
        return Container(
          width: availablewidth,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 4, 53, 94),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: Appstring.footerString,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                        children: [
                          TextSpan(
                            text: Appstring.setooSolutions,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://www.setoo.co/';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double availablewidth = constraints.maxWidth;
          double availableheight = constraints.maxHeight;

          return Container(
            decoration: const BoxDecoration(color: Colors.white54),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        // offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  height: 500,
                  width: 700,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SizedBox(
                      width: availablewidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/splash/Ellipse 1.png'), // Replace with your image URL or use AssetImage for local assets
                                radius: 20, // Adjust the radius as needed
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(Appstring.adhiriyaAICAPS,
                                  style: getTextTheme().titleLarge!.copyWith(
                                        fontSize: 20,
                                      )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(Appstring.email,
                              style: getTextTheme()
                                  .headlineMedium!
                                  .copyWith(fontSize: 15)),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            customText: Appstring.email,
                            controller: emailController,
                            validator: emailValidator,
                            inputFormatters: const [],
                            onChanged: (value) {
                              setState(() {
                                _formKey.currentState?.validate();
                              });
                            },
                            keyoardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20.h),
                          Text(Appstring.password,
                              style: getTextTheme()
                                  .headlineMedium!
                                  .copyWith(fontSize: 15)),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            customText: Appstring.password,
                            controller: passwordController,
                            validator: passwordValidator,
                            inputFormatters: const [],
                            onChanged: (value) {
                              setState(() {
                                _formKey.currentState?.validate();
                              });
                            },
                            obsercureText: !isPasswordVisible,
                            keyoardType: TextInputType.text,
                            iconss: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            Center(
                              child: RoundedButton(
                                text: Text(Appstring.signIn,
                                    style: getTextTheme()
                                        .displayLarge!
                                        .copyWith(fontSize: 15)),
                                press: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = null;
                                    });

                                    final api = ref.read(apiProvider);
                                    final result = await loginUser(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                    setState(() {
                                      isLoading = false;
                                      if (!result['success']) {
                                        errorMessage =
                                            'Failed to login. Please try again.';
                                      }
                                    });

                                    if (result['success']) {
                                      if (result['role'] == 'User') {
                                        setState(() {
                                          Fluttertoast.showToast(
                                              msg: Appstring.loginerrors);
                                        });
                                      } else {
                                        // Get.rep('/');
                                        Fluttertoast.showToast(
                                            msg: 'Login successful!');
                                        Get.offAllNamed('/');
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          SizedBox(height: 20.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(Appstring.donotHaveAccount,
                                      style: getTextTheme()
                                          .headlineMedium!
                                          .copyWith(fontSize: 15))),
                              SizedBox(
                                height: 8.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/signup");
                                },
                                child: Text(
                                  Appstring.signUp,
                                  style: getTextTheme()
                                      .headlineMedium!
                                      .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              ConstColors.primaryColor,
                                          color: ConstColors.primaryColor,
                                          fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            Appstring.forgotPassword,
                            style: getTextTheme().headlineMedium!.copyWith(
                                color: ConstColors.primaryColor, fontSize: 15),
                          )),
                          if (errorMessage != null) ...[
                            SizedBox(height: 20.h),
                            Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
