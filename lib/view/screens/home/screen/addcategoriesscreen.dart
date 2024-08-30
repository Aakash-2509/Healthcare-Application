import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuple/tuple.dart';
import '../../../../sharedpreference/sharedpreference.dart';
import '../../../../utils/validation.dart';
import '../../../widgets/custom_roundedbutton.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth_module/repo/apiservice.dart';
import '../../profile/repo/provider.dart';
import 'footer.dart';

class AddCategoryScreen extends ConsumerWidget {
  AddCategoryScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController keyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String status = 'Active';
  List<String> statuses = ['Active', 'Inactive'];

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double availableWidth = constraints.maxWidth;
          double availableHeight = constraints.maxHeight;
          if (availableWidth <= 800) {
            return phoneScreen(ref, context);
          } else {
            return webScreen(availableWidth, ref, context);
          }
        },
      ),
    );
  }

  Widget phoneScreen(WidgetRef ref, BuildContext context) {
    final authRepo = ref.watch(apiProvider);
    final userAsyncValue = ref.watch(userProvider);
    final usernameAsyncValue = ref.watch(usernameProvider);

    final role = SharedPreferenceManager().getrole();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        Appstring.addCategory,
                        style: getTextTheme().headlineLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            Appstring.name,
                            style: getTextTheme().headlineLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        customText: Appstring.enterNameHere,
                        controller: nameController,
                        validator: Validators().validateName,
                        inputFormatters: const [],
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            Appstring.keyName,
                            style: getTextTheme().headlineLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        customText: Appstring.enterKeyNameString,
                        controller: keyNameController,
                        validator: Validators().validateName,
                        inputFormatters: const [],
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            Appstring.description,
                            style: getTextTheme().headlineLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        customText: Appstring.enterDescriptionString,
                        controller: descriptionController,
                        validator: Validators().validateDescription,
                        inputFormatters: const [],
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            Appstring.status,
                            style: getTextTheme().headlineLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonFormField<String>(
                        style: getTextTheme().headlineLarge,
                        decoration: const InputDecoration(
                          errorStyle:
                              TextStyle(height: 0, color: ConstColors.red),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: .6, color: ConstColors.black),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: .6, color: ConstColors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: .6, color: ConstColors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: .6),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: .6, color: ConstColors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: .6, color: ConstColors.red),
                          ),
                        ),
                        value: status,
                        items: statuses
                            .map((status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          status = newValue!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a status';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                backgroundColor: ConstColors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                Appstring.cancel,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  print('Form is valid, attempting to save...');
                                  final authRepo = ref.read(apiProvider);
                                  await authRepo.addCategory(
                                    name: nameController.text,
                                    description: descriptionController.text,
                                    status: status,
                                    keyName: keyNameController.text,
                                  );
                                  Fluttertoast.showToast(
                                      msg: Appstring.catgeoryAddedSuccessfully);
                                  Navigator.of(context).pop();
                                  ref.refresh(
                                    categoriesProvider(
                                      const Tuple3(
                                        "",
                                        1,
                                        10,
                                      ),
                                    ),
                                  );
                                } else {
                                  print('Form is not valid');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 24.0),
                                backgroundColor: ConstColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                Appstring.save,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: ConstColors.backgroundColor),
                              ),
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
    );
  }

  Widget webScreen(double availableWidth, WidgetRef ref, BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);
    final usernameAsyncValue = ref.watch(usernameProvider);

    final role = SharedPreferenceManager().getrole();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(16)),
                width: 900,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // context.pop('/home');
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
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${Appstring.name}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomTextFormField(
                                  customText: Appstring.enterNameHere,
                                  controller: nameController,
                                  validator: Validators().validateName,
                                  inputFormatters: const [],
                                  onChanged: (value) {}),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${Appstring.keyName}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomTextFormField(
                                  customText: Appstring.enterKeyNameString,
                                  controller: keyNameController,
                                  validator: Validators().validateKeyName,
                                  inputFormatters: const [],
                                  onChanged: (value) {}),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${Appstring.description}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomTextFormField(
                                  customText: Appstring.enterDescriptionString,
                                  controller: descriptionController,
                                  validator: Validators().validateDescription,
                                  inputFormatters: const [],
                                  onChanged: (value) {}),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${Appstring.status}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 50,
                                width: availableWidth,
                                child: DropdownButtonFormField<String>(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(fontSize: 14),
                                  decoration: const InputDecoration(
                                    errorStyle: TextStyle(
                                        height: 0, color: ConstColors.red),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: .6, color: ConstColors.black),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: .6, color: ConstColors.black),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(width: .6),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: .6, color: ConstColors.red),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: .6, color: ConstColors.red),
                                    ),
                                  ),
                                  value: status,
                                  items: statuses
                                      .map((status) => DropdownMenuItem<String>(
                                            value: status,
                                            child: Text(status),
                                          ))
                                      .toList(),
                                  onChanged: (newValue) {
                                    status = newValue!;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a status';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 60),
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
                                        Navigator.pop(context);
                                      },
                                    ),
                                    RoundedButton(
                                      width: 80,
                                      height: 40,
                                      text: Text(Appstring.save,
                                          style: getTextTheme()
                                              .displayLarge!
                                              .copyWith(fontSize: 15)),
                                      press: () async {
                                        if (_formKey.currentState!.validate()) {
                                          print(
                                              'Form is valid, attempting to save...');
                                          final authRepo =
                                              ref.read(apiProvider);
                                          await authRepo.addCategory(
                                            name: nameController.text,
                                            description:
                                                descriptionController.text,
                                            status: status,
                                            keyName: keyNameController.text,
                                          );
                                          Fluttertoast.showToast(
                                              msg:
                                                  Appstring.catgeoryAddedSuccessfully);
                                          Navigator.of(context).pop();
                                          ref.refresh(
                                            categoriesProvider(
                                              const Tuple3(
                                                "",
                                                1,
                                                10,
                                              ),
                                            ),
                                          );
                                        } else {
                                          print('Form is not valid');
                                        }
                                      },
                                    )
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
          ],
        ),
      ),
      bottomNavigationBar: buildFooter(availableWidth),
    );
  }
}
