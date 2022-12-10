import 'package:flutter/material.dart';
import 'api.dart';
import 'ViewBill.dart';

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
  bool _loaded = false;

  void initState() {
    super.initState();
    widget.api.getAllInvoices().then((invData) {
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
                                                      ViewBill(
                                                          invoice['_id'],
                                                          invoice[
                                                              'hoursStayed'],
                                                          invoice['hourRate'],
                                                          invoice[
                                                              'amountOwed']))),
                                        },
                                    child: const ListTile(
                                        leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.green,
                                            child: Text("Date of stay",
                                                style:
                                                    TextStyle(fontSize: 10))),
                                        title: Text(
                                          "Owner/s name" + "\n" + "Pets name",
                                          style: TextStyle(
                                              letterSpacing: 3, fontSize: 20),
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
