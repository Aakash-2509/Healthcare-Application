// view/screens/home/categorydetailsscreen.dart
import 'dart:developer';import 'dart:developer';
import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/model/categorydetail.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_roundedbutton.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tuple/tuple.dart';

import '../../../sharedpreference/sharedpreference.dart';
import '../../../utils/validation.dart';
import '../profile/repo/provider.dart';

class CategoryDetailsScreen extends ConsumerStatefulWidget {
  final dynamic categoryId;

  const CategoryDetailsScreen({
    super.key,
    required this.categoryId,
  });

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends ConsumerState<CategoryDetailsScreen> {
  late Future<CategoryDetails> _categoryFuture;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
//  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _keynameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String status = '';
  List<String> statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    _categoryFuture = _fetchCategoryDetails();
  }

  Future<CategoryDetails> _fetchCategoryDetails() async {
    final authRepo = ref.read(authRepoProvider);
    return authRepo.fetchCategoryById(widget.categoryId);
  }

  void _editCategory() async {
    if (_formKey.currentState!.validate()) {
      final authRepo = ref.read(apiProvider);
      try {
        log('Editing category with ID: ${widget.categoryId}');
        log('Name: ${_nameController.text}');
        log('Description: ${_descriptionController.text}');
        log('Keyname: ${_keynameController.text}');
        log('Status: $status');

        await authRepo.editCategory(
          categoryId: widget.categoryId,
          name: _nameController.text,
          description: _descriptionController.text,
          keyname: _keynameController.text,
          status: status,
        );

        Navigator.pop(context);
        ref.refresh(
          categoriesProvider(
            const Tuple3('', 1, 10),
          ),
        );
        Fluttertoast.showToast(msg: Appstring.catgeoryEditedSuccessfully);
      } catch (e) {
        log('Edit category error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Appstring.catgeoryEditedUnsuccessfully} $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _refreshUsers() {
    ref.refresh(usersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<CategoryDetails>(
        future: _categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${Appstring.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text(Appstring.noCategoriesDetailsFound));
          } else {
            final category = snapshot.data!;
            _nameController.text = category.name;
            _descriptionController.text = category.description;
            _keynameController.text = category.keyName;
            status = category.status;

            return LayoutBuilder(
              builder: (context, constraints) {
                double availableWidth = constraints.maxWidth;
                if (constraints.maxWidth > 800) {
                  // Desktop Layout
                  return _buildCategoryDetailsFormWeb(category, availableWidth);
                } else {
                  // Mobile Layout
                  return _buildCategoryDetailsForm(category);
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryDetailsForm(CategoryDetails category) {
    final role = SharedPreferenceManager().getrole();
    return Scaffold(
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${Appstring.name}:",
                        style: getTextTheme().headlineLarge!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        child: CustomTextFormField(
                          customText: Appstring.enterNameHere,
                          controller: _nameController,
                          validator: Validators().validateName,
                          inputFormatters: [],
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${Appstring.keyName}:",
                        style: getTextTheme().headlineLarge!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        child: CustomTextFormField(
                          customText: Appstring.enterKeyNameString,
                          controller: _keynameController,
                          validator: Validators().validateName,
                          inputFormatters: [],
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${Appstring.description}:",
                        style: getTextTheme().headlineLarge!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        child: CustomTextFormField(
                          customText: Appstring.enterDescriptionString,
                          controller: _descriptionController,
                          validator: Validators().validateDescription,
                          inputFormatters: [],
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${Appstring.status}:",
                        style: getTextTheme().headlineLarge!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 500,
                        child: DropdownButtonFormField<String>(
                          style: getTextTheme().headlineMedium,
                          decoration: const InputDecoration(
                            errorStyle:
                                TextStyle(height: 0, color: ConstColors.red),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: .6, color: ConstColors.black),
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
                              borderSide:
                                  BorderSide(width: .6, color: ConstColors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: .6, color: ConstColors.red),
                            ),
                          ),
                          value: status,
                          items: statuses
                              .map((role) => DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(
                                      role,
                                      style: getTextTheme().headlineLarge,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              status = newValue!;
                            });
                            category.status = newValue!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a status';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${Appstring.createdBy}: ${category.createdBy.first_name} ${category.createdBy.last_name}',
                        style: getTextTheme().headlineLarge!.copyWith(
                              fontSize: 16,
                              color: ConstColors.darkGrey,
                            ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _editCategory();
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
                            Appstring.update,
                            style: const TextStyle(
                              fontSize: 16,
                              color: ConstColors.backgroundColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDetailsFormWeb(
      CategoryDetails category, double availableWidth) {
    final usernameAsyncValue = ref.watch(usernameProvider);
    final role = SharedPreferenceManager().getrole();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 900,
                    // height: 500,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              SizedBox(
                                child: CustomTextFormField(
                                  customText: Appstring.enterNameHere,
                                  controller: _nameController,
                                  validator: Validators().validateName,
                                  inputFormatters: [],
                                  onChanged: (value) {
                                    category.name = value;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
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
                              SizedBox(
                                child: CustomTextFormField(
                                  customText: Appstring.enterKeyNameString,
                                  controller: _keynameController,
                                  validator: Validators().validateName,
                                  inputFormatters: [],
                                  onChanged: (value) {
                                    category.keyName = value;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
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
                              SizedBox(
                                child: CustomTextFormField(
                                  customText: Appstring.enterDescriptionString,
                                  controller: _descriptionController,
                                  validator: Validators().validateDescription,
                                  inputFormatters: [],
                                  onChanged: (value) {
                                    category.description = value;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "${Appstring.status}:",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              SizedBox(
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                  decoration: const InputDecoration(
                                    errorStyle: TextStyle(
                                        height: 0, color: ConstColors.red),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: .6, color: ConstColors.black),
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
                                      .map((role) => DropdownMenuItem<String>(
                                            value: role,
                                            child: Text(
                                              role,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                    fontSize: 16,
                                                  ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (newValue) {
                                    log("message $newValue");
                                    setState(() {
                                      status = newValue!;
                                    });
                                    category.status = newValue!;
                                    log("Status $status");
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a status';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              // const SizedBox(height: 16),
                              // Text(
                              //   '${Appstring.createdBy}: ${category.createdBy.first_name} ${category.createdBy.last_name}',
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .headlineLarge!
                              //       .copyWith(
                              //         fontSize: 30,
                              //       ),
                              // ),
                              const SizedBox(height: 24),
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
                                        }),
                                    RoundedButton(
                                      width: 80,
                                      height: 40,
                                      text: Text(
                                        Appstring.save,
                                        style:
                                            getTextTheme().displayLarge!.copyWith(
                                                  fontSize: 15,
                                                ),
                                      ),
                                      press: () {
                                        _editCategory();
                                      },
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildFooter(availableWidth),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 16,
      ),
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed,
      {Color? color}) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          backgroundColor: color ?? ConstColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: ConstColors.backgroundColor,
          ),
        ),
      ),
    );
  }
}
