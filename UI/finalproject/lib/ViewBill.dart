import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
import 'editOwner.dart';
import 'models/invoice.dart';

class ViewBill extends StatefulWidget {
  //final String id, ownerId;
  //final int hoursStayed, hourRate, amountOwed;
  final Billing invoice;

  final BillingApi api = BillingApi();

  ViewBill(
      //this.id, this.hoursStayed, this.hourRate, this.amountOwed, this.ownerId,
      this.invoice,
      {super.key});

  @override
  State<ViewBill> createState() => _ViewBillState(
      //id, hoursStayed, hourRate, amountOwed, ownerId
      );
}

class _ViewBillState extends State<ViewBill> {
  //final String id, ownerId;
  //final int hoursStayed, hourRate, amountOwed;
  Map owner = {};
  bool _loaded = false;

  void initState() {
    super.initState();
    widget.api.getOwner(widget.invoice.ownerId).then((data) {
      setState(() {
        owner = data;
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
                            border: Border.all(width: 10, color: Colors.cyan),
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                          children: [
                            Text("Invoice Data",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            Text(
                                "ID: ${widget.invoice.id}\nHours Stayed: ${widget.invoice.hoursStayed}\nHour Charge: ${widget.invoice.hourRate}\nTotal: ${widget.invoice.amountOwed}")
                          ],
                        )),
                    Container(padding: const EdgeInsets.all(5)),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 10, color: Colors.lightBlueAccent),
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Owner Data",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text('Name: ' +
                                  owner['ownerFName'] +
                                  ' ' +
                                  owner['ownerLName'] +
                                  "\nAddress: " +
                                  owner['ownerAddress'] +
                                  ",\n" +
                                  owner['ownerCity'] +
                                  ', ' +
                                  owner['ownerZip'] +
                                  "\nPhone: " +
                                  owner['ownerPhone'] +
                                  "\nEmail: " +
                                  owner['ownerEmail'] +
                                  "\nPet Name: " +
                                  owner['ownerPet'][0]['petName']),
                              TextButton(
                                onPressed: () => {
                                  Navigator.pop(context),
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => editOwner(
                                              owner['_id'],
                                              owner['ownerFName'],
                                              owner['ownerLName'],
                                              owner['ownerAddress'],
                                              owner['ownerCity'],
                                              owner['ownerState'],
                                              owner['ownerZip'],
                                              owner['ownerEmail'],
                                              owner['ownerPhone'])))
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 0, 20, 0)),
                                      Text("Edit Owner Info",
                                          style: TextStyle(
                                              color: Colors.black,
                                              backgroundColor: Colors.red,
                                              fontSize: 15))
                                    ]),
                              )
                            ]))
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Container(padding: const EdgeInsets.all(5)),
                      const Text('...Loading In Progress...',
                          style: TextStyle(fontSize: 20)),
                      const CircularProgressIndicator()
                    ])),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.home),
          onPressed: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage())),
              }),
    );
  }
}
