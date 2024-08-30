import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/model/doctormodel.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/widget/buildcardinfo.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/repo/provider.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import '../../../widgets/custom_textfield.dart';

class Alldoctorscreen extends ConsumerStatefulWidget {
  const Alldoctorscreen({super.key});

  @override
  ConsumerState<Alldoctorscreen> createState() => _AlldoctorscreenState();
}

class _AlldoctorscreenState extends ConsumerState<Alldoctorscreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortColumn = 'name';
  bool isAscending = true;
  int currentPage = 1;
  int selectedPageSize = 10;

  final List<String> size = [
    '5',
    '10',
    '15',
    '20',
  ];
  String? selectedValue;

  void _editDoctor(BuildContext context, DoctorDatum doctor) async {
    Get.toNamed('/editdoctor',
        arguments: {'doctor': doctor, 'onSave': _refreshDoctorDetails});
  }

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
    _refreshDoctors();
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _refreshDoctors();
    }
  }

  void _deleteUser(String userId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete User',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 20),
          ),
          content: Text(
            'Are you sure you want to delete this user?',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      // Perform deletion logic here
      bool success = await ref.read(apiProvider).deleteDoctor(userId);
      if (success) {
        _refreshDoctors();
        Fluttertoast.showToast(msg: 'Doctor deleted successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to delete user');
      }
    }
  }

  void _refreshDoctors() {
    ref.refresh(doctorsProvider(Tuple2(currentPage, selectedPageSize)));
  }

  void _refreshDoctorDetails() {
    ref.refresh(doctordetailProvider);
  }

  void _sortTable(String column) {
    setState(() {
      if (_sortColumn == column) {
        isAscending = !isAscending;
      } else {
        _sortColumn = column;
        isAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorData =
        ref.watch(doctorsProvider(Tuple2(currentPage, selectedPageSize)));
    final role = SharedPreferenceManager().getrole();
    final doctorAsyncValue = ref.watch(doctorProvider);
    final usernameAsyncValue = ref.watch(allUsersProvider(const Tuple2(1, 10)));
    final healthcarecenterAsyncValue =
        ref.watch(centersProvider(const Tuple2(1, 10)));
    final enterpriseAsyncValue = ref.watch(allenterprise(const Tuple2(1, 10)));

    int doctorCount = doctorData.when(
      data: (doc) => doc.total_records,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    int healthcarecenterCount = healthcarecenterAsyncValue.when(
      data: (doc) => doc.total_records,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    int enterpriseCount = enterpriseAsyncValue.when(
      data: (doc) => doc.totalRecords,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    int userCount = usernameAsyncValue.when(
      data: (user) => user.totalRecords,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    return Scaffold(
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          double availableHeight = constraints.maxHeight;
          return RefreshIndicator(
            onRefresh: () async {
              // _refreshUsers(); // Refresh manually
            },
            child: doctorData.when(
              data: (doctors) {
                // Sorting
                List<DoctorDatum> sortedDoctors = List.from(doctors.doctorData);
                sortedDoctors.sort((a, b) {
                  final aValue = _getValue(a);
                  final bValue = _getValue(b);

                  if (isAscending) {
                    return Comparable.compare(aValue, bValue);
                  } else {
                    return Comparable.compare(bValue, aValue);
                  }
                });

                final filteredDoctors = sortedDoctors
                    .where((doctor) => doctor.address
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 300,
                              width: availableWidth,
                              child: Image.asset(
                                'assets/splash/loginbanner.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              top: 70,
                              left: 16,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/');
                                      // Get.back();
                                    },
                                    child: buildInfoCard(
                                      Appstring.totalUserCount,
                                      userCount,
                                      Icons.person_add_alt_outlined,
                                      ConstColors.secondaryColor,
                                      ConstColors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/alldoctorscreen');
                                    },
                                    child: buildInfoCard(
                                      Appstring.totalDoctors,
                                      doctorCount,
                                      Icons.medical_services_outlined,
                                      Colors.blue,
                                      ConstColors.backgroundColor,
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/allhealthcarecenter');
                                    },
                                    child: buildInfoCard(
                                      Appstring.totalCenter,
                                      healthcarecenterCount,
                                      Icons.local_hospital_outlined,
                                      ConstColors.secondaryColor,
                                      ConstColors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/allenterprisescreen');
                                    },
                                    child: buildInfoCard(
                                      Appstring.totalEnterprise,
                                      enterpriseCount,
                                      Icons.add_home_work_outlined,
                                      ConstColors.secondaryColor,
                                      ConstColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: availableWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Filter:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontSize: 15,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: CustomTextFormField(
                                        customText: 'Search',
                                        controller: _searchController,
                                        validator: null,
                                        inputFormatters: const [],
                                        onChanged: (value) {
                                          setState(() {
                                            _searchQuery = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Row(
                                      children: [
                                        Text(Appstring.sortBy,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(fontSize: 15)),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isAscending = !isAscending;
                                            });
                                            _refreshDoctors();
                                          },
                                          child: Text(isAscending
                                              ? Appstring.ascending
                                              : Appstring.descending),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed('/adddoctorscreen');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(8.0),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'Add Doctor',
                                    style: getTextTheme()
                                        .displayLarge!
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: availableWidth,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: availableWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: ConstColors.black),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: availableWidth,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      sortColumnIndex:
                                          _getColumnIndex(_sortColumn),
                                      sortAscending: isAscending,
                                      border: TableBorder.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                      headingRowColor: WidgetStateProperty.all(
                                        const Color.fromARGB(255, 3, 48, 85),
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'Sr. No',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Name',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                          // onSort: (columnIndex, _) {
                                          //   _sortTable('name');
                                          // },
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Address',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                          // onSort: (columnIndex, _) {
                                          //   _sortTable('address');
                                          // },
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Speciality',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                          // onSort: (columnIndex, _) {
                                          //   _sortTable('speciality');
                                          // },
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Available Hospital',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                          // onSort: (columnIndex, _) {
                                          //   _sortTable('availableHospital');
                                          // },
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Phone Number',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                          // onSort: (columnIndex, _) {
                                          //   _sortTable('phoneNumber');
                                          // },
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Gender',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                          // onSort: (columnIndex, _) {
                                          //   _sortTable('gender');
                                          // },
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'More',
                                            overflow: TextOverflow.ellipsis,
                                            style: getTextTheme()
                                                .displayLarge!
                                                .copyWith(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                        filteredDoctors.length,
                                        (index) {
                                          final doctor = filteredDoctors[index];
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    doctor.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    doctor.address,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    doctor.speciality
                                                        .join(', '),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    doctor.availableHospital
                                                        .join(', '),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge!
                                                        .copyWith(
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 100,
                                                  child: Center(
                                                    child: Text(
                                                      doctor.mobileNo,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge!
                                                          .copyWith(
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 60,
                                                  child: Center(
                                                    child: Text(
                                                      doctor.gender,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge!
                                                          .copyWith(
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                GestureDetector(
                                                  onTapDown: (TapDownDetails
                                                      details) async {
                                                    final result =
                                                        await showMenu(
                                                      context: context,
                                                      position:
                                                          RelativeRect.fromLTRB(
                                                        details
                                                            .globalPosition.dx,
                                                        details
                                                            .globalPosition.dy,
                                                        details
                                                            .globalPosition.dx,
                                                        details
                                                            .globalPosition.dy,
                                                      ),
                                                      items: [
                                                        PopupMenuItem<String>(
                                                          value: 'edit',
                                                          child: ListTile(
                                                            leading: Icon(
                                                              Icons.edit,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                            ),
                                                            title: Text(
                                                              'Edit',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'delete',
                                                          child: ListTile(
                                                            leading: Icon(
                                                              Icons.delete,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                            ),
                                                            title: Text(
                                                              'Delete',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                    if (result == 'edit') {
                                                      _editDoctor(
                                                          context, doctor);
                                                    } else if (result ==
                                                        'delete') {
                                                      _deleteUser(doctor.id);
                                                    }
                                                  },
                                                  child: const Icon(
                                                      Icons.more_vert),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed:
                                  currentPage > 1 ? _goToPreviousPage : null,
                              child: Text(
                                Appstring.backArrow,
                                style: TextStyle(
                                  color: currentPage > 1
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              "${Appstring.page} $currentPage",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 16),
                            ),
                            TextButton(
                              onPressed:
                                  doctors.doctorData.length == selectedPageSize
                                      ? _goToNextPage
                                      : null,
                              child: Text(
                                Appstring.frontArrow,
                                style: TextStyle(
                                  color: doctors.doctorData.length ==
                                          selectedPageSize
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Text(
                                      Appstring.show,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$selectedPageSize',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
                                  ],
                                ),
                                items: size
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                    selectedPageSize = int.parse(value ?? '5');
                                  });
                                  ref.refresh(
                                    doctorsProvider(
                                      Tuple2(
                                        currentPage,
                                        selectedPageSize,
                                      ),
                                    ),
                                  );
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 40,
                                  width: 140,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          );
        },
      ),
      bottomNavigationBar: buildFooter(double.maxFinite),
    );
  }

  Comparable _getValue(DoctorDatum doctor) {
    switch (_sortColumn) {
      case 'name':
        return doctor.name;
      default:
        return doctor.name;
    }
  }

  int _getColumnIndex(String column) {
    switch (column) {
      case 'name':
        return 1;
      default:
        return 1;
    }
  }
}
