import 'package:adhiriya_ai_webapp/constansts/const_colors.dart';
import 'package:adhiriya_ai_webapp/constansts/text_styles.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';
import 'package:adhiriya_ai_webapp/view/screens/auth_module/repo/apiservice.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/model/category.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/widget/buildcardinfo.dart';
import 'package:adhiriya_ai_webapp/view/screens/profile/repo/provider.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:adhiriya_ai_webapp/view/widgets/custom_textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class Homescreen extends ConsumerStatefulWidget {
  final String role;

  const Homescreen({super.key, required this.role});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool isAscending = true;
  int currentPage = 1;
  int selectedPageSize = 10;
  String role = '';

  void _sortCategories(List<CategoryElement> categories) {
    categories.sort((a, b) {
      return isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getrole();
    super.initState();
    _refreshCategories();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        currentPage = 1; // Reset to the first page when searching
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future getrole() async {
    role = await SharedPreferenceManager().getrole();
  }

  Future<void> _deleteCategory(String catID) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Appstring.deleteCategory,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 20),
          ),
          content: Text(
            Appstring.deleteCategoryString,
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
      bool success = await ref.read(apiProvider).deleteCategory(catID);
      if (success) {
        Fluttertoast.showToast(msg: Appstring.catgeoryDeletedSuccessfully);
        _refreshCategories();
      } else {
        Fluttertoast.showToast(msg: Appstring.catgeoryDeleteUnsuccessfully);
      }
    }
  }

  void _refreshCategories() {
    ref.refresh(categoriesProvider(
        Tuple3(_searchQuery, currentPage, selectedPageSize)));
  }

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
    _refreshCategories();
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      _refreshCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = _searchController.text;

    final categoriesAsyncValue = ref.watch(
        categoriesProvider(Tuple3(searchQuery, currentPage, selectedPageSize)));
    final usersAsyncValue = ref.watch(usersProvider);
    final doctorAsyncValue = ref.watch(doctorProvider);
    final healthcarecenterAsyncValue = ref.watch(healthcarecenterprovider);

    int categoriesCount = categoriesAsyncValue.when(
      data: (category) => category.totalRecords,
      loading: () => 0,
      error: (err, stack) => 0,
    );
    int userCount = usersAsyncValue.when(
      data: (user) => user.totalRecords,
      loading: () => 0,
      error: (err, stack) => 0,
    );
    int doctorCount = doctorAsyncValue.when(
      data: (doc) => doc.doctorData.length,
      loading: () => 0,
      error: (err, stack) => 0,
    );
    int healthcarecenterCount = healthcarecenterAsyncValue.when(
      data: (doc) => doc.total_records,
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
              child: SingleChildScrollView(
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
                            top: 50,
                            left: 16,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: buildInfoCard(
                                      Appstring.totalCategories,
                                      categoriesCount,
                                      Icons.category_outlined,
                                      Colors.blue,
                                      ConstColors.backgroundColor,
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  // role == 'Admin'
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed('/alluserscreen');
                                    },
                                    child: buildInfoCard(
                                      Appstring.totalUsers,
                                      userCount,
                                      Icons.person_outline,
                                      ConstColors.secondaryColor,
                                      ConstColors.black,
                                    ),
                                  ),
                                  // : const SizedBox(),
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: availableWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        Appstring.filter,
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
                                          customText: Appstring.search,
                                          controller: _searchController,
                                          validator: null,
                                          inputFormatters: const [],
                                          onChanged: (value) {
                                            _searchQuery = value;
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
                                              ref.refresh(
                                                categoriesProvider(
                                                  Tuple3(
                                                    searchQuery,
                                                    currentPage,
                                                    selectedPageSize,
                                                  ),
                                                ),
                                              );
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
                                      Get.toNamed('/addcategory');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8.0),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      Appstring.addCategory,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: availableWidth,
                            child: categoriesAsyncValue.when(
                              data: (category) {
                                final filteredCategories = category.categories
                                    .where((c) => c.name
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()))
                                    .toList();

                                if (filteredCategories.isEmpty) {
                                  return buildNoCategoriesFound();
                                } else {
                                  _sortCategories(filteredCategories);
                                  return buildCategoryTable(
                                      filteredCategories, availableWidth);
                                }
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (err, stack) => buildError(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // buildFooter(availableWidth),
                    ],
                  ),
                ),
              ));
        },
      ),
      bottomNavigationBar: buildFooter(double.maxFinite),
    );
  }

  Widget buildCategoryTable(
      List<CategoryElement> categories, double availableWidth) {
    final List<String> size = [
      '5',
      '10',
      '15',
      '20',
    ];
    String? selectedValue;
    final ScrollController _horizontalScrollController = ScrollController();
    final ScrollController verticalScrollController = ScrollController();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).colorScheme.tertiary)),
          width: availableWidth,
          child: Scrollbar(
            controller: _horizontalScrollController,
            child: Scrollbar(
              controller: verticalScrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: verticalScrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontalScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: availableWidth,
                    ),
                    child: DataTable(
                      sortColumnIndex: 0,
                      border: TableBorder.all(
                          color: Theme.of(context).colorScheme.tertiary),
                      sortAscending: isAscending,
                      dataRowMaxHeight: 50,
                      headingRowColor: WidgetStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 3, 48, 85),
                      ),
                      columns: [
                        DataColumn(
                          label: Text(
                            Appstring.srno,
                            style: getTextTheme().headlineLarge!.copyWith(
                                  fontSize: 16,
                                  color: ConstColors.backgroundColor,
                                ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            Appstring.categoryName,
                            style: getTextTheme().headlineLarge!.copyWith(
                                fontSize: 16,
                                color: ConstColors.backgroundColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            Appstring.userName,
                            style: getTextTheme().headlineLarge!.copyWith(
                                fontSize: 16,
                                color: ConstColors.backgroundColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            Appstring.categoryDescription,
                            style: getTextTheme().headlineLarge!.copyWith(
                                fontSize: 16,
                                color: ConstColors.backgroundColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            Appstring.status,
                            style: getTextTheme().headlineLarge!.copyWith(
                                fontSize: 16,
                                color: ConstColors.backgroundColor),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            Appstring.actions,
                            style: getTextTheme().headlineLarge!.copyWith(
                                fontSize: 16,
                                color: ConstColors.backgroundColor),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        categories.length,
                        (index) => DataRow(cells: [
                          DataCell(
                            Text(
                              "${index + 1 + (currentPage - 1) * selectedPageSize}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 300,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                categories[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 300,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                '${categories[index].createdBy.first_name} ${categories[index].createdBy.last_name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          ),
                          DataCell(SizedBox(
                            width: 300,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              categories[index].description,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          )),
                          DataCell(Text(
                            categories[index].status.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 14,
                                ),
                          )),
                          DataCell(
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  onPressed: () {
                                    final RenderBox button =
                                        context.findRenderObject() as RenderBox;
                                    final RenderBox overlay =
                                        Overlay.of(context)
                                            .context
                                            .findRenderObject() as RenderBox;
                                    final Offset position =
                                        button.localToGlobal(Offset.zero,
                                            ancestor: overlay);

                                    showMenu(
                                      context: context,
                                      position: RelativeRect.fromRect(
                                        Rect.fromPoints(
                                          position,
                                          position.translate(button.size.width,
                                              button.size.height),
                                        ),
                                        Offset.zero & overlay.size,
                                      ),
                                      items: <PopupMenuEntry>[
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                              ),
                                              Text(
                                                Appstring.edit,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                              ),
                                              Text(
                                                Appstring.delete,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      elevation: 8.0,
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          switch (value) {
                                            case 1:
                                              Get.toNamed(
                                                  '/editcategory/${categories[index].id}');
                                              break;
                                            case 2:
                                              _deleteCategory(
                                                  categories[index].id);
                                              break;
                                          }
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: currentPage > 1 ? _goToPreviousPage : null,
              child: Text(
                Appstring.backArrow,
                style: TextStyle(
                  color: currentPage > 1 ? Colors.blue : Colors.grey,
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
                  categories.length == selectedPageSize ? _goToNextPage : null,
              child: Text(
                Appstring.frontArrow,
                style: TextStyle(
                  color: categories.length == selectedPageSize
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
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '$selectedPageSize',
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                    ),
                  ],
                ),
                items: size
                    .map((String item) => DropdownMenuItem<String>(
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
                    categoriesProvider(
                      Tuple3(
                        _searchQuery,
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
    );
  }

  Widget buildNoCategoriesFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/splash/404.png",
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 10),
          Text(
            Appstring.noCategoriesFound,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/splash/Folder Not Found.png",
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 10),
          Text(
            Appstring.errorCategories,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
