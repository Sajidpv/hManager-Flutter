import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';
import 'package:hmanager/models/product_model.dart';
import 'package:hmanager/models/supplier_model.dart';
import 'package:hmanager/widgets/date_parcer.dart';
import 'package:hmanager/widgets/no_data_screen.dart';
import 'package:hmanager/widgets/purchase_details_show_dialog.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';

import 'package:hmanager/widgets/tabbar.dart';

class PurchaseHome extends StatefulWidget {
  const PurchaseHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PurchaseHomeState createState() => _PurchaseHomeState();
}

class _PurchaseHomeState extends State<PurchaseHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SupplierModel? supplier;
  Stream<List<ProductMaterialModel>>? purchases;
  final callApi = CallApi();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
  }

  void _handleTabChange() {
    setState(() {
      purchases = callApi.getPurchaseStream();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      // Reload data here
      purchases = callApi.getPurchaseStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // tab bar view here
            ReusableTabBar(
              tabs: const [
                Tab(
                  text: 'Purchase Order',
                ),
                Tab(
                  text: 'Purchase',
                ),
                Tab(
                  text: 'Debit Note/Purchase Return',
                ),
              ],
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  const Center(
                    child: Text('No record to show'),
                  ),
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    child: StreamBuilder(
                      stream: purchases,
                      builder: (context,
                          AsyncSnapshot<List<ProductMaterialModel>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = snapshot.data![index];

                              List<String> dateParts =
                                  formatDateTime(item.date);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PurchaseDialog(
                                          dateParts: dateParts,
                                          supplierName:
                                              item.supplier.toString(),
                                          invoice: item.invoice,
                                          items: item.items,
                                          totalAmount:
                                              item.totalAmount.toDouble(),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.grey.shade300,
                                        child: Text(
                                          '${dateParts[1]}\n${dateParts[0]}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      title: Text(
                                        item.supplier.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        item.invoice,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      trailing: Text(
                                        'Amount: ${item.totalAmount}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
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
                    ),
                  ),

                  // second tab bar view widget
                  const Center(
                    child: Text('No record to show'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
