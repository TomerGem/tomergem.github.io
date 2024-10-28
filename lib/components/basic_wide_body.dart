import 'package:flutter/material.dart';
import 'package:landing_page/components/basic_body.dart';
import 'package:landing_page/components/basic_navigation_drawer.dart';

class BasicWideBody extends StatelessWidget {
  final Widget body;

  const BasicWideBody({required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BasicNavigationDrawer(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BasicBody(body: body),
          ),
        ),
      ],
    );
  }
}
