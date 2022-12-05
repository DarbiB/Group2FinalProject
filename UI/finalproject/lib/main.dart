import 'package:flutter/material.dart';
import 'api.dart';
import 'ViewBill.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group 2 Final',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  /*
  final BillingApi api = BillingApi();
  */

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List invoices = [];
  bool _loaded = false;

  /*

  void initState() {
    super.initState();
    widget.api.findInvoices().then((data) {
      setState(() => {
        invoices = data;
        _loaded = true;
      });
    });
  }

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group 2 Final'),
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
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: TextButton(
                                    onPressed: () => {
                                          Navigator.pop(context),
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewBill(
                                                          invoice['_id']))),
                                        },
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          child: Text(invoice['lname'],
                                              style: const TextStyle(
                                                  fontSize: 10)),
                                        ),
                                        title: Text(
                                          (invoice['pname'] +
                                              ' ' +
                                              invoice['date']),
                                          style: const TextStyle(fontSize: 25),
                                        )))))
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
