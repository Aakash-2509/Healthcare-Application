// view/screens/allusers/screen/edituser.dart
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../global/app_string.dart';
import '../../../../model/usermodel.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth_module/repo/apiservice.dart';
import '../../profile/repo/provider.dart';

class EditUser extends ConsumerStatefulWidget {
  final UserDatum user;
  final VoidCallback onSave;

  const EditUser({super.key, required this.user, required this.onSave});

  @override
  ConsumerState<EditUser> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(text: widget.user.firstName);
    _lastnameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.mobileNo);
    // _dobController = TextEditingController(text: widget.user.dob);
    // Assuming widget.user.dob is a DateTime object
    _dobController = TextEditingController(text: widget.user.dob);

    if (widget.user.dob != null) {
      _dobController = TextEditingController(
          text: widget.user.dob!.length >= 10
              ? widget.user.dob?.substring(0, 10)
              : widget.user.dob ?? '');
    } else {
      _dobController = TextEditingController(text: "");
    }
    _selectedGender = widget.user.gender;
  }

  // @override
  // void dispose() {
  //   _firstnameController.dispose();
  //   _lastnameController.dispose();
  //   _emailController.dispose();
  //   _dobController.dispose();
  //   _phoneController.dispose();
  //   super.dispose();
  // }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      bool success = await ref.read(apiProvider).updateUser(
            widget.user.id,
            _firstnameController.text,
            _lastnameController.text,
            _dobController.text,
            _selectedGender!,
            _phoneController.text,
          );

      if (success) {
        Fluttertoast.showToast(msg: 'User updated successfully');
        widget.onSave(); // Notify the UserdetailsScreen to refresh
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: 'Failed to update user');
      }
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(), // Set lastDate to today to prevent future dates
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
  //     });
  //   }
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Set lastDate to today to prevent future dates
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: const TextTheme(
              bodySmall: TextStyle(fontSize: 12), // Adjust font size as needed
              // bodySmall: TextStyle(fontSize: 12), // Adjust font size as needed
              // bodySmall: TextStyle(fontSize: 12), // Adjust font size as needed
              // bodySmall: TextStyle(fontSize: 12), // Adjust font size as needed
              // button: TextStyle(fontSize: 12), // Adjust font size as needed
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  void _refreshUsers() {
    ref.refresh(usersProvider);
    ref.refresh(usernameProvider);
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsyncValue = ref.watch(usernameProvider);
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

                                              // Get.offAllNamed('/alluserscreen');
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
                                        const SizedBox(height: 10),
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
                                          enabled: false,
                                          controller: _emailController,
                                          validator: Validators().validateEmail,
                                          inputFormatters: [],
                                          onChanged: (value) {
                                            Validators().validateEmail;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Phone",
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
                                                  color: ConstColors.black),
                                          decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFC5C5C5),
                                              ),
                                              errorStyle: const TextStyle(
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
                                              hintText: 'Contact No',
                                              counterText: ""),
                                          controller: _phoneController,
                                          keyboardType: TextInputType.number,
                                          validator:
                                              Validators().validatePhoneNumber,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .singleLineFormatter
                                          ],
                                          onChanged: (value) {
                                            Validators().validatePhoneNumber;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          Appstring.dateofbirth,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize: 15,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _dobController,
                                          readOnly: true,
                                          onTap: () => _selectDate(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize: 15,
                                              ),
                                          decoration: InputDecoration(
                                            hintText: Appstring.dateofbirth,
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.calendar_today,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            ),
                                            errorStyle: const TextStyle(
                                                height: 0,
                                                color: ConstColors.red,
                                                fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide:
                                                  const BorderSide(width: .6),
                                            ),
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
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a date';
                                            }
                                            DateTime dob =
                                                DateFormat('yyyy-MM-dd')
                                                    .parse(value);
                                            if (dob.isAfter(DateTime.now())) {
                                              return 'Date of Birth cannot be in the future';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          Appstring.gender,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize: 15,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        DropdownButtonFormField<String>(
                                          value: _selectedGender,
                                          decoration: InputDecoration(
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
                                            errorStyle: const TextStyle(
                                                height: 0,
                                                color: ConstColors.red,
                                                fontSize: 12),
                                            hintText: "Gender",
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
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
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedGender = value!;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 50.h),
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
                                                  press: _saveUser),
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
