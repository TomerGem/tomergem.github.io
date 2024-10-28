import 'package:flutter/material.dart';
import 'dart:convert';

// Workout editor page:
// 1. Create new workout
// 2. Edit existing workout
// 3. Update workout
// 4. Delete workout
// 5. Save as template
// 6. Import template

class WorkoutEditor extends StatefulWidget {
  final int? workoutId;

  const WorkoutEditor({Key? key, this.workoutId}) : super(key: key);

  @override
  _WorkoutEditorState createState() => _WorkoutEditorState();
}

class _WorkoutEditorState extends State<WorkoutEditor> {
  final _formKey = GlobalKey<FormState>();
  int? _workoutId;
  String _workoutName = 'Workout Name';
  String _description = '';
  String _sportType = 'RUNNING';
  List<Map<String, dynamic>> _steps = [];

  @override
  void initState() {
    super.initState();
    _workoutId = widget.workoutId;
    if (_workoutId != null) {
      // Fetch existing workout data if editing an existing workout
      // Initialize _workoutName, _description, _sportType, _steps with existing data
    }
  }

  void _addStep() {
    setState(() {
      _steps.add({
        'type': 'work',
        'duration': {'value': 1, 'unit': 'minute'},
        'target': {'intensity': 'high', 'heartRateZone': 4}
      });
    });
  }

