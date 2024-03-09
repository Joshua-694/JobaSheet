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

  Future<List<Map<String, dynamic>>> payWorkers(String projectId) async {
    List<Map<String, dynamic>> paidWorkers = [];

    QuerySnapshot<Map<String, dynamic>> workersSnapshot =
        await projectsCollection.doc(projectId).collection('workers').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> worker
        in workersSnapshot.docs) {
      String workerName = worker['name'];
      double amountPaid = worker['amount'];

      paidWorkers.add({
        'name': workerName,
        'amount': amountPaid,
      });
    }

    return paidWorkers;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController workerNameController = TextEditingController();
  final TextEditingController workerRoleController = TextEditingController();
  final TextEditingController workerAmountController = TextEditingController();

  List<Map<String, dynamic>> projects = [];
  bool paymentSuccess = false;

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
              Center(
                child: Text(
                  'Pay Workers',
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
                    value: project['id'],
                    child: Text(project['name']),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  payWorkers();
                },
                child: Text(
                  'Pay Workers',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Paid Workers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? selectedProject;

// ...

  void payWorkers() async {
    if (selectedProject != null) {
      List<Map<String, dynamic>> projectList = projects
          .where((project) => project['id'] == selectedProject)
          .toList();

      if (projectList.isNotEmpty) {
        Map<String, dynamic> project = projectList.first;
        List<Map<String, dynamic>> paidWorkers =
            await _firestoreService.payWorkers(selectedProject!);

        // Compute the total amount paid
        double totalAmountPaid = paidWorkers
            .map<double>((worker) => worker['amount'] as double)
            .fold(0, (previous, current) => previous + current);

        // Show the list of paid workers with an AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Paid Workers - ${project['name']}'),
              content: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...paidWorkers.map(
                      (worker) => ListTile(
                        title: Text('Name: ${worker['name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount: ${worker['amount']}'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Total Amount Paid: $totalAmountPaid',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      paymentSuccess = true;
                    });
                    // Show the successful message AlertDialog
                    showSuccessMessage();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select a project before paying workers.'),
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

  void showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Payment Successful',
            style: TextStyle(color: Colors.green),
          ),
          content: Text(
            'Workers can check their accounts after 24 hours',
            style: TextStyle(color: Colors.green),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  paymentSuccess = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
// ...
}
