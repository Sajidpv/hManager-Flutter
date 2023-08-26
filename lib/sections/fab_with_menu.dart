import 'package:flutter/material.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_add_employee.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_add_purchase.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_add_supplier.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_cutter_assign.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_finisher_assign.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_tailer_assign.dart';

class FabWithIcons extends StatefulWidget {
  const FabWithIcons({
    super.key,
    required this.icons,
    required this.onIconTapped,
    required this.tooltips,
    required this.screen,
  });

  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  final String screen;
  final List<String> tooltips;

  @override
  State<StatefulWidget> createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(
          height: 235,
          child: Column(
            children: [
              for (int index = 0; index < widget.icons.length; index++)
                _buildChild(index),
            ],
          ),
        ),
        _buildFab(),
      ],
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Colors.black;

    return Container(
      height: 55.0,
      width: 145.0,
      alignment: Alignment.bottomCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            1.0 - index / widget.icons.length / 2.0,
            curve: Curves.easeOut,
          ),
        ),
        child: Row(
          // Use Row to arrange the mini FAB and the text description
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 7, bottom: 7, left: 5, right: 3),
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Text(
                widget.tooltips[index],
                style: TextStyle(fontSize: 10, color: foregroundColor),
              ),
            ),
            FloatingActionButton(
              heroTag: 'child FAB $index',
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(
                widget.icons[index],
                color: foregroundColor,
                size: 15,
              ),
              onPressed: () => _onTapped(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      heroTag: 'main FAB',
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'View Options',
      elevation: 2.0,
      child: const Icon(Icons.add),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
    widget.screen == 'home'
        ? onHomeFunctions(index)
        : widget.screen == 'production'
            ? onProductionsFunctions(index)
            : onPurchaseFunctions(index);
  }

  void onHomeFunctions(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPurchase()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddSupplier()),
      );
    }
  }

  void onProductionsFunctions(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AssignItems()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AssignToTailer()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AssignToFinisher()),
      );
    }
  }

  void onPurchaseFunctions(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPurchase()),
    );
  }
}
