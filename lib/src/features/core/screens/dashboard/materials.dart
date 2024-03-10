import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Materials extends StatefulWidget {
  @override
  _MaterialsState createState() => _MaterialsState();
}

class _MaterialsState extends State<Materials> {
  final TextEditingController materialController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: materialController,
                    decoration: InputDecoration(labelText: 'Material Name'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: valueController,
                    decoration: InputDecoration(labelText: 'Material Value'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _addMaterial(
                  materialController.text,
                  double.tryParse(valueController.text) ?? 0,
                );
              },
              child: Text('Add Material'),
            ),
            SizedBox(height: 20),
            Text(
              'Material Usage Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: _getMaterialUsageData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final materialData = snapshot.data!.docs[index].data()!;
                        return ListTile(
                          title: Text(materialData['material']),
                          subtitle: Text('Value: ${materialData['value']}'),
                          trailing: Text('Date: ${materialData['date']}'),
                        );
                      },
                    );
                  } else {
                    return Text("No material usage data available.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMaterial(String material, double value) async {
    CollectionReference materials =
        FirebaseFirestore.instance.collection('materials');
    await materials.add({
      'material': material,
      'value': value,
      'date': DateTime.now().toLocal().toString(),
    });
    materialController.clear();
    valueController.clear();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getMaterialUsageData() async {
    CollectionReference materials =
        FirebaseFirestore.instance.collection('materials');
    return await materials.get() as QuerySnapshot<Map<String, dynamic>>;
  }
}
