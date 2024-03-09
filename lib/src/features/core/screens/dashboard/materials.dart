import 'package:flutter/material.dart';

class MaterialManagementSystem extends StatefulWidget {
  @override
  _MaterialManagementSystemState createState() =>
      _MaterialManagementSystemState();
}

class _MaterialManagementSystemState extends State<MaterialManagementSystem> {
  List<Project> projects = [];
  List<MaterialItem> materials = [];
  TextEditingController materialTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController projectController = TextEditingController();

  MaterialItem? selectedMaterial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Management System'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Material',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: materialTypeController,
                decoration: InputDecoration(labelText: 'Material Type'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: projectController,
                decoration: InputDecoration(labelText: 'Project'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  addMaterial();
                },
                child: Text('Add Material'),
              ),
              SizedBox(height: 20),
              Text(
                'Material List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Text('Material Type')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Project')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: materials.map<DataRow>((MaterialItem material) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        SingleChildScrollView(
                          // Wrap Material Type with SingleChildScrollView
                          scrollDirection: Axis.horizontal,
                          child: Text(material.type),
                        ),
                      ),
                      DataCell(
                        SingleChildScrollView(
                          // Wrap Quantity with SingleChildScrollView
                          scrollDirection: Axis.horizontal,
                          child: Text(material.quantity),
                        ),
                      ),
                      DataCell(
                        SingleChildScrollView(
                          // Wrap Project with SingleChildScrollView
                          scrollDirection: Axis.horizontal,
                          child: Text(material.project),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                editMaterial(material);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteMaterial(material);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addMaterial() {
    String materialType = materialTypeController.text;
    String quantity = quantityController.text;
    String project = projectController.text;

    if (materialType.isNotEmpty && quantity.isNotEmpty && project.isNotEmpty) {
      MaterialItem newMaterial = MaterialItem(
          type: materialType, quantity: quantity, project: project);
      materials.add(newMaterial);

      // Clear the text controllers after adding a material
      materialTypeController.clear();
      quantityController.clear();
      projectController.clear();

      setState(() {}); // Update the UI to reflect the changes
    }
  }

  void editMaterial(MaterialItem material) {
    setState(() {
      selectedMaterial = material;
      materialTypeController.text = material.type;
      quantityController.text = material.quantity;
      projectController.text = material.project;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Material'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: materialTypeController,
                  decoration: InputDecoration(labelText: 'Material Type'),
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                ),
                TextFormField(
                  controller: projectController,
                  decoration: InputDecoration(labelText: 'Project'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  updateMaterial(material);
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    });
  }

  void updateMaterial(MaterialItem material) {
    setState(() {
      material.type = materialTypeController.text;
      material.quantity = quantityController.text;
      material.project = projectController.text;
      selectedMaterial = null;

      // Clear the text controllers after updating a material
      materialTypeController.clear();
      quantityController.clear();
      projectController.clear();
    });
  }

  void deleteMaterial(MaterialItem material) {
    setState(() {
      materials.remove(material);
    });
  }
}

class MaterialItem {
  String type;
  String quantity;
  String project;

  MaterialItem(
      {required this.type, required this.quantity, required this.project});
}

class Project {
  String name;

  Project({required this.name});
}
