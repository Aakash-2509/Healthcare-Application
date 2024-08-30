import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/model/healthcarecenter.dart';
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
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth_module/repo/apiservice.dart';
import '../../profile/repo/provider.dart';

class Addcenterscreen extends ConsumerStatefulWidget {
  const Addcenterscreen({super.key});

  @override
  ConsumerState<Addcenterscreen> createState() => _AddcenterscreenState();
}

class _AddcenterscreenState extends ConsumerState<Addcenterscreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _timeController = TextEditingController();
  final _timeController2 = TextEditingController();
  final _specialityController = TextEditingController();
  TimeOfDay? _selectedOpeningTime;
  TimeOfDay? _selectedClosingTime;

  bool isPasswordVisible = false;

  Future<void> _selectOpeningTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedOpeningTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.black,
              ),
              dialBackgroundColor: Colors.blue[50],
              dialTextColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedOpeningTime) {
      setState(() {
        _selectedOpeningTime = picked;
        _timeController.text = _selectedOpeningTime!.format(context);
      });
    }
  }

  Future<void> _selectClosingTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedClosingTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              hourMinuteTextColor: WidgetStateColor.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.black,
              ),
              dialBackgroundColor: Colors.blue[50],
              dialTextColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedClosingTime) {
      setState(() {
        _selectedClosingTime = picked;
        _timeController2.text = _selectedClosingTime!.format(context);
      });
    }
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a time';
    } 
    // else if (_selectedOpeningTime!.hour > _selectedClosingTime!.hour ||
    //     (_selectedOpeningTime!.hour == _selectedClosingTime!.hour &&
    //         _selectedOpeningTime!.minute >= _selectedClosingTime!.minute)) {
    //   return 'Please select valid time';
    // }
    return null;
  }

  void _addCenter() async {
    if (_formKey.currentState!.validate()) {
      final user = AddCenter(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobileNo: _contactController.text.trim(),
        address: _addressController.text.trim(),
        pincode: _pincodeController.text.trim(),
        speciality: _specialityController.text.trim(),
        time: '${_timeController.text} - ${_timeController2.text}',
      );

      final authRepo = ref.read(apiProvider);
      final success = await authRepo.addCenter(user);

      if (success) {
        Fluttertoast.showToast(msg: 'Center added successfully');
        Get.back();
        ref.refresh(centersProvider(const Tuple2(1, 10)));

      } else {
        Fluttertoast.showToast(msg: 'Failed to add center');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(usernameProvider);
    final role = SharedPreferenceManager().getrole();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
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
                                          "Email",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: 'Email',
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
                                        ),
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
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Opening Time",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () =>
                                              _selectOpeningTime(context),
                                          child: AbsorbPointer(
                                            child: CustomTextFormField(
                                              customText: 'Opening Time',
                                              controller: _timeController,
                                              validator: _validateTime,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .singleLineFormatter
                                              ],
                                              keyoardType:
                                                  TextInputType.datetime,
                                              onChanged: (value) {},
                                              maxline: 1,
                                              minline: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Closing Time",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () =>
                                              _selectClosingTime(context),
                                          child: AbsorbPointer(
                                            child: CustomTextFormField(
                                              customText: 'Closing Time',
                                              controller: _timeController2,
                                              validator: _validateTime,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .singleLineFormatter
                                              ],
                                              keyoardType:
                                                  TextInputType.datetime,
                                              onChanged: (value) {},
                                              maxline: 1,
                                              minline: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Speciality",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFormField(
                                          customText: 'Speciality',
                                          controller: _specialityController,
                                          validator:
                                              Validators().specialityValidator,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          keyoardType: TextInputType.text,
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
                                                  press: _addCenter,
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
