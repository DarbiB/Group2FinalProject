import 'package:flutter/material.dart';
import 'api.dart';
import 'ViewBill.dart';
import 'models/invoice.dart';
import 'models/owner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group 2 Final | Doggie Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final BillingApi api = BillingApi();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List invoices = [];
  List owners = [];
  List pets = [];
  bool _loaded = false;

  void initState() {
    super.initState();
    widget.api.getAllInvoiceAndPet().then((invData) {
      setState(() {
        invoices = invData;
        _loaded = true;
      });
    });
  }

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
                    const Text('Invoices',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40)),
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      children: [
                        ...invoices
                            .map<Widget>((invoice) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: TextButton(
                                    onPressed: () => {
                                          Navigator.pop(context),
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewBill(Billing.fromJson(
                                                          invoice)))),
                                        },
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      // leading: const CircleAvatar(
                                      //   radius: 30,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      title: Text(
                                          'Owner: ' +
                                              invoice['fname'] +
                                              ' ' +
                                              invoice['lname'] +
                                              "\nPet: " +
                                              (invoice['petName']),
                                          style: const TextStyle(
                                              letterSpacing: 3, fontSize: 15)),
                                      tileColor: Colors.indigo,
                                      textColor: Colors.white,
                                    ))))
                            .toList(),
                      ],
                    ))
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
    );
  }
}
