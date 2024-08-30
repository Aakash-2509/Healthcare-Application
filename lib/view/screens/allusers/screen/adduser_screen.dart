// view/screens/allusers/screen/adduser_screen.dart
import 'dart:developer';

import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../model/usermodel.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth_module/repo/apiservice.dart';
import '../../profile/repo/provider.dart';

class Role {
  final String id;
  final String name;

  Role({required this.id, required this.name});
}

class AdduserScreen extends ConsumerStatefulWidget {
  const AdduserScreen({super.key});

  @override
  ConsumerState<AdduserScreen> createState() => _AdduserScreenState();
}

class _AdduserScreenState extends ConsumerState<AdduserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Role? _role;
  bool isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final List<Role> _roles = [
    Role(id: '66c5f2aab34a1e21b36a275d', name: 'Medical Officer'),
    Role(id: '66c5f2aab34a1e21b36a2754', name: 'Super Admin'),
    Role(id: '66c5f2aab34a1e21b36a2757', name: 'Enterprise User'),
    Role(id: '66c5f2aab34a1e21b36a275a', name: 'Enterprise Admin'),
    Role(id: '66c5f2aab34a1e21b36a2760', name: 'Non Enterprise User'),
    Role(id: '66c5f2aab34a1e21b36a2763', name: 'Management'),
  ];

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else if (value.trim().isEmpty) {
      return "Password cannot contain only spaces";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your confirm password";
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Password does not match";
    } else if (value.trim().isEmpty) {
      return "Password cannot contain only spaces";
    }
    return null;
  }

  void _refreshUsers() {
    ref.refresh(usersProvider);
  }

  void _addUser() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
          firstName: _firstnameController.text.trim(),
          lastName: _lastnameController.text.trim(),
          email: _emailController.text.trim(),
          mobileNo: _contactController.text.trim(),
          password: _passwordController.text,
          role: _role?.id.toString() ?? '',
          countryCode: "+91");
      log("Deatils to be added ${user.role}");

      final authRepo = ref.read(apiProvider);
      final success = await authRepo.signUpUser(user);

      if (success) {
        Fluttertoast.showToast(msg: 'User added successfully');
        ref.refresh(allUsersProvider(const Tuple2(1, 10)));
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Failed to add user');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = SharedPreferenceManager().getrole();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            width: 900,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: SizedBox(
                                  width: availablewidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);

                                            // Get.offAllNamed('/alluserscreen');
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
                                      Text(
                                        Appstring.firstName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextFormField(
                                        customText: Appstring.firstName,
                                        controller: _firstnameController,
                                        validator:
                                            Validators().validateFirstName,
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
                                      const SizedBox(height: 10),
                                      Text(
                                        Appstring.lastName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextFormField(
                                        customText: Appstring.lastName,
                                        controller: _lastnameController,
                                        validator:
                                            Validators().validateLastName,
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
                                      Text(
                                        Appstring.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
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
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        Appstring.contactNo,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        maxLength: 10,
                                        cursorHeight: 20,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                                fontSize: 16,
                                                color: ConstColors.black),
                                        decoration: InputDecoration(
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFC5C5C5),
                                            ),
                                            errorStyle: const TextStyle(
                                                height: 0,
                                                fontSize: 12,
                                                color: ConstColors.red),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 12.h,
                                                    horizontal: 16),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: .6,
                                                  color:
                                                      ConstColors.primaryColor),
                                            ),
                                            disabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: .6,
                                                  color: ConstColors.darkGrey),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
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
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: .6,
                                                  color: ConstColors.red),
                                            ),
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  width: .6,
                                                  color: ConstColors.red),
                                            ),
                                            hintText: Appstring.contactNo,
                                            counterText: ""),
                                        controller: _contactController,
                                        keyboardType: TextInputType.number,
                                        validator:
                                            Validators().validatePhoneNumber,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .singleLineFormatter
                                        ],
                                        onChanged: (value) {},
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        Appstring.role,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      CustomDropdown(
                                        value: _role?.name ??
                                            _roles.first
                                                .name, // Ensure the value matches an item in the list
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _role = _roles.firstWhere((role) =>
                                                role.name == newValue);
                                          });
                                        },
                                        items: _roles
                                            .map((role) => role.name)
                                            .toList(),
                                        radius: 10.0,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        Appstring.password,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
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
                                            color: ConstColors.black,
                                            isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordVisible =
                                                  !isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        Appstring.confirmPassword,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            _formKey.currentState?.validate();
                                          });
                                        },
                                        obsercureText:
                                            !_isConfirmPasswordVisible,
                                        keyoardType: TextInputType.text,
                                        iconss: IconButton(
                                          icon: Icon(
                                            color: ConstColors.black,
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
                                                        .copyWith(
                                                            fontSize: 15)),
                                                press: () {
                                                  Navigator.pop(context);
                                                  //  Get.offAllNamed('/alluserscreen');
                                                }),
                                            RoundedButton(
                                                width: 80,
                                                height: 40,
                                                text: Text(Appstring.save,
                                                    style: getTextTheme()
                                                        .displayLarge!
                                                        .copyWith(
                                                            fontSize: 15)),
                                                press: _addUser),
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
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextFieldSection({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: getTextTheme().headlineMedium!.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        CustomTextFormField(
          customText: label,
          controller: controller,
          validator: validator,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          keyoardType: TextInputType.name,
          maxline: 1,
          minline: 1,
          onChanged: (String) {},
        ),
      ],
    );
  }

  Widget _buildContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Appstring.contactNo,
            style: getTextTheme().headlineMedium!.copyWith(fontSize: 15)),
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
            errorStyle: const TextStyle(height: 0, color: ConstColors.red),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onSecondary,
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 16),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(width: .6, color: ConstColors.primaryColor),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: .6, color: ConstColors.darkGrey),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: .6, color: ConstColors.darkGrey),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: .6),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: .6, color: ConstColors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: .6, color: ConstColors.red),
            ),
            hintText: Appstring.contactNo,
            counterText: "",
          ),
          controller: _contactController,
          keyboardType: TextInputType.number,
          validator: Validators().validatePhoneNumber,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildDropdownSection({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: getTextTheme().headlineMedium!.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        CustomDropdown(
          value: value,
          onChanged: onChanged,
          items: items,
          radius: 10.0,
        ),
      ],
    );
  }

  Widget _buildPasswordSection({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: getTextTheme().headlineMedium!.copyWith(fontSize: 15)),
        const SizedBox(height: 10),
        CustomTextFormField(
          customText: label,
          controller: controller,
          validator: validator,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) {
            setState(() {
              _formKey.currentState?.validate();
            });
          },
          obsercureText: !isPasswordVisible,
          keyoardType: TextInputType.text,
          iconss: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onVisibilityChanged,
          ),
        ),
      ],
    );
  }
}
