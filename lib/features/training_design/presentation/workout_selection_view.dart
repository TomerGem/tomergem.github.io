import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:landing_page/components/basic_layout.dart';
import 'package:landing_page/features/training_design/presentation/workout_selection_page.dart';

// import 'package:landing_page/core/resources/mongo/db_services.dart';

class WorkoutSelectionView extends ConsumerStatefulWidget {
  const WorkoutSelectionView({super.key});

  @override
  ConsumerState createState() => _WorkoutSelectionViewState();
}

class _WorkoutSelectionViewState extends ConsumerState<WorkoutSelectionView> {
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

    return CommonLayoutView(
        title: 'Workout Selection', body: WorkoutSelection());
  }
}
