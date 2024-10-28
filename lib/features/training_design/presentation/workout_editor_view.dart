import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:landing_page/components/basic_layout.dart';
import 'package:landing_page/features/training_design/presentation/workout_editor_page.dart';

class WorkoutEditorView extends ConsumerStatefulWidget {
  final int exerciseId;

  const WorkoutEditorView({super.key, required this.exerciseId});

  @override
  ConsumerState createState() => _WorkoutEditorViewState();
}

class _WorkoutEditorViewState extends ConsumerState<WorkoutEditorView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  Widget build(BuildContext context) {
    user = _auth.currentUser;

    return CommonLayoutView(
      title: 'Workout Editor',
      body: WorkoutEditor(workoutId: widget.exerciseId),
    );
  }
}
