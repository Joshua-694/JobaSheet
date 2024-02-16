import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class RegisterWorkers extends StatefulWidget {
  const RegisterWorkers({super.key});

  @override
  State<RegisterWorkers> createState() => _RegisterWorkersState();
}

class _RegisterWorkersState extends State<RegisterWorkers> {
  List<Map<String, dynamic>> dataList = [];
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final daysController = TextEditingController();
  final payController = TextEditingController();
  final searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => generatePdf(context),
            icon: Icon(Icons.picture_as_pdf),
          ),
        ],
        title: Text("Register workers", textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Phone Number";
                    }
                    return null;
                  },
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "Phone No.",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please insert Number of Days worked";
                    }
                    ;
                    return null;
                  },
                  controller: daysController,
                  decoration: InputDecoration(
                    hintText: "Days Worked",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a valid pay amount";
                    }
                    ;
                    return null;
                  },
                  controller: payController,
                  decoration: InputDecoration(
                    hintText: "Pay",
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: addWorker, child: Text("Add Worker")),
                SizedBox(height: 10),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "Search",
                  ),
                ),
                SizedBox(height: 20),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("worker")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    var documents = snapshot.data!.docs;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text("Name"),
                            ),
                            DataColumn(
                              label: Text("PhoneNo."),
                            ),
                            DataColumn(
                              label: Text("DaysWorked"),
                            ),
                            DataColumn(
                              label: Text("Pay"),
                            ),
                            DataColumn(
                              label: Text("Increment"),
                            ),
                          ],
                          rows: documents
                              .map(
                                (documents) => DataRow(
                                  cells: [
                                    DataCell(Text(documents["name"])),
                                    DataCell(Text(documents["phoneNumber"])),
                                    DataCell(Text(
                                        documents["daysWorked"].toString())),
                                    DataCell(
                                        Text(documents["totalPay"].toString())),
                                    DataCell(ElevatedButton(
                                        onPressed: () {},
                                        child: Text("Increment Days")))
                                  ],
                                ),
                              )
                              .toList()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addWorker() {
    String name = nameController.text;
    String phoneNumber = phoneController.text;
    int daysWorked = int.tryParse(daysController.text) ?? 0;
    double payPerDay = double.tryParse(payController.text) ?? 0.0;
    double totalPay = daysWorked * payPerDay;

    if (name.isNotEmpty && phoneNumber.isNotEmpty && daysWorked > 0) {
      _firestore.collection("worker").add(
        {
          "name": name,
          "phoneNumber": phoneNumber,
          "daysWorked": daysWorked,
          "totalPay": totalPay,
        },
      );

      setState(
        () {
          dataList.add({
            "name": name,
            "phoneNumber": phoneNumber,
            "daysWorked": daysWorked,
            "totalPay": totalPay,
          });
          clearFields();
        },
      );
    }
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    daysController.clear();
    payController.clear();
  }

  Future<void> generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("worker").get();
    List<Map<String, dynamic>> workers = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ["Name", "Phone Number", "Days Worked", "Total Pay"],
            data: workers
                .map(
                  (data) => [
                    data["name"],
                    data["phoneNumber"],
                    data["daysWorked"].toString(),
                    data["totalPay"].toString(),
                  ],
                )
                .toList(),
          );
        },
      ),
    );
    final output = await getExternalStorageDirectory();
    final file = File("${output?.path}/jobasheet.pdf");

    await file.writeAsBytes(await pdf.save());

    print("PDF file saved at :${file.path}");

    _openFile(file);
  }

  Future<void> _openFile(File file) async {
    if (await file.exists()) {
      await OpenFile.open(file.path);
    }
  }
}
