import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';
import 'package:hmanager/models/finished_data_model.dart';
import 'package:hmanager/models/stock_model.dart';
import 'package:hmanager/widgets/no_data_screen.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/tabbar.dart';

class StockHome extends StatefulWidget {
  const StockHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StockHomeState createState() => _StockHomeState();
}

class _StockHomeState extends State<StockHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Stream<List<StockModel>>? stock;
  Future<List<FinishedGroupModel>>? products;
  final callApi = CallApi();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    stock = callApi.getMaterialStream();
    products = callApi.fetchFinishedData();
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      stock = callApi.getMaterialStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          // tab bar view here
          ReusableTabBar(
            tabs: const [
              Tab(
                text: 'Raw Material',
              ),
              Tab(
                text: 'Final Products',
              ),
            ],
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                StreamBuilder<List<StockModel>>(
                    stream: stock,
                    builder:
                        (context, AsyncSnapshot<List<StockModel>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            final hasHSN = item.hsn != '';
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Text(
                                      item.itemCode,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        'Material: ${item.name} ',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        hasHSN ? '(${item.hsn})' : '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                      item.quantity == 0
                                          ? 'Out of Stock'
                                          : 'Qty: ${item.quantity.toString()}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: item.quantity == 0
                                              ? Colors.red
                                              : Colors.green)),
                                ),
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
                    }),

                // second tab bar view widget
                FutureBuilder<List<FinishedGroupModel>>(
                  future: products,
                  builder: (context,
                      AsyncSnapshot<List<FinishedGroupModel>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text(
                                    ' ${item.products[0].name}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: item.batches.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final batch = item.batches[index];
                                        final batchId = batch.batchId;
                                        final alphabeticPart =
                                            batchId.replaceAll(
                                                RegExp(r'[^A-Za-z]'), '');
                                        final numericPart = batchId.replaceAll(
                                            RegExp(r'[^0-9]'), '');
                                        return ExpansionTile(
                                          title: ListTile(
                                            tileColor: Colors.grey[100],
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  Colors.grey.shade400,
                                              child: Text(
                                                '$alphabeticPart\n$numericPart',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                            title: Text(
                                              'Material: ${batch.material.name}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: batch.colors.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final color =
                                                    batch.colors[index];
                                                return Card(
                                                  child: ListTile(
                                                    title: Text(
                                                      'Color: ${color.color}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    trailing: Text(
                                                      color.quantity == 0
                                                          ? 'Out of Stock'
                                                          : 'Qty: ${color.quantity.toString()}',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            color.quantity == 0
                                                                ? Colors.red
                                                                : Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
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
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
