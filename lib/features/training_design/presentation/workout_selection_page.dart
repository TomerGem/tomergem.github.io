import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:landing_page/core/resources/id_services/id_services.dart';
import 'package:landing_page/features/training_design/presentation/workout_editor_view.dart';

// Workout model class
class Workout {
  final int id;
  final String image;
  final String title;
  final String description;
  final bool isCreateNew;
  final int owner;
  final String access;
  final Map<String, dynamic> lastChanged;

  Workout({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    this.isCreateNew = false,
    required this.owner,
    required this.access,
    required this.lastChanged,
  });
}

// State notifier for managing workout data
class WorkoutNotifier extends StateNotifier<Map<String, List<Workout>>> {
  WorkoutNotifier() : super({});

  Future<void> fetchWorkouts(String type, String sportType) async {
    await Future.delayed(Duration(seconds: 2));
    List<Workout> workouts = [];
    int count;
    if (type == 'myWorkouts') {
      count = 5;
    } else if (type == 'groupWorkouts') {
      count = 3;
    } else {
      count = 10;
    }

    String noImageBase64 =
        'iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=';

    for (int i = 1; i <= count; i++) {
      workouts.add(Workout(
        id: i,
        image: noImageBase64,
        title: i == 1 && type == 'myWorkouts'
            ? 'Create New'
            : 'Workout $i ($sportType)',
        description: i == 1 && type == 'myWorkouts' ? '' : 'Description $i',
        isCreateNew: i == 1 && type == 'myWorkouts',
        owner: 1,
        access: type == 'myWorkouts'
            ? 'me'
            : type == 'groupWorkouts'
                ? 'group'
                : 'community',
        lastChanged: {
          'By': 1,
          'time': DateTime.now().toIso8601String(),
        },
      ));
    }

    state = {
      ...state,
      '$type-$sportType': workouts,
    };
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, Map<String, List<Workout>>>((ref) {
  return WorkoutNotifier();
});

class WorkoutSelection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout Selection'),
          bottom: TabBar(
            tabs: ['Run', 'Walk', 'Bike', 'Swim']
                .map((sport) => Tab(text: sport))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: ['Run', 'Walk', 'Bike', 'Swim']
              .map((sport) => WorkoutList(sportType: sport))
              .toList(),
        ),
      ),
    );
  }
}

class WorkoutList extends ConsumerStatefulWidget {
  final String sportType;

  WorkoutList({required this.sportType});

  @override
  _WorkoutListState createState() => _WorkoutListState();
}

class _WorkoutListState extends ConsumerState<WorkoutList> {
  late Future<void> _fetchMyWorkoutsFuture;
  late Future<void> _fetchGroupWorkoutsFuture;
  late Future<void> _fetchCommunityWorkoutsFuture;

  @override
  void initState() {
    super.initState();
    _fetchMyWorkoutsFuture = ref
        .read(workoutProvider.notifier)
        .fetchWorkouts('myWorkouts', widget.sportType);
    _fetchGroupWorkoutsFuture = ref
        .read(workoutProvider.notifier)
        .fetchWorkouts('groupWorkouts', widget.sportType);
    _fetchCommunityWorkoutsFuture = ref
        .read(workoutProvider.notifier)
        .fetchWorkouts('communityWorkouts', widget.sportType);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<void>(
            future: _fetchMyWorkoutsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final myWorkouts = ref.watch(
                        workoutProvider)['myWorkouts-${widget.sportType}'] ??
                    [];
                return Section(
                    title: 'My Workouts',
                    workouts: myWorkouts,
                    isMyWorkouts: true);
              }
            },
          ),
          FutureBuilder<void>(
            future: _fetchGroupWorkoutsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final groupWorkouts = ref.watch(
                        workoutProvider)['groupWorkouts-${widget.sportType}'] ??
                    [];
                return Section(
                    title: 'Group Workouts', workouts: groupWorkouts);
              }
            },
          ),
          FutureBuilder<void>(
            future: _fetchCommunityWorkoutsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final communityWorkouts = ref.watch(workoutProvider)[
                        'communityWorkouts-${widget.sportType}'] ??
                    [];
                return Section(
                    title: 'Community Workouts', workouts: communityWorkouts);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Workout> workouts;
  final bool isMyWorkouts;

  Section(
      {required this.title, required this.workouts, this.isMyWorkouts = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return WorkoutCard(workout: workouts[index]);
            },
          ),
        ),
      ],
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (workout.image.isNotEmpty) {
      imageBytes = base64Decode(workout.image);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutEditorView(
                exerciseId: workout.isCreateNew ? -1 : workout.id),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageBytes != null
                ? Image.memory(imageBytes,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Icon(Icons.image_not_supported, size: 100),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(workout.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(workout.description),
            ),
          ],
        ),
      ),
    );
  }
}
