// view/screens/auth_module/reset/resetpassword.dart
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth_module/repo/apiservice.dart';
import '../../profile/repo/provider.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else if (value.trim().isEmpty) {
      return "Password can not contain only spaces";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your confirm password";
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      return "Password does not match";
    }
    return null;
  }

  void _refreshUsers() {
    ref.refresh(usersProvider);
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Call the reset password API
      final response = await ref
          .read(apiProvider)
          .resetPassword(oldPassword, newPassword, confirmPassword);

      if (response) {
        Fluttertoast.showToast(msg: 'Password reset successful!');
        // Navigate to the sign-in page
        Get.offAllNamed('/profile');
        //  context.go('/signin');
      } else {
        Fluttertoast.showToast(msg: 'Failed to reset password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsyncValue = ref.watch(usernameProvider);
    final role = SharedPreferenceManager().getrole();
    return Scaffold(
        appBar:
            CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double availablewidth = constraints.maxWidth;
            double availableheight = constraints.maxHeight;

            // double padding = constraints.maxWidth > 600 ? 100.w : 16.w;
            // double formWidth =
            //     constraints.maxWidth > 600 ? 400.w : double.infinity;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Container(
                      height: availableheight,
                      width: availablewidth,
                      color: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            height: 510,
                            width: 900,
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
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // context.go('/profile');
                                          // Get.toNamed('/profile');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(8.0),
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                    Text(Appstring.oldPassword,
                                        style: getTextTheme()
                                            .headlineMedium!
                                            .copyWith(fontSize: 15)),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _formKey.currentState?.validate();
                                        });
                                      },
                                      obsercureText: !_isOldPasswordVisible,
                                      keyoardType: TextInputType.text,
                                      iconss: IconButton(
                                        icon: Icon(
                                          _isOldPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isOldPasswordVisible =
                                                !_isOldPasswordVisible;
                                          });
                                        },
                                      ),
                                      customText: Appstring.oldPassword,
                                      controller: _oldPasswordController,
                                      validator: passwordValidator,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(Appstring.newPassword,
                                        style: getTextTheme()
                                            .headlineMedium!
                                            .copyWith(fontSize: 15)),
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _formKey.currentState?.validate();
                                        });
                                      },
                                      obsercureText: !_isNewPasswordVisible,
                                      keyoardType: TextInputType.text,
                                      iconss: IconButton(
                                        icon: Icon(
                                          _isNewPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isNewPasswordVisible =
                                                !_isNewPasswordVisible;
                                          });
                                        },
                                      ),
                                      customText: Appstring.newPassword,
                                      controller: _newPasswordController,
                                      validator: passwordValidator,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(Appstring.confirmPassword,
                                        style: getTextTheme()
                                            .headlineMedium!
                                            .copyWith(fontSize: 15)),
                                    const SizedBox(height: 10),
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
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          RoundedButton(
                                              width: 80,
                                              height: 40,
                                              color: Colors.white,
                                              text: Text(Appstring.cancel,
                                                  style: getTextTheme()
                                                      .headlineLarge!
                                                      .copyWith(fontSize: 15)),
                                              press: () {
                                                // context.go('/profile');
                                                Navigator.pop(context);
                                                // Get.offAllNamed('/profile');
                                              }),
                                          RoundedButton(
                                              width: 80,
                                              height: 40,
                                              text: Text(Appstring.save,
                                                  style: getTextTheme()
                                                      .displayLarge!
                                                      .copyWith(fontSize: 15)),
                                              press: _resetPassword),
                                        ],
                                      ),
                                    ),
                                  ],
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
              ),
            );
          },
        ));
  }
}
