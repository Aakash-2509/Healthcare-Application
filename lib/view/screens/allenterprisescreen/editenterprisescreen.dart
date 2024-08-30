// view/screens/allhealthcarecenterscreen/screens/edithealthcarecenterscreen.dart
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/model/enterprisemodel.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_dropdown.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_roundedbutton.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';
import '../profile/repo/provider.dart';

class Editenterprisescreen extends ConsumerStatefulWidget {
  final EnterpriseDetail enterprise;
  final VoidCallback onSave;

  const Editenterprisescreen(
      {super.key, required this.enterprise, required this.onSave});

  @override
  ConsumerState<Editenterprisescreen> createState() =>
      _EditenterprisescreenState();
}

class _EditenterprisescreenState extends ConsumerState<Editenterprisescreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;
  // late TextEditingController _statusController;
  late TextEditingController _websiteController;
  String? statusController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.enterprise.name);
    _addressController = TextEditingController(text: widget.enterprise.address);
    _contactController =
        TextEditingController(text: widget.enterprise.phoneNumber);
    statusController = widget.enterprise.status;
    _pincodeController =
        TextEditingController(text: widget.enterprise.pinCode.toString());
    _websiteController =
        TextEditingController(text: widget.enterprise.webSite.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String? validateFirstName(String? value) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s.]+$');

    if (value == null || value.isEmpty) {
      return "Please enter enterprise name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Name can only contain alphabets and spaces";
    } else if (value.trim().isEmpty) {
      return "Name can not contain only spaces";
    }

    return null;
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      bool success = await ref.read(apiProvider).updateEnterprise(
            widget.enterprise.id,
            _nameController.text,
            _contactController.text,
            _addressController.text,
            _pincodeController.text,
            _websiteController.text,
            statusController!,
          );

      if (success) {
        Fluttertoast.showToast(msg: 'Enterprise updated successfully');
        ref.refresh(centersProvider(const Tuple2(1, 10)));
        widget.onSave(); // Notify the UserdetailsScreen to refresh
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: 'Failed to update enterprise');
      }
    }
  }

  void _refreshUsers() {
    ref.refresh(healthcarecenterprovider);
  }

  @override
  Widget build(BuildContext context) {
    final usernameAsyncValue = ref.watch(healthcarecenterprovider);
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
                    width: availablewidth,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 900,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
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
                                      maxline: 1,
                                      minline: 1,
                                    ),
                                    const SizedBox(height: 10),
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
                                      radius: 10.0,
                                      value: statusController!,
                                      onChanged: (value) {
                                        setState(() {
                                          statusController = value;
                                        });
                                      },
                                      items: const [
                                        'Active',
                                        'Inactive',
                                        'Suspended'
                                      ],
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFC5C5C5),
                                          ),
                                          errorStyle: const TextStyle(
                                            height: 0,
                                            color: ConstColors.red,
                                          ),
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
                                          hintText: 'Contact No',
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
                                        Validators().pincodeValidator;
                                      },
                                    ),
                                    const SizedBox(height: 10),
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
                                      customText: Appstring.webisteUrl,
                                      controller: _websiteController,
                                      validator: Validators().validateWebsite,
                                      inputFormatters: const [],
                                      onChanged: (value) {
                                        Validators().validateEmail;
                                      },
                                    ),
                                    const SizedBox(height: 10),
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
