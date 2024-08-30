// view/screens/alldoctorsscreen/screen/editdoctorscreen.dart
import 'package:adhiriya_ai_webapp/model/doctormodel.dart';
import 'package:adhiriya_ai_webapp/model/doctormodel.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class Editdoctorscreen extends ConsumerStatefulWidget {
  final DoctorDatum doctor;
  final VoidCallback onSave;

  const Editdoctorscreen(
      {super.key, required this.doctor, required this.onSave});

  @override
  ConsumerState<Editdoctorscreen> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<Editdoctorscreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;
  late TextEditingController _specialityController;
  late TextEditingController _avlhospController;

  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor.name);
    _emailController = TextEditingController(text: widget.doctor.email);
    _contactController = TextEditingController(text: widget.doctor.mobileNo);
    _addressController = TextEditingController(text: widget.doctor.address);
    _selectedGender = widget.doctor.gender;
    _pincodeController =
        TextEditingController(text: widget.doctor.pincode.toString());
    _specialityController =
        TextEditingController(text: widget.doctor.speciality.join(', '));
    _avlhospController =
        TextEditingController(text: widget.doctor.availableHospital.join(', '));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String? validateFirstName(String? value) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s.]+$');

    if (value == null || value.isEmpty) {
      return "Enter your full name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Name can only contain alphabets and spaces";
    } else if (value.trim().isEmpty) {
      return "Name can not contain only spaces";
    }

    return null;
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      bool success = await ref.read(apiProvider).updateDoctor(
            widget.doctor.id,
            _nameController.text,
            _contactController.text,
            _addressController.text,
            _pincodeController.text,
            _specialityController.text,
            _avlhospController.text,
            _selectedGender!,
          );

      if (success) {
        Fluttertoast.showToast(msg: 'Doctor updated successfully');
        ref.refresh(doctorsProvider(const Tuple2(1, 10)));
        widget.onSave(); // Notify the UserdetailsScreen to refresh
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: 'Failed to update user');
      }
    }
  }

  void _refreshUsers() {
    ref.refresh(usersProvider);
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
                    width: availablewidth,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
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
                                      validator: validateFirstName,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .singleLineFormatter
                                      ],
                                      onChanged: (value) {
                                        validateFirstName;
                                      },
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
                                    SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _emailController,
                                        style: getTextTheme()
                                            .headlineLarge!
                                            .copyWith(
                                                fontSize: 16,
                                                color: ConstColors.black1),
                                        decoration: InputDecoration(
                                          hintText: Appstring.email,
                                          filled: true,
                                          fillColor: ConstColors.grey,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: ConstColors.grey,
                                              width: 0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      Appstring.phone,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontSize: 15,
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
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 16),
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
                                          errorBorder: const OutlineInputBorder(
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
                                      onChanged: (value) {
                                        Validators().validatePhoneNumber;
                                      },
                                    ),
                                    const SizedBox(height: 10),
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
                                      validator: Validators().addressValidator,
                                      inputFormatters: const [],
                                      onChanged: (value) {
                                        Validators().addressValidator(value);
                                      },
                                    ),
                                    const SizedBox(height: 10),
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
                                      customText: Appstring.pincode,
                                      controller: _pincodeController,
                                      validator: Validators().pincodeValidator,
                                      inputFormatters: const [],
                                      onChanged: (value) {
                                        Validators().validateEmail;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Text(Appstring.gender,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              fontSize: 15,
                                            )),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<String>(
                                      value: _selectedGender,
                                      decoration: InputDecoration(
                                        errorStyle: const TextStyle(
                                            height: 0,
                                            color: ConstColors.red,
                                            fontSize: 12),
                                        hintText: Appstring.gender,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              fontSize: 15,
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
                                          _selectedGender = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return Appstring.selectgender;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
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
                                      inputFormatters: const [],
                                      onChanged: (value) {
                                        Validators().validateEmail;
                                      },
                                    ),
                                    const SizedBox(height: 10),
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
                                      customText: Appstring.availableHospitals,
                                      controller: _avlhospController,
                                      validator: Validators().hospitalValidator,
                                      inputFormatters: const [],
                                      onChanged: (value) {
                                        Validators().validateEmail;
                                      },
                                    ),
                                    SizedBox(height: 50.h),
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
                                                      .copyWith(fontSize: 15)),
                                              press: () {
                                                Navigator.pop(context);
                                              }),
                                          RoundedButton(
                                              width: 200,
                                              height: 50.h,
                                              text: Text(Appstring.save,
                                                  style: getTextTheme()
                                                      .displayLarge!
                                                      .copyWith(fontSize: 15)),
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
                  buildFooter(availablewidth),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
