import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/cutter_assigned_model.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/finisher_assign_model.dart';
import 'package:hmanager/models/tailer_assign_model.dart';
import 'package:hmanager/screens/splash_screen.dart';
import 'package:hmanager/screens/users/admins/finish%20screen/cutter_finish_product.dart';
import 'package:hmanager/screens/users/admins/finish%20screen/finish_product.dart';
import 'package:hmanager/screens/users/admins/finish%20screen/tailer_finish_product.dart';
import 'package:hmanager/widgets/date_parcer.dart';
import 'package:hmanager/widgets/no_data_screen.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';

class ProdViewEmpItems extends StatefulWidget {
  ProdViewEmpItems({Key? key, required this.empId, required this.isAdmin})
      : super(key: key);
  final EmployeeModel empId;
  final bool isAdmin;

  @override
  State<ProdViewEmpItems> createState() => _ProdViewEmpItemsState();
}

class _ProdViewEmpItemsState extends State<ProdViewEmpItems> {
  final callApi = CallApi();
  Future<List<CutterAssignModel>>? cutterAssItemStream;
  Future<List<TailerAssignModel>>? tailerAssItemStream;
  Future<List<FinisherAssignModel>>? finisherAssItemStream;
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      // Reload data here
      cutterAssItemStream = callApi.getAssignCutter();
      tailerAssItemStream = callApi.getAssignTailer();

      finisherAssItemStream = callApi.getAssignFinisher();
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.empId.type.name;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
          appBar: widget.isAdmin
              ? AppBar(
                  title: Text(widget.empId.name.toString()),
                )
              : null,
          backgroundColor: Colors.grey.shade300,
          body: role == 'Cutter' //CUTTER VIEW
              ? FutureBuilder(
                  future: cutterAssItemStream,
                  builder: (context,
                      AsyncSnapshot<List<CutterAssignModel>> snapshot) {
                    if (snapshot.hasData) {
                      final filteredData = snapshot.data!
                          .where((item) => widget.empId.empID == item.empID)
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
                                  trailing: item.status == 'Finished'
                                      ? const Text(
                                          'Finished',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.green),
                                        )
                                      : TextButton(
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
                )
              : role == 'Tailer' //TAILER VIEW
                  ? FutureBuilder(
                      future: tailerAssItemStream,
                      builder: (context,
                          AsyncSnapshot<List<TailerAssignModel>> snapshot) {
                        if (snapshot.hasData) {
                          final filteredData = snapshot.data!
                              .where((item) => widget.empId.empID == item.empId)
                              .toList();

                          if (filteredData.isNotEmpty) {
                            return ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = filteredData[index];

                                List<String> dateParts =
                                    formatDateTime(item.date);

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
                                        'Qty: ${item.assignedQuantity}'
                                            .toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      trailing: item.status == 'Finished'
                                          ? const Text(
                                              'Finished',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green),
                                            )
                                          : TextButton(
                                              onPressed: () {
                                                pageNavigator(
                                                  TailerFinishItem(emp: item),
                                                  context,
                                                );
                                              },
                                              child:
                                                  const Text('Add to Finish'),
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
                    )
                  : //FINISHER
                  FutureBuilder(
                      future: finisherAssItemStream,
                      builder: (context,
                          AsyncSnapshot<List<FinisherAssignModel>> snapshot) {
                        if (snapshot.hasData) {
                          final filteredData = snapshot.data!
                              .where((item) => widget.empId.empID == item.empId)
                              .toList();

                          if (filteredData.isNotEmpty) {
                            return ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = filteredData[index];

                                List<String> dateParts =
                                    formatDateTime(item.date);

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
                                        'Qty: ${item.assignedQuantity}'
                                            .toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      trailing: item.status == 'Finished'
                                          ? const Text(
                                              'Finished',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green),
                                            )
                                          : TextButton(
                                              onPressed: () {
                                                pageNavigator(
                                                  FinisherinishItem(emp: item),
                                                  context,
                                                );
                                              },
                                              child:
                                                  const Text('Add to Finish'),
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
                    )),
    );
  }
}
