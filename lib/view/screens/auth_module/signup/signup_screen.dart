// signup_screen.dart

import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../constansts/text_styles.dart';
import '../../../../model/usermodel.dart';
import '../../../../utils/validation.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../home/screen/footer.dart';
import '../repo/apiservice.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  final _confirmPasswordController = TextEditingController();
  String? _role = 'Admin';
  bool isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final List<String> _roles = ['Admin'];

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Password does not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        double availablewidth = constraints.maxWidth;
        double availableheight = constraints.maxHeight;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.white54),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        width: 900,
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SizedBox(
                            width: availablewidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8.0),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      Appstring.back,
                                      style: getTextTheme()
                                          .displayLarge!
                                          .copyWith(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(Appstring.firstName,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  customText: Appstring.firstName,
                                  controller: _firstnameController,
                                  validator: Validators().validateFirstName,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter
                                  ],
                                  onChanged: (value) {},
                                  keyoardType: TextInputType.name,
                                  maxline: 1,
                                  minline: 1,
                                ),
                                SizedBox(height: 10.h),
                                Text(Appstring.lastName,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  customText: Appstring.lastName,
                                  controller: _lastnameController,
                                  validator: Validators().validateLastName,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter
                                  ],
                                  onChanged: (value) {},
                                  keyoardType: TextInputType.name,
                                  // obsercureText: true,
                                  maxline: 1,
                                  minline: 1,
                                ),
                                SizedBox(height: 10.h),
                                Text(Appstring.email,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  customText: Appstring.email,
                                  controller: _emailController,
                                  validator: Validators().validateEmail,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter
                                  ],
                                  keyoardType: TextInputType.emailAddress,
                                  onChanged: (value) {},
                                  maxline: 1,
                                  minline: 1,
                                  // obsercureText: true,
                                ),
                                SizedBox(height: 10.h),
                                Text(Appstring.contactNo,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                TextFormField(
                                  maxLength: 10,
                                  cursorHeight: 20,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(fontSize: 15),
                                  decoration: InputDecoration(
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFC5C5C5),
                                      ),
                                      errorStyle: const TextStyle(
                                          height: 0, color: ConstColors.red),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 16),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: .6,
                                            color: ConstColors.primaryColor),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: .6,
                                            color: ConstColors.darkGrey),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: .6,
                                            color: ConstColors.darkGrey),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(width: .6),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: .6, color: ConstColors.red),
                                      ),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            width: .6, color: ConstColors.red),
                                      ),
                                      hintText: Appstring.contactNo,
                                      counterText: ""),
                                  controller: _contactController,
                                  keyboardType: TextInputType.number,
                                  validator: Validators().validatePhoneNumber,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter
                                  ],
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: 10.h),
                                Text(Appstring.role,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                CustomDropdown(
                                  value: _role!,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _role = newValue;
                                    });
                                  },
                                  items: _roles,
                                  radius: 10.0, // Customize radius if needed
                                ),
                                SizedBox(height: 10.h),
                                Text(Appstring.password,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                CustomTextFormField(
                                  customText: Appstring.password,
                                  controller: _passwordController,
                                  validator: passwordValidator,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter
                                  ],
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
                                const SizedBox(height: 20),
                                Text(Appstring.confirmPassword,
                                    style: getTextTheme()
                                        .headlineMedium!
                                        .copyWith(fontSize: 15)),
                                SizedBox(height: 10.h),
                                CustomTextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      _formKey.currentState?.validate();
                                    });
                                  },
                                  obsercureText: !_isConfirmPasswordVisible,
                                  keyoardType: TextInputType.text,
                                  iconss: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible =
                                            !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                  customText: Appstring.confirmPassword,
                                  controller: _confirmPasswordController,
                                  validator: _validateConfirmPassword,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .singleLineFormatter
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (isLoading)
                                  const Center(
                                      child: CircularProgressIndicator())
                                else
                                  Center(
                                    child: RoundedButton(
                                      text: Text(Appstring.signUp,
                                          style: getTextTheme()
                                              .displayLarge!
                                              .copyWith(fontSize: 15)),
                                      press: () async {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          final user = User(
                                              firstName: _firstnameController
                                                  .text
                                                  .trim(),
                                              lastName: _lastnameController.text
                                                  .trim(),
                                              email:
                                                  _emailController.text.trim(),
                                              mobileNo: _contactController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                              role: _role ?? '',
                                              countryCode:
                                                  Appstring.countryCode);

                                          final api = ref.read(
                                              apiProvider); // Accessing API instance using provider

                                          final success =
                                              await api.signUpUser(user);
                                          if (success) {
                                            // Show success message or navigate to next screen
                                            Fluttertoast.showToast(
                                                msg: 'Sign up successful!');
                                            Get.offAllNamed('/signin');
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
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
                                        child: Text(
                                            Appstring.alreadyHaveAccount,
                                            style: getTextTheme()
                                                .headlineMedium!
                                                .copyWith(fontSize: 15))),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.offAllNamed('/signin');
                                      },
                                      child: Text(
                                        Appstring.signIn,
                                        style: getTextTheme()
                                            .headlineMedium!
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    ConstColors.primaryColor,
                                                color: ConstColors.primaryColor,
                                                fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              buildFooter(availablewidth),
            ],
          ),
        );
      },
    ));
  }
}
