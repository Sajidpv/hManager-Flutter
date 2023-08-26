import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';
import 'package:hmanager/models/cutter_assigned_model.dart';
import 'package:hmanager/models/cutter_finishing_model.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/screens/splash_screen.dart';
import 'package:hmanager/screens/users/admins/finish%20screen/cutter_finish_product.dart';
import 'package:hmanager/widgets/date_parcer.dart';
import 'package:hmanager/widgets/no_data_screen.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/signout.dart';
import 'package:hmanager/widgets/tabbar.dart';

class CutterHome extends StatefulWidget {
  const CutterHome({super.key, required this.empID});
  final String empID;
  @override
  //ignore: library_private_types_in_public_api
  _CutterHomeState createState() => _CutterHomeState();
}

class _CutterHomeState extends State<CutterHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeModel?>(
      future: CallApi.getEmployeeById(widget.empID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerListTile();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          EmployeeModel? user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
            ),
            backgroundColor: Colors.grey.shade300,
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Text(
                        user!.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
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
                    aboutBoxChildren: [],
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
            body: Home(
              empID: widget.empID,
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.empID});
  final String empID;
  @override
  //ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //FirestoreStreams streamProvider = FirestoreStreams();
  Stream<List<CutterFinishingModel>>? productStream;

  @override
  void initState() {
    //productStream = streamProvider.getCutterFinishStream(widget.empID.empID);
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  final callApi = CallApi();
  @override
  Widget build(BuildContext context) {
    Future<List<CutterAssignModel>>? cutterAssItemStream =
        callApi.getAssignCutter();

    return Column(
      children: [
        ReusableTabBar(tabs: const [
          Tab(
            text: 'Report',
          ),
          Tab(
            text: 'Material ',
          ),
          Tab(
            text: 'Finished ',
          ),
        ], controller: _tabController),
        // tab bar view here
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const Center(child: Text('No report to show')),
              // ProdViewEmpItems(
              //   empId: widget.empID,
              //   isAdmin: false,
              // ),
              FutureBuilder(
                future: cutterAssItemStream,
                builder:
                    (context, AsyncSnapshot<List<CutterAssignModel>> snapshot) {
                  if (snapshot.hasData) {
                    final filteredData = snapshot.data!
                        .where((item) =>
                            widget.empID == item.employID &&
                            item.status != 'Finished')
                        .toList();

                    if (filteredData.isNotEmpty) {
                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = filteredData[index];

                          List<String> dateParts = formatDateTime(item.date);

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Text(
                                    '${dateParts[1]}\n${dateParts[0]}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                title: Text(
                                  '${item.material} - ${item.product}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'Qty: ${item.assignedQuantity}'.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    pageNavigator(
                                      CutterFinishItems(emp: item),
                                      context,
                                    );
                                  },
                                  child: const Text('Add to Finish'),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const NoDataScreen();
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const ShimmerListTile();
                  }
                },
              ),
              FutureBuilder(
                future: cutterAssItemStream,
                builder:
                    (context, AsyncSnapshot<List<CutterAssignModel>> snapshot) {
                  if (snapshot.hasData) {
                    final filteredData = snapshot.data!
                        .where((item) =>
                            widget.empID == item.employID &&
                            item.status == 'Finished')
                        .toList();

                    if (filteredData.isNotEmpty) {
                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = filteredData[index];

                          List<String> dateParts = formatDateTime(item.date);

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Text(
                                      '${dateParts[1]}\n${dateParts[0]}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  title: Text(
                                    '${item.material} - ${item.product}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  subtitle: Text(
                                    'Qty: ${item.assignedQuantity}'.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  trailing: const Text(
                                    'Finished',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.green),
                                  )),
                            ),
                          );
                        },
                      );
                    } else {
                      return const NoDataScreen();
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const ShimmerListTile();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