  void _addRepeatStep() {
    setState(() {
      _steps.add({'type': 'repeat', 'repetitions': 3, 'steps': []});
    });
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final workout = {
        'workoutId': _workoutId,
        'workoutName': _workoutName,
        'description': _description,
        'sport': _sportType,
        'steps': _steps,
      };
      // Save the workout as JSON (for now, just print it)
      print(jsonEncode(workout));
    }
  }

  void _editStep(int index) {
    // Implement step editing logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _stepFormKey = GlobalKey<FormState>();
        Map<String, dynamic> step = _steps[index];

        return AlertDialog(
          title: Text('Edit Step ${index + 1}'),
          content: Form(
            key: _stepFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: step['type'],
                  decoration: InputDecoration(labelText: 'Step Type'),
                  onChanged: (value) {
                    setState(() {
                      step['type'] = value;
                    });
                  },
                ),
                if (step['type'] == 'repeat')
                  TextFormField(
                    initialValue: step['repetitions'].toString(),
                    decoration: InputDecoration(labelText: 'Repetitions'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        step['repetitions'] = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                if (step['type'] != 'repeat') ...[
                  DropdownButtonFormField<String>(
                    value: step['target']['intensity'],
                    items: ['low', 'medium', 'high']
                        .map((intensity) => DropdownMenuItem(
                              value: intensity,
                              child: Text(intensity),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        step['target']['intensity'] = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Intensity'),
                  ),
                  TextFormField(
                    initialValue: step['duration']['value'].toString(),
                    decoration: InputDecoration(labelText: 'Duration Value'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        step['duration']['value'] =
                            double.tryParse(value!) ?? 0;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: step['duration']['unit'],
                    decoration: InputDecoration(labelText: 'Duration Unit'),
                    onChanged: (value) {
                      setState(() {
                        step['duration']['unit'] = value;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _stepFormKey.currentState!.save();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editNestedSteps(List<Map<String, dynamic>> steps,
      Function(List<Map<String, dynamic>>) onSave) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NestedStepEditor(
          steps: steps,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                _workoutName.isEmpty ? 'Workout Name' : _workoutName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Workout Name'),
                      content: TextFormField(
                        initialValue: _workoutName,
                        decoration: InputDecoration(labelText: 'Workout Name'),
                        onChanged: (value) {
                          setState(() {
                            _workoutName = value;
                          });
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveWorkout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _sportType,
                items: ['RUNNING', 'WALKING']
                    .map((sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(sport),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _sportType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Sport Type'),
              ),
              SizedBox(height: 20),
              Text('Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ..._steps.map((step) {
                final index = _steps.indexOf(step);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text('Step ${index + 1}'),
                    subtitle: step['type'] == 'repeat'
                        ? Text('Repeat ${step['repetitions']} times')
                        : Text(
                            'Type: ${step['type']}, Intensity: ${step['target']['intensity']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editStep(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _steps.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: step['type'] == 'repeat'
                        ? () => _editNestedSteps(step['steps'], (updatedSteps) {
                              setState(() {
                                step['steps'] = updatedSteps;
                              });
                            })
                        : null,
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addStep,
                      child: Text('Add Step'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addRepeatStep,
                      child: Text('Add Repeat Step'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NestedStepEditor extends StatefulWidget {
  final List<Map<String, dynamic>> steps;
  final Function(List<Map<String, dynamic>>) onSave;

  const NestedStepEditor({Key? key, required this.steps, required this.onSave})
      : super(key: key);

  @override
  _NestedStepEditorState createState() => _NestedStepEditorState();
}

class _NestedStepEditorState extends State<NestedStepEditor> {
  List<Map<String, dynamic>> _steps = [];

  @override
  void initState() {
    super.initState();
    _steps = widget.steps;
  }

  void _addStep() {
    setState(() {
      _steps.add({
        'type': 'work',
        'duration': {'value': 1, 'unit': 'minute'},
        'target': {'intensity': 'high', 'heartRateZone': 4}
      });
    });
  }

  void _addRepeatStep() {
    setState(() {
      _steps.add({'type': 'repeat', 'repetitions': 3, 'steps': []});
    });
  }

  void _editStep(int index) {
    // Implement step editing logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _stepFormKey = GlobalKey<FormState>();
        Map<String, dynamic> step = _steps[index];

        return AlertDialog(
          title: Text('Edit Step ${index + 1}'),
          content: Form(
            key: _stepFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: step['type'],
                  decoration: InputDecoration(labelText: 'Step Type'),
                  onChanged: (value) {
                    setState(() {
                      step['type'] = value;
                    });
                  },
                ),
                if (step['type'] == 'repeat')
                  TextFormField(
                    initialValue: step['repetitions'].toString(),
                    decoration: InputDecoration(labelText: 'Repetitions'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        step['repetitions'] = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                if (step['type'] != 'repeat') ...[
                  DropdownButtonFormField<String>(
                    value: step['target']['intensity'],
                    items: ['low', 'medium', 'high']
                        .map((intensity) => DropdownMenuItem(
                              value: intensity,
                              child: Text(intensity),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        step['target']['intensity'] = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Intensity'),
                  ),
                  TextFormField(
                    initialValue: step['duration']['value'].toString(),
                    decoration: InputDecoration(labelText: 'Duration Value'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        step['duration']['value'] =
                            double.tryParse(value!) ?? 0;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: step['duration']['unit'],
                    decoration: InputDecoration(labelText: 'Duration Unit'),
                    onChanged: (value) {
                      setState(() {
                        step['duration']['unit'] = value;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _stepFormKey.currentState!.save();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editNestedSteps(List<Map<String, dynamic>> steps,
      Function(List<Map<String, dynamic>>) onSave) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NestedStepEditor(
          steps: steps,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Nested Steps'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.onSave(_steps);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> step = _steps[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text('Nested Step ${index + 1}'),
              subtitle: step['type'] == 'repeat'
                  ? Text('Repeat ${step['repetitions']} times')
                  : Text(
                      'Type: ${step['type']}, Intensity: ${step['target']['intensity']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editStep(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _steps.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
              onTap: step['type'] == 'repeat'
                  ? () => _editNestedSteps(step['steps'], (updatedSteps) {
                        setState(() {
                          step['steps'] = updatedSteps;
                        });
                      })
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addStep,
            tooltip: 'Add Step',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: _addRepeatStep,
            tooltip: 'Add Repeat Step',
            child: Icon(Icons.loop),
          ),
        ],
      ),
    );
  }
}
