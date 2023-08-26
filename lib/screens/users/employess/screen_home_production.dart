import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/screens/screen_production.dart';
import 'package:hmanager/sections/fab_with_menu.dart';
import 'package:hmanager/widgets/constants.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/signout.dart';

class ProductionHome extends StatefulWidget {
  const ProductionHome({super.key, required this.empID});
  final String empID;
  @override
  State<ProductionHome> createState() => _ProductionHomeState();
}

class _ProductionHomeState extends State<ProductionHome> {
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
                    height: 70,
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
            body: const ProductionDetails(),
            floatingActionButton: FabWithIcons(
              icons: icons2,
              onIconTapped: (index) {},
              tooltips: fabTooltips2,
              screen: 'production',
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
