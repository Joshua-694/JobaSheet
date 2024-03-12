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
  final TextEditingController projectOwnerController = TextEditingController();
  final TextEditingController projectCostController = TextEditingController();
  final TextEditingController projectLocationController =
      TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();
  final TextEditingController workerNameController = TextEditingController();
  final TextEditingController workerRoleController = TextEditingController();
  final TextEditingController workerAmountController = TextEditingController();

  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> workers = [];
  List<String> workerNames = [];
  String? selectedProject;

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
        // Fetch worker names for the selected project
        _fetchWorkerNames();
      });
    });
  }

  // Fetch worker names for the selected project
  void _fetchWorkerNames() {
    workerNames.clear();
    if (selectedProject != null) {
      for (var project in projects) {
        if (project['name'] == selectedProject) {
          // Check if workers exist for the project
          if (project['workers'] != null) {
            for (var worker in project['workers']) {
              workerNames.add(worker['name']);
            }
          }
          break;
        }
      }
    }
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
                    selectedProject = value;
                    // Fetch worker names when project is selected
                    _fetchWorkerNames();
                  });
                },
                items: projects.isEmpty
                    ? []
                    : projects.map((project) {
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
                  rows: projects.map<DataRow>((project) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(project['name'] ?? 'Unknown name')),
                        DataCell(Text((project['cost'] ?? 0).toString())),
                        DataCell(
                            Text(project['location'] ?? 'Unknown location')),
                        DataCell(Text(project['type'] ?? 'Unknown type')),
                        DataCell(
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  (project['workers'] as List<dynamic>? ?? [])
                                      .map<Widget>((worker) {
                                if (worker != null) {
                                  return Text(
                                    '${worker['name']} (${worker['role']}, \$${worker['amount']})',
                                  );
                                } else {
                                  return Text('Unknown');
                                }
                              }).toList(),
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

  void addProject() async {
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
          'workers': [], // Initialize with an empty workers list
        };

        await _firestoreService.addProject(projectData);

        // Fetch updated projects data from Firestore
        _loadProjects();

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
    setState(() async {
      for (var project in projects) {
        if (project['name'] == selectedProject) {
          if (!project['workers'].contains(workerNameController.text)) {
            Map<String, dynamic> workerData = {
              'name': workerNameController.text,
              'role': workerRoleController.text,
              'amount': double.tryParse(workerAmountController.text) ?? 0.0,
            };

            await _firestoreService.addWorkerToProject(
                project['id'], workerData);

            // Fetch updated worker names for the selected project
            _fetchWorkerNames();

            workerNameController.clear();
            workerRoleController.clear();
            workerAmountController.clear();
            selectedProject = null;
          } else {
            // Show an error message or handle the case where the worker already exists
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
