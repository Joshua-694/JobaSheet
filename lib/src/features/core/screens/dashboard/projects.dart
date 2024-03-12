import 'package:flutter/material.dart';
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

  Future<List<Map<String, dynamic>>> getWorkersForProject(
      String projectId) async {
    List<Map<String, dynamic>> workers = [];

    try {
      var snapshot =
          await projectsCollection.doc(projectId).collection('workers').get();

      workers = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      print('Error fetching workers: $e');
    }

    return workers;
  }
}

class CurrentProjects extends StatefulWidget {
  const CurrentProjects({Key? key}) : super(key: key);

  @override
  State<CurrentProjects> createState() => _CurrentProjectsState();
}

class _CurrentProjectsState extends State<CurrentProjects> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectCostController = TextEditingController();
  final TextEditingController projectLocationController =
      TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();
  final TextEditingController workerNameController = TextEditingController();
  final TextEditingController workerRoleController = TextEditingController();
  final TextEditingController workerAmountController = TextEditingController();

  List<Map<String, dynamic>> projects = [];
  String? selectedProject;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    _firestoreService.getProjects().listen((projectData) {
      setState(() {
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
              ElevatedButton(
                onPressed: () {
                  _openCreateProjectDialog(context);
                },
                child: Text('Add Project'),
              ),
              SizedBox(height: 20),
              Text(
                'Select Project',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: Text('Select Project'),
                value: selectedProject,
                onChanged: (value) {
                  setState(() {
                    selectedProject = value;
                  });
                },
                items: projects.map((project) {
                  return DropdownMenuItem<String>(
                    value: project['name'],
                    child: Text(project['name']),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Add Worker to Project',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: workerNameController,
                decoration: InputDecoration(labelText: 'Worker Name'),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: workerRoleController,
                decoration: InputDecoration(labelText: 'Worker Role'),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: workerAmountController,
                decoration: InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _addWorkerToProject();
                },
                child: Text('Add Worker to Project'),
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
                  rows: projects.map<DataRow>((project) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(project['name'] ?? 'Unknown name')),
                        DataCell(Text((project['cost'] ?? 0).toString())),
                        DataCell(
                            Text(project['location'] ?? 'Unknown location')),
                        DataCell(Text(project['type'] ?? 'Unknown type')),
                        DataCell(
                          Container(
                            height: 150,
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: _firestoreService
                                  .getWorkersForProject(project['id']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  List<Widget> workerWidgets = [];
                                  for (var worker in snapshot.data!) {
                                    workerWidgets.add(
                                      Text(
                                        '${worker['name']} (${worker['role']}, \$${worker['amount']})',
                                      ),
                                    );
                                  }
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: workerWidgets,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text('No workers found');
                                }
                              },
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

  Future<void> _addProject() async {
    String projectName = projectNameController.text;
    double projectCost = double.tryParse(projectCostController.text) ?? 0.0;
    String projectLocation = projectLocationController.text;
    String projectType = projectTypeController.text;

    if (projectName.isNotEmpty && projectCost > 0) {
      Map<String, dynamic> projectData = {
        'name': projectName,
        'cost': projectCost,
        'location': projectLocation,
        'type': projectType,
        'workers': [], // Initialize with an empty workers list
      };

      await _firestoreService.addProject(projectData);

      // Fetch updated projects data from Firestore
      _loadProjects();

      projectNameController.clear();
      projectCostController.clear();
      projectLocationController.clear();
      projectTypeController.clear();
    } else {
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
  }

  Future<void> _addWorkerToProject() async {
    // Implementation to add worker to selected project
  }

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
                controller: projectNameController,
                decoration: InputDecoration(labelText: 'Project Name'),
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
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addProject();
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
