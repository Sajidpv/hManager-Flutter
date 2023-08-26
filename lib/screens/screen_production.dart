import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/screens/screen_production_process.dart';
import 'package:hmanager/screens/users/admins/production_view_employee_items.dart';
import 'package:hmanager/widgets/no_data_screen.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';

import 'package:hmanager/widgets/tabbar.dart';

class ProductionDetails extends StatefulWidget {
  const ProductionDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductionDetailsState createState() => _ProductionDetailsState();
}

class _ProductionDetailsState extends State<ProductionDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          ReusableTabBar(tabs: const [
            Tab(
              text: 'Processing',
            ),
            Tab(
              text: 'Cutting ',
            ),
            Tab(
              text: 'Tailering ',
            ),
            Tab(
              text: 'Finishing',
            ),
          ], controller: _tabController),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ProcessPage(), //process

                const ProcessItems(index: 1),
                const ProcessItems(index: 2),
                const ProcessItems(index: 3)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessItems extends StatelessWidget {
  const ProcessItems({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    Future<List<EmployeeModel>>? users;

    switch (index) {
      case 1:
        users = CallApi.getFilterdUsers(UserType.Cutter);
        break;
      case 2:
        users = CallApi.getFilterdUsers(UserType.Tailer);
        break;
      case 3:
        users = CallApi.getFilterdUsers(UserType.Finisher);
        break;
    }
    return FutureBuilder(
        future: users,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<EmployeeModel> employees = snapshot.data!;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (BuildContext context, int index) {
                final item = employees[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            item.type.name, // Convert to string
                            style: const TextStyle(fontSize: 8),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(
                          item.empID,
                          style: const TextStyle(fontSize: 10),
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProdViewEmpItems(
                                      empId: item,
                                      isAdmin: true,
                                    )));
                          },
                          child: const Text('View'),
                        )),
                  ),
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
        });
  }
}
