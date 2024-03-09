import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference projectsCollection =
      FirebaseFirestore.instance.collection('projects');

  Future<void> addProject(Map<String, dynamic> project) async {
    await projectsCollection.add(project);
  }

  Future<void> addWorkerToProject(
      String projectId, Map<String, dynamic> worker) async {
    await projectsCollection.doc(projectId).collection('workers').add(worker);
  }

  Stream<List<Map<String, dynamic>>> getProjects() {
    return projectsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }
}

class CurrentProjects extends StatefulWidget {
  const CurrentProjects({Key? key}) : super(key: key);

  @override
  State<CurrentProjects> createState() => _CurrentProjectsState();
}

class _CurrentProjectsState extends State<CurrentProjects> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController projectOwnerController = TextEditingController();
  final TextEditingController projectCostController = TextEditingController();
  final TextEditingController projectLocationController =
      TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();
  final TextEditingController workerNameController = TextEditingController();
  final TextEditingController workerRoleController = TextEditingController();
  final TextEditingController workerAmountController = TextEditingController();

  List<Map<String, dynamic>> projects = [];
  @override
  void initState() {
    super.initState();
    // Fetch projects data from Firestore when the widget is initialized
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    _firestoreService.getProjects().listen((projectData) {
      setState(() {
        // Update the projects list with the data from Firestore
        projects = projectData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contractor Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Project',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _openCreateProjectDialog(context);
                },
                child: Text('Add Project'),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Add Worker to Project',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('Select Project'),
                value: selectedProject,
                onChanged: (value) {
                  setState(() {
                    selectedProject = value!;
                  });
                },
                items: projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project['name'],
                    child: Text(project['name']),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: workerNameController,
                decoration: InputDecoration(labelText: 'Worker Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: workerRoleController,
                decoration: InputDecoration(labelText: 'Worker Role'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: workerAmountController,
                decoration: InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  addWorkerToProject();
                },
                child: Text(
                  'Add Worker to the Project',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Project List with Workers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Cost')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Workers')),
                  ],
                  rows: projects.map((project) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(project['name'])),
                        DataCell(Text(project['cost'].toString())),
                        DataCell(Text(project['location'])),
                        DataCell(Text(project['type'])),
                        DataCell(
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (project['workers'] as List<dynamic> ??
                                      [])
                                  .map<Widget>((worker) => Text(worker['name']))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? selectedProject;

  void addProject() {
    setState(() async {
      String projectName = projectOwnerController.text;
      double projectCost = double.tryParse(projectCostController.text) ?? 0.0;
      String projectLocation = projectLocationController.text;
      String projectType = projectTypeController.text;

      if (projectName.isNotEmpty && projectCost > 0) {
        Map<String, dynamic> projectData = {
          'name': projectName,
          'cost': projectCost,
          'location': projectLocation,
          'type': projectType,
        };

        await _firestoreService.addProject(projectData);

        projectOwnerController.clear();
        projectCostController.clear();
        projectLocationController.clear();
        projectTypeController.clear();
      } else {
        // Show an error message or handle the case where project details are incomplete
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please provide valid project details.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void addWorkerToProject() async {
    setState(() {
      for (var project in projects) {
        if (project['name'] == selectedProject) {
          if (!project['workers'].contains(workerNameController.text)) {
            Map<String, dynamic> workerData = {
              'name': workerNameController.text,
              'role': workerRoleController.text,
              'amount': double.tryParse(workerAmountController.text) ?? 0.0,
            };

            _firestoreService.addWorkerToProject(project['id'], workerData);

            workerNameController.clear();
            workerRoleController.clear();
            workerAmountController.clear();
            selectedProject = null;
          } else {
            // Show an error message or handle the case where the worker already exists
            // ... (rest of your code)
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Worker already exists in the project.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    });
  }
  /*void addWorkerToProject() {
    setState(() {
      for (var project in projects) {
        if (project['name'] == selectedProject) {
          if (!project['workers'].contains(workerNameController.text)) {
            project['workers'].add(
                '${workerNameController.text} (${workerRoleController.text}, \$${workerAmountController.text})');
            break;
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Worker already exists in the project.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }

      workerNameController.clear();
      workerRoleController.clear();
      workerAmountController.clear();
      selectedProject = null;
    });
  }*/

  void _openCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: projectOwnerController,
                decoration: InputDecoration(labelText: 'Project Owner'),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: projectCostController,
                decoration: InputDecoration(labelText: 'Project Cost'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: projectLocationController,
                decoration: InputDecoration(labelText: 'Project Location'),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: projectTypeController,
                decoration: InputDecoration(labelText: 'Project Type'),
              ),
              SizedBox(height: 15),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addProject();
                Navigator.of(context).pop();
              },
              child: Text('Create Project'),
            ),
          ],
        );
      },
    );
  }
}
