import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/supplier_model.dart';
import 'package:hmanager/screens/screen_home_purchase.dart';
import 'package:hmanager/screens/screen_home_stock.dart';
import 'package:hmanager/screens/screen_production.dart';
import 'package:hmanager/screens/users/admins/add%20screen/add_material_to_stock.dart';
import 'package:hmanager/screens/users/employess/screen_home_accounts.dart';
import 'package:hmanager/screens/users/employess/screen_home_sales.dart';
import 'package:hmanager/sections/fab_with_menu.dart';
import 'package:hmanager/widgets/constants.dart';
import 'package:hmanager/widgets/no_data_screen.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';
import 'package:hmanager/widgets/signout.dart';
import 'package:hmanager/widgets/status_updater.dart';

import '../../../widgets/tabbar.dart';

late BuildContext myContext;

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Widget? activeScreen;

  String? currentScreen;
  @override
  void initState() {
    currentScreen = 'home';
    myContext = context;
    activeScreen = const Home();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  switchScreen(Widget screen) {
    setState(() {
      activeScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Home',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              setState(() {
                currentScreen = 'home';
              });

              switchScreen(const Home());
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: ListTile(
                  title: Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                switchScreen(const Home());
                setState(() {
                  currentScreen = 'home';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Production'),
              onTap: () {
                setState(() {
                  currentScreen = 'production';
                });

                switchScreen(const ProductionDetails());
                Navigator.pop(context);
              },
            ),
            ListTile(
              enabled: false,
              leading: const Icon(Icons.sell),
              title: const Text('Sales'),
              onTap: () {
                setState(() {
                  currentScreen = 'sales';
                });
                switchScreen(const SalesHome());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Purchase'),
              onTap: () {
                setState(() {
                  currentScreen = 'purchase';
                });
                switchScreen(const PurchaseHome());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Stock'),
              onTap: () {
                setState(() {
                  currentScreen = 'stock';
                });
                switchScreen(const StockHome());
                Navigator.pop(context);
              },
            ),
            ListTile(
              enabled: false,
              leading: const Icon(Icons.account_balance),
              title: const Text('Accounts'),
              onTap: () {
                setState(() {
                  currentScreen = 'accounts';
                });
                switchScreen(const AccountsHome());
                Navigator.pop(context);
              },
            ),
            const AboutListTile(
              icon: Icon(
                Icons.info,
              ),
              applicationIcon: Icon(
                Icons.store,
              ),
              applicationName: 'HaashStore',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2023 Haash Technologies',
              aboutBoxChildren: [
                ///Content goes here...
              ],
              child: Text('About app'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                signOut(context);
              },
            ),
          ],
        ),
      ),
      body: activeScreen,
      floatingActionButton: currentScreen == 'home'
          ? FabWithIcons(
              icons: icons1,
              onIconTapped: (index) {},
              tooltips: fabTooltips1,
              screen: currentScreen!,
            )
          : currentScreen == 'production'
              ? FabWithIcons(
                  icons: icons2,
                  onIconTapped: (index) {},
                  tooltips: fabTooltips2,
                  screen: currentScreen!,
                )
              : currentScreen == 'stock'
                  ? FloatingActionButton(
                      tooltip: 'Add Stock',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMaterial()));
                      },
                      child: const Icon(Icons.add),
                    )
                  : FabWithIcons(
                      icons: icons3,
                      onIconTapped: (index) {},
                      tooltips: fabTooltips3,
                      screen: currentScreen!,
                    ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isReload = false;
  bool? isUpdated;
  bool? isDeleted;
  Future<List<EmployeeModel>>? users;
  Future<List<SupplierModel>>? suppliers;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    _getDatas();
  }

  void _getDatas() {
    users = CallApi.getEmployee();
    suppliers = CallApi.getsupplier();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReusableTabBar(tabs: const [
          Tab(
            text: 'Report',
          ),
          Tab(
            text: 'Employees ',
          ),
          Tab(
            text: 'Suppliers ',
          ),
        ], controller: _tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const Center(child: Text('No report to show')),

              //View employees

              FutureBuilder(
                future: users,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final List<EmployeeModel> employees = snapshot.data!;
                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = employees[index];
                        final isAdmin = item.type == UserType.Admin;
                        if (!isAdmin) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 20, right: 20),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              // child: Slidable(
                              //   key: const ValueKey(0),
                              //   endActionPane: ActionPane(
                              //       motion: const ScrollMotion(),
                              //       children: [
                              //         SlidableAction(
                              //           backgroundColor: const Color(0xFFFE4A49),
                              //           foregroundColor: Colors.white,
                              //           icon: Icons.delete,
                              //           label: "Delete",
                              //           onPressed: (context) {
                              //             showDeleteConfirmationDialog(
                              //                 context, item, () {
                              //               setState(() {
                              //                 employees.removeAt(index);
                              //               });
                              //             });
                              //           },
                              //         )
                              //       ]),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(
                                    item.empID.toString(), // Convert to string
                                    style: const TextStyle(fontSize: 8),
                                  ),
                                ),
                                title: Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  item.type.name,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: !isAdmin
                                    ? buildStatusDropdown(
                                        item.status,
                                        (Status? newValue) async {
                                          if (newValue != null) {
                                            final newStatus = newValue
                                                .toString()
                                                .split('.')
                                                .last;

                                            isUpdated = await CallApi
                                                .updateEmployeeStatus(
                                                    item.id, newStatus, 'user');
                                            if (isUpdated == true) {
                                              setState(() {
                                                isReload = true;
                                              });
                                              // ignore: use_build_context_synchronously
                                              showSnackBar(
                                                context,
                                                'Status updated for ${item.name}: $newStatus',
                                              );
                                            }
                                          }
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            // ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const NoDataScreen();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const ShimmerListTile();
                  }
                },
              ),

              //View Suppliers

              FutureBuilder(
                  future: suppliers,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final List<SupplierModel> supplier = snapshot.data!;
                      return ListView.builder(
                        itemCount: supplier.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = supplier[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 20, right: 20),
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              // child: Slidable(
                              //   key: const ValueKey(0),
                              //   endActionPane: ActionPane(
                              //       motion: const ScrollMotion(),
                              //       children: [
                              //         SlidableAction(
                              //             backgroundColor:
                              //                 const Color(0xFFFE4A49),
                              //             foregroundColor: Colors.white,
                              //             icon: Icons.delete,
                              //             label: "Delete",
                              //             onPressed: (BuildContext context) {
                              //               showDeleteConfirmationDialog(
                              //                   context, item, () {
                              //                 setState(() {
                              //                   supplier.removeAt(index);
                              //                 });
                              //               });
                              //             })
                              //       ]),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Text(
                                    'S',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                title: Text(item.name,
                                    style: const TextStyle(fontSize: 12)),
                                subtitle: Text(
                                  item.address,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: buildStatusDropdown(
                                  item.status,
                                  (Status? newValue) async {
                                    if (newValue != null) {
                                      final newStatus =
                                          newValue.toString().split('.').last;
                                      isUpdated =
                                          await CallApi.updateEmployeeStatus(
                                              item.id, newStatus, 'supplier');
                                      if (isUpdated == true) {
                                        showSnackBar(
                                          context,
                                          'Status updated for ${item.name}: $newStatus',
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            //),
                          );
                        },
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const NoDataScreen();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const ShimmerListTile();
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
