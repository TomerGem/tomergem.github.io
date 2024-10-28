import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landing_page/components/basic_layout.dart';
import 'package:landing_page/features/user_dashboard/presentation/example_mongo_widget.dart';
// import 'package:landing_page/core/resources/mongo/db_services.dart';

class TemplateView extends ConsumerStatefulWidget {
  const TemplateView({super.key});

  @override
  ConsumerState createState() => _TemplateViewState();
}

class _TemplateViewState extends ConsumerState<TemplateView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //  late Future<List<dynamic>> items;
  User? user;

  // @override
  // void initState() {
  //   super.initState();
  //   items = ApiService.getItems();
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    user = _auth.currentUser;

    return CommonLayoutView(title: 'User Dashboard', body: MongoExample());
  }
}
