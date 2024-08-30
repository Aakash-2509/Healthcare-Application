// view/screens/profile/screen/profile_screen.dart
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/global/app_string.dart';
import 'package:adhiriya_ai_webapp/view/screens/home/screen/footer.dart';
import 'package:adhiriya_ai_webapp/view/widgets/appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhiriya_ai_webapp/sharedpreference/sharedpreference.dart';
import 'package:get/get.dart';

import '../../../../constansts/text_styles.dart';
import '../../../../model/usermodel.dart';
import '../repo/provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Future<UserDatum> userFuture;
  void _refreshUsers() {
    setState(() {
      ref.refresh(usersProvider);
      userFuture = ref.refresh(userProvider.future);
    });
  }

  void _refreshUserDetails() {
    setState(() {
      ref.refresh(usersProvider);
      userFuture = ref.refresh(userProvider.future);
    });
  }

  void _editUser(BuildContext context, UserDatum user) async {
    Get.toNamed('/edituser',
        arguments: {'user': user, 'onSave': _refreshUsers});
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userProvider);
    final usernameAsyncValue = ref.watch(usernameProvider);
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
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
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
                          height: availableheight,
                          width: availablewidth,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                ref.refresh(userProvider);
                              },
                              child: userAsyncValue.when(
                                data: (user) => Padding(
                                  padding: const EdgeInsets.all(16.0),
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
                                            padding: EdgeInsets.all(8.0),
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
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 100,
                                        width: availablewidth,
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                      "assets/splash/Ellipse 1.png"),
                                                ),
                                                const SizedBox(width: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${user.firstName} ${user.lastName}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                    Text(
                                                      user.email,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge!
                                                          .copyWith(
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        height: 300,
                                        width: availablewidth,
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  Appstring.aboutMe,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: 20,
                                                      ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      _editUser(context, user);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Appstring.edit,
                                                      style: getTextTheme()
                                                          .displayLarge!
                                                          .copyWith(
                                                              fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${Appstring.name}: ${user.firstName}\t${user.lastName}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                    fontSize: 15,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${Appstring.email}: ${user.email}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                    fontSize: 15,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${Appstring.phone}: ${user.mobileNo}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                    fontSize: 15,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${Appstring.role}: ${user.roleId.name}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!
                                                  .copyWith(
                                                    fontSize: 15,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            if (user.gender != null)
                                              Text(
                                                '${Appstring.gender}: ${user.gender}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                      fontSize: 15,
                                                    ),
                                              ),
                                            const SizedBox(height: 8),
                                            if (user.dob != null)
                                              Text(
                                                '${Appstring.dob}: ${user.dob!.length >= 10 ? user.dob?.substring(0, 10) : user.dob}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                      fontSize: 15,
                                                    ),
                                              ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ListTile(
                                        title: Text(
                                          Appstring.resetPassword,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontSize: 20,
                                              ),
                                        ),
                                        onTap: () {
                                          Get.toNamed('/resetpassword');
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (error, stackTrace) => Center(
                                    child: Text('${Appstring.error}: $error')),
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
            );
          },
        ));
  }
}
