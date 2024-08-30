import 'dart:developer';

import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/model/enterprisemodel.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/repo/provider.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_dropdown.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_roundedbutton.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';

class Addenterprisescreen extends ConsumerStatefulWidget {
  const Addenterprisescreen({super.key});

  @override
  ConsumerState<Addenterprisescreen> createState() =>
      _AddenterprisescreenState();
}

class _AddenterprisescreenState extends ConsumerState<Addenterprisescreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _webisteController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  late List<String> _roles = ['Active', 'Inactive', 'Suspended'];
  String? _role = 'Active';

  bool isPasswordVisible = false;

  void _addEnterprise() async {
    if (_formKey.currentState!.validate()) {
      final user = AddEnterprise(
        name: _nameController.text.trim(),
        mobileNo: _contactController.text.trim(),
        address: _addressController.text.trim(),
        pincode: _pincodeController.text.trim(),
        webiste: _webisteController.text.trim(),
        status: _role ?? '',
      );

      log("Status of ernterprise ${_pincodeController.text}");

      final authRepo = ref.read(apiProvider);
      final success = await authRepo.addEnterprise(user);

      if (success) {
        Get.back();
        Fluttertoast.showToast(msg: 'Enterprise added successfully');
        ref.refresh(allenterprise(const Tuple2(1, 10)));
      } else {
        Fluttertoast.showToast(msg: 'Failed to add enterprise');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(usernameProvider);
    final role = SharedPreferenceManager().getrole();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        appBar:
            CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double availablewidth = constraints.maxWidth;
            double availableheight = constraints.maxHeight;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Container(
                      height: availableheight,
                      width: availablewidth,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                    .primaryContainer,
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
                                              'Back',
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
                                          customText: 'Name',
                                          controller: _nameController,
                                          validator:
                                              Validators().validateFirstName,
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
                                        Text(
                                          Appstring.webisteUrl,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: 'Website URL',
                                          controller: _webisteController,
                                          validator:
                                              Validators().validateWebsite,
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
                                        Text(
                                          Appstring.status,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomDropdown(
                                            radius: 10,
                                            value: _role!,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _role = newValue;
                                              });
                                            },
                                            items: _roles),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Mobile No",
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
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize: 15,
                                                color: ConstColors.black,
                                              ),
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
                                              hintText: 'Mobile No',
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
                                          "Address",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: 'Address',
                                          controller: _addressController,
                                          validator:
                                              Validators().addressValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          keyoardType:
                                              TextInputType.streetAddress,
                                          onChanged: (value) {},
                                          maxline: 1,
                                          minline: 1,
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Pincode",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: 'Pincode',
                                          controller: _pincodeController,
                                          validator:
                                              Validators().pincodeValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          keyoardType: TextInputType.number,
                                          onChanged: (value) {},
                                          maxline: 1,
                                          minline: 1,
                                        ),
                                        SizedBox(height: 20.h),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                child: RoundedButton(
                                                  width: 200,
                                                  height: 50.h,
                                                  color: Colors.white,
                                                  text: Text('Cancel',
                                                      style: getTextTheme()
                                                          .headlineLarge!
                                                          .copyWith(
                                                              fontSize: 15)),
                                                  press: () {
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                              Flexible(
                                                child: RoundedButton(
                                                  width: 200,
                                                  height: 50.h,
                                                  text: Text('Save',
                                                      style: getTextTheme()
                                                          .displayLarge!
                                                          .copyWith(
                                                              fontSize: 15)),
                                                  press: _addEnterprise,
                                                ),
                                              ),
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
