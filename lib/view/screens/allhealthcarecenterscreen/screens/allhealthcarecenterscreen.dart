import 'dart:developer';

import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/model/healthcarecenter.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/widget/buildcardinfo.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/repo/provider.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import '../../../../sharedpreference/sharedpreference.dart';

class Allhealthcarecenterscreen extends ConsumerStatefulWidget {
  const Allhealthcarecenterscreen({super.key});

  @override
  ConsumerState<Allhealthcarecenterscreen> createState() =>
      _AllhealthcarecenterscreenState();
}

class _AllhealthcarecenterscreenState
    extends ConsumerState<Allhealthcarecenterscreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true; // To manage sorting order
  bool _sortByName = true; // To manage sorting column
  int currentPage = 1;
  int selectedPageSize = 10;
  final List<String> size = [
    '5',
    '10',
    '15',
    '20',
  ];
  String? selectedValue;

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
    _refreshCenters();
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _refreshCenters();
    }
  }

  void _deleteUser(String userId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Appstring.deleteCenter,
            style: getTextTheme().headlineMedium!.copyWith(fontSize: 20),
          ),
          content: Text(
            Appstring.deleteCenterString,
            style: getTextTheme().headlineMedium!.copyWith(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Appstring.cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(Appstring.yes),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      bool success = await ref.read(apiProvider).deleteCenter(userId);
      if (success) {
        _refreshCenters();
        Fluttertoast.showToast(msg: 'Center deleted successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to delete center');
      }
    }
  }

  void _editDoctor(BuildContext context, HealthCareCenterDatum center) async {
    Get.toNamed('/editcenter',
        arguments: {'center': center, 'onSave': _refreshCenterDetails});
  }

  void _refreshCenters() {
    ref.refresh(centersProvider(Tuple2(currentPage, selectedPageSize)));
  }

  void _refreshCenterDetails() {
    ref.refresh(healthcarecenterprovider);
  }

  void _toggleSorting() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final centerData =
        ref.watch(centersProvider(Tuple2(currentPage, selectedPageSize)));
    final role = SharedPreferenceManager().getrole();
    final doctorAsyncValue = ref.watch(doctorsProvider(const Tuple2(1, 10)));
    final usernameAsyncValue = ref.watch(allUsersProvider(const Tuple2(1, 10)));
    final healthcarecenterAsyncValue = ref.watch(healthcarecenterprovider);
    final enterpriseAsyncValue = ref.watch(allenterprise(const Tuple2(1, 10)));

    int doctorCount = doctorAsyncValue.when(
      data: (doc) => doc.doctorData.length,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    int healthcarecenterCount = centerData.when(
      data: (doc) => doc.total_records,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    int userCount = usernameAsyncValue.when(
      data: (user) => user.totalRecords,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    int enterpriseCount = enterpriseAsyncValue.when(
      data: (doc) => doc.totalRecords,
      loading: () => 0,
      error: (err, stack) => 0,
    );

    return Scaffold(
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          return RefreshIndicator(
            onRefresh: () async {
              _refreshCenterDetails();
            },
            child: centerData.when(
              data: (users) {
                final filteredUsers = users.healthCareCenterData
                    .where((user) => user.address
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                if (_sortByName) {
                  filteredUsers.sort((a, b) {
                    return _isAscending
                        ? a.name.compareTo(b.name)
                        : b.name.compareTo(a.name);
                  });
                }

                return SingleChildScrollView(
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
                                      ConstColors.secondaryColor,
                                      ConstColors.black,
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
                                      Colors.blue,
                                      ConstColors.backgroundColor,
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
                              )),
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
                                          log('Search Query: $_searchQuery');
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
                                          _toggleSorting();
                                        },
                                        child: Text(
                                          _isAscending
                                              ? Appstring.ascending
                                              : Appstring.descending,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed('/addcenterscreen');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8.0),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      'Add Center',
                                      style: getTextTheme()
                                          .displayLarge!
                                          .copyWith(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: availableWidth,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                    sortColumnIndex: 1, // Sort by name column
                                    sortAscending: _isAscending,
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
                                        //   setState(() {
                                        //     _sortByName = true;
                                        //     _isAscending = !_isAscending;
                                        //   });
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
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Speciality',
                                          overflow: TextOverflow.ellipsis,
                                          style: getTextTheme()
                                              .displayLarge!
                                              .copyWith(fontSize: 15),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: 150,
                                          child: Center(
                                            child: Text(
                                              'Time',
                                              overflow: TextOverflow.ellipsis,
                                              style: getTextTheme()
                                                  .displayLarge!
                                                  .copyWith(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Phone Number',
                                          overflow: TextOverflow.ellipsis,
                                          style: getTextTheme()
                                              .displayLarge!
                                              .copyWith(fontSize: 15),
                                        ),
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
                                      filteredUsers.length,
                                      (index) {
                                        final user = filteredUsers[index];
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                (index + 1).toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                      fontSize: 15,
                                                    ),
                                              ),
                                            ),
                                            DataCell(
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  user.name.toString(),
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
                                                  user.address,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  user.speciality.join(', '),
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
                                                width: 150,
                                                child: Center(
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    user.time,
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
                                                width: 100,
                                                child: Center(
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    user.contact,
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
                                                  final result = await showMenu(
                                                    context: context,
                                                    position:
                                                        RelativeRect.fromLTRB(
                                                      details.globalPosition.dx,
                                                      details.globalPosition.dy,
                                                      details.globalPosition.dx,
                                                      details.globalPosition.dy,
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
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    fontSize:
                                                                        12),
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
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                  if (result == 'edit') {
                                                    _editDoctor(context, user);
                                                  } else if (result ==
                                                      'delete') {
                                                    _deleteUser(user.id);
                                                  }
                                                },
                                                child:
                                                    const Icon(Icons.more_vert),
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
                                color:
                                    currentPage > 1 ? Colors.blue : Colors.grey,
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
                            onPressed: users.healthCareCenterData.length ==
                                    selectedPageSize
                                ? _goToNextPage
                                : null,
                            child: Text(
                              Appstring.frontArrow,
                              style: TextStyle(
                                color: users.healthCareCenterData.length ==
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
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
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
                                  centersProvider(
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
}
