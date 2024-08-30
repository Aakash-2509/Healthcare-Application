import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/model/enterprisemodel.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/widget/buildcardinfo.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';
import '../../../../constansts/const_colors.dart';
import '../../../../constansts/text_styles.dart';
import '../../../../sharedpreference/sharedpreference.dart';

class Allenterprisescreen extends ConsumerStatefulWidget {
  const Allenterprisescreen({super.key});

  @override
  ConsumerState<Allenterprisescreen> createState() =>
      _AllenterprisescreenState();
}

class _AllenterprisescreenState extends ConsumerState<Allenterprisescreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool isAscending = true;
  String _sortColumn = 'name'; // Track the current sort column
  int currentPage = 1;
  int selectedPageSize = 10;
  final List<String> size = [
    '5',
    '10',
    '15',
    '20',
  ];
  String? selectedValue;

  void _refreshEnterprise() {
    ref.refresh(allenterprise(Tuple2(currentPage, selectedPageSize)));
  }

  void _editUser(BuildContext context, EnterpriseDetail enterprise) async {
    Get.toNamed('/editenterprisescreen',
        arguments: {'enterprise': enterprise, 'onSave': _refreshEnterprise});
  }

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
    _refreshEnterprise();
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _refreshEnterprise();
    }
  }

  void _deleteEnterprise(String enterpriseId) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Appstring.deleteUser,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 20),
          ),
          content: Text(
            Appstring.deleteUserString,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 15),
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
      bool success = await ref.read(apiProvider).deleteEnterprise(enterpriseId);
      if (success) {
        Fluttertoast.showToast(msg: Appstring.enterpriseDeletedSuccessfully);
        _refreshEnterprise();
      } else {
        Fluttertoast.showToast(msg: Appstring.enterpriseDeleteUnsuccessfully);
      }
    }
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
    final usernameAsyncValue = ref.watch(allUsersProvider(const Tuple2(1, 10)));
    final userData =
        ref.watch(allenterprise(Tuple2(currentPage, selectedPageSize)));
    final doctorAsyncValue = ref.watch(doctorsProvider(const Tuple2(1, 10)));
    final healthcarecenterAsyncValue =
        ref.watch(centersProvider(const Tuple2(1, 10)));
    final enterpriseAsyncValue = ref.watch(allenterprise(const Tuple2(1, 10)));
    final role = SharedPreferenceManager().getrole();

    int doctorCount = doctorAsyncValue.when(
      data: (doc) => doc.doctorData.length,
      loading: () => 0,
      error: (err, stack) => 0,
    );
    int userCount = usernameAsyncValue.when(
      data: (doc) => doc.totalRecords,
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

    return Scaffold(
      appBar: CustomAppBar(title: Appstring.adhiriyaAI, role: role.toString()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          double availableHeight = constraints.maxHeight;
          return RefreshIndicator(
            onRefresh: () async {
              _refreshEnterprise();
            },
            child: userData.when(
              data: (users) {
                final filteredUsers = users.enterpriseDetails
                    .where((user) => user.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                filteredUsers.sort((a, b) {
                  int result;
                  switch (_sortColumn) {
                    case 'name':
                      result = a.name.compareTo(b.name);
                      break;
                    default:
                      result = a.name.compareTo(b.name);
                  }
                  return isAscending ? result : -result;
                });

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
                                      Colors.blue,
                                      ConstColors.backgroundColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      Appstring.filter,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 15),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: CustomTextFormField(
                                        customText: Appstring.search,
                                        controller: _searchController,
                                        validator: null,
                                        inputFormatters: const [],
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              _searchQuery = value;
                                            },
                                          );
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
                                            _refreshEnterprise();
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
                                    Get.toNamed('/addenterprisescreen');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(8.0),
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    Appstring.addEnterprise,
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
                                  constraints:
                                      BoxConstraints(minWidth: availableWidth),
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
                                            Appstring.srno,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
                                          ),
                                          numeric: false,
                                        ),
                                        DataColumn(
                                          label: Text(
                                            Appstring.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            Appstring.address,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            Appstring.pincode,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            Appstring.phoneNumber,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            Appstring.status,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            Appstring.more,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: ConstColors
                                                      .backgroundColor,
                                                ),
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
                                                SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    user.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    user.address,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    user.pinCode,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    user.phoneNumber,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    user.status,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(fontSize: 15),
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
                                                              Appstring.edit,
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
                                                              Appstring.delete,
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
                                                      _editUser(context, user);
                                                    } else if (result ==
                                                        'delete') {
                                                      _deleteEnterprise(
                                                          user.id);
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
                              onPressed: users.enterpriseDetails.length ==
                                      selectedPageSize
                                  ? _goToNextPage
                                  : null,
                              child: Text(
                                Appstring.frontArrow,
                                style: TextStyle(
                                  color: users.enterpriseDetails.length ==
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
                                  _refreshEnterprise();
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
              error: (error, stack) =>
                  Center(child: Text(Appstring.failedUsers)),
            ),
          );
        },
      ),
      bottomNavigationBar: buildFooter(double.maxFinite),
    );
  }

  int _getColumnIndex(String columnName) {
    switch (columnName) {
      case 'name':
        return 1;
      default:
        return 0;
    }
  }
}
