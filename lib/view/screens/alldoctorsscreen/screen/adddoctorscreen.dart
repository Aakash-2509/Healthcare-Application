import 'package:adhiriya_ai_webapp/model/doctormodel.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../global/app_string.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth_module/repo/apiservice.dart';
import '../../profile/repo/provider.dart';

class Addadoctorscreen extends ConsumerStatefulWidget {
  const Addadoctorscreen({super.key});

  @override
  ConsumerState<Addadoctorscreen> createState() => _AdduserScreenState();
}

class _AdduserScreenState extends ConsumerState<Addadoctorscreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specialityController = TextEditingController();
  final _avlhospController = TextEditingController();

  final _confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  String? _selectedGender;

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your confirm password";
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Password does not match";
    } else if (value.trim().isEmpty) {
      return "Password can not contain only spaces";
    }
    return null;
  }

  void _refreshUsers() {
    ref.refresh(usersProvider);
  }

  void _addDoctor() async {
    if (_formKey.currentState!.validate()) {
      final user = AddDoctor(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          mobileNo: _contactController.text.trim(),
          address: _addressController.text.trim(),
          availableHospital: _avlhospController.text.trim(),
          gender: _selectedGender,
          pincode: _pincodeController.text.trim(),
          speciality: _specialityController.text.trim(),
          profileImage: '');

      final authRepo = ref.read(apiProvider);
      final success = await authRepo.addDoctor(user);

      if (success) {
        Fluttertoast.showToast(msg: 'Doctor added successfully');
        Get.back();
        ref.refresh(doctorsProvider(const Tuple2(1, 10)));
      } else {
        Fluttertoast.showToast(msg: 'Failed to add doctor');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsyncValue = ref.watch(usernameProvider);
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
                              // height: 1000,
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
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                          Appstring.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: Appstring.name,
                                          controller: _nameController,
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
                                          keyoardType:
                                              TextInputType.emailAddress,
                                          onChanged: (value) {},
                                          maxline: 1,
                                          minline: 1,
                                          // obsercureText: true,
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          Appstring.mobileNo,
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
                                                  fontSize: 15,
                                                  color: ConstColors.black),
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFC5C5C5),
                                              ),
                                              errorStyle: const TextStyle(
                                                  fontSize: 12,
                                                  height: 0,
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
                                                    color: ConstColors
                                                        .primaryColor),
                                              ),
                                              disabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    width: .6,
                                                    color:
                                                        ConstColors.darkGrey),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    width: .6,
                                                    color:
                                                        ConstColors.darkGrey),
                                              ),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide:
                                                    BorderSide(width: .6),
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
                                              hintText: Appstring.mobileNo,
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
                                          Appstring.address,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: Appstring.address,
                                          controller: _addressController,
                                          validator:
                                              Validators().addressValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          onChanged: (p0) {},
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          Appstring.pincode,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          maxline: 6,
                                          customText: Appstring.pincode,
                                          controller: _pincodeController,
                                          validator:
                                              Validators().pincodeValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _formKey.currentState?.validate();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          Appstring.gender,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        DropdownButtonFormField<String>(
                                          value: _selectedGender,
                                          decoration: InputDecoration(
                                            errorStyle: const TextStyle(
                                                height: 0,
                                                color: ConstColors.red,
                                                fontSize: 12),
                                            hintText: Appstring.gender,
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            contentPadding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide:
                                                  const BorderSide(width: .6),
                                            ),
                                          ),
                                          items: ['Male', 'Female', 'Other']
                                              .map((gender) =>
                                                  DropdownMenuItem<String>(
                                                    value: gender,
                                                    child: Text(
                                                      gender,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium!
                                                          .copyWith(
                                                              fontSize: 15),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a gender';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          Appstring.specialities,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: Appstring.specialities,
                                          controller: _specialityController,
                                          validator:
                                              Validators().specialityValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _formKey.currentState?.validate();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          Appstring.availableHospitals,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText:
                                              Appstring.availableHospitals,
                                          controller: _avlhospController,
                                          validator:
                                              Validators().hospitalValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _formKey.currentState?.validate();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              RoundedButton(
                                                width: 200,
                                                height: 50.h,
                                                color: Colors.white,
                                                text: Text(Appstring.cancel,
                                                    style: getTextTheme()
                                                        .headlineLarge!
                                                        .copyWith(
                                                            fontSize: 15)),
                                                press: () {
                                                  Get.back();
                                                },
                                              ),
                                              RoundedButton(
                                                  width: 200,
                                                  height: 50.h,
                                                  text: Text(Appstring.save,
                                                      style: getTextTheme()
                                                          .displayLarge!
                                                          .copyWith(
                                                              fontSize: 15)),
                                                  press: _addDoctor),
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
