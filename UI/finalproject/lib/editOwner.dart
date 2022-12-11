import 'package:flutter/material.dart';
import 'main.dart';
import 'api.dart';
import 'ViewBill.dart';

class editOwner extends StatefulWidget {
  //final String id, fname, lname, address, city, state, zip, email, phone;
  final BillingApi api = BillingApi();
  /*
  editOwner(this.id, this.fname, this.lname, this.address, this.city,
      this.state, this.zip, this.email, this.phone,
      {super.key});
  */

  @override
  State<editOwner> createState() => _editOwnerState(
      //id, fname, lname, address, city, state, zip, email, phone
      );
}

class _editOwnerState extends State<editOwner> {
  //final String id, fname, lname, address, city, state, zip, email, phone;

  _editOwnerState(
      //this.id, this.fname, this.lname, this.address, this.city,
      //this.state, this.zip, this.email, this.phone
      );

  /*
  void _editOwnerInfo(
      id, fname, lname, address, city, state, zip, email, phone
      ) {
    setState(() {
      widget.api.editOwner(id, fname, lname, address, city, state, zip, email, phone
            );
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }
  */

  TextEditingController fnameControl = TextEditingController();
  TextEditingController lnameControl = TextEditingController();
  TextEditingController addControl = TextEditingController();
  TextEditingController cityControl = TextEditingController();
  TextEditingController stateControl = TextEditingController();
  TextEditingController zipControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController phoneControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group 2 Final | Doggie Dashboard'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: <Widget>[
                const Text("Edit Owner Information",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextFormField(controller: fnameControl),
                TextFormField(controller: lnameControl),
                TextFormField(controller: addControl),
                TextFormField(controller: cityControl),
                TextFormField(controller: stateControl),
                TextFormField(controller: zipControl),
                TextFormField(controller: emailControl),
                TextFormField(controller: phoneControl),
                ElevatedButton(
                    onPressed: () => {
                          //edit line
                        },
                    child: const Text("Confirm Changes"))
              ]))
        ],
      )),
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
