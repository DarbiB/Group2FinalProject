import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'main.dart';
// import 'editOwner.dart';

class ViewBill extends StatefulWidget {
  final String id;

  final BillingApi api = BillingApi();

  ViewBill(this.id, {super.key});

  @override
  State<ViewBill> createState() => _ViewBillState(id);
}

class _ViewBillState extends State<ViewBill> {
  final String id;
  List stayInfo = [];
  bool _loaded = false;

  _ViewBillState(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Group 2 Final'),
    ));
  }
}
