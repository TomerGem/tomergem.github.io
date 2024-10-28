import 'package:flutter/material.dart';
// import 'package:landing_page/core/resources/mongo/db_services.dart';

class BasicBody extends StatefulWidget {
  final Widget body;

  const BasicBody({required this.body, Key? key}) : super(key: key);

  @override
  State<BasicBody> createState() => _BasicBodyState();
}

class _BasicBodyState extends State<BasicBody> {
  // late Future<List<dynamic>> items;

  // @override
  // void initState() {
  // super.initState();
  // items = ApiService.getItems();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
    );
  }
}
