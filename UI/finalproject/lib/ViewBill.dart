import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
// import 'editOwner.dart';

class ViewBill extends StatefulWidget {
  final String id;
  final int hoursStayed, hourRate, amountOwed;

  final BillingApi api = BillingApi();

  ViewBill(this.id, this.hoursStayed, this.hourRate, this.amountOwed,
      {super.key});

  @override
  State<ViewBill> createState() =>
      _ViewBillState(id, hoursStayed, hourRate, amountOwed);
}

class _ViewBillState extends State<ViewBill> {
  final String id;
  final int hoursStayed, hourRate, amountOwed;
  List owners = [];
  bool _loaded = false;

  void initState() {
    super.initState();
    widget.api.getPetsOwners().then((data) {
      setState(() {
        owners = data;
        _loaded = true;
      });
    });
  }

  _ViewBillState(this.id, this.hoursStayed, this.hourRate, this.amountOwed);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group 2 Final | Doggie Dashboard'),
      ),
      body: Center(
          child: _loaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      Container(padding: const EdgeInsets.all(10)),
                      const Text("Bill date",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40)),
                      Container(padding: const EdgeInsets.all(2)),
                      Text("Invoice ID", style: TextStyle(fontSize: 25))
                    ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Container(padding: EdgeInsets.all(5)),
                      const Text('...Loading In Progress...',
                          style: TextStyle(fontSize: 20)),
                      const CircularProgressIndicator()
                    ])),
    );
  }
}
