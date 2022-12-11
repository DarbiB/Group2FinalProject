import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
// import 'editOwner.dart';

class ViewBill extends StatefulWidget {
  //final String id, ownerId;
  //final int hoursStayed, hourRate, amountOwed;

  final BillingApi api = BillingApi();

  ViewBill(
      //this.id, this.hoursStayed, this.hourRate, this.amountOwed, this.ownerId,
      {super.key});

  @override
  State<ViewBill> createState() => _ViewBillState(
      //id, hoursStayed, hourRate, amountOwed, ownerId
      );
}

class _ViewBillState extends State<ViewBill> {
  //final String id, ownerId;
  //final int hoursStayed, hourRate, amountOwed;
  List owners = [];
  bool _loaded = true;

  void initState() {
    super.initState();
    widget.api.getPetsOwners().then((data) {
      setState(() {
        owners = data;
        _loaded = true;
      });
    });
  }

  _ViewBillState(
      //this.id, this.hoursStayed, this.hourRate, this.amountOwed, this.ownerId
      );

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
                    Container(padding: const EdgeInsets.all(5)),
                    Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(width: 10, color: Colors.grey),
                        ),
                        child: Text("Invoice Data",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    Container(padding: const EdgeInsets.all(5)),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 10, color: Colors.lightGreen)),
                      child: Text(
                        "Owner Data",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Container(padding: EdgeInsets.all(5)),
                      const Text('...Loading In Progress...',
                          style: TextStyle(fontSize: 20)),
                      const CircularProgressIndicator()
                    ])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage())),
              }),
    );
  }
}
