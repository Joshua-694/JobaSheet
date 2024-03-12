import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialUsageTracker extends StatefulWidget {
  @override
  _MaterialUsageTrackerState createState() => _MaterialUsageTrackerState();
}

class _MaterialUsageTrackerState extends State<MaterialUsageTracker> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Material amounts entered by the contractor
  double cementAmount = 0.0;
  double fineAggregateAmount = 0.0;
  double coarseAggregateAmount = 0.0;

  // Controllers for text input
  TextEditingController _cementController = TextEditingController();
  TextEditingController _fineAggregateController = TextEditingController();
  TextEditingController _coarseAggregateController = TextEditingController();
  TextEditingController _initialCementController = TextEditingController();
  TextEditingController _initialFineAggregateController =
      TextEditingController();
  TextEditingController _initialCoarseAggregateController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial material amounts from Firestore
    loadMaterialAmounts();
  }

  Future<void> loadMaterialAmounts() async {
    try {
      final snapshot =
          await firestore.collection('materials').doc('amounts').get();
      if (snapshot.exists) {
        setState(() {
          cementAmount = snapshot.data()?['cement'] ?? 0.0;
          fineAggregateAmount = snapshot.data()?['fineAggregate'] ?? 0.0;
          coarseAggregateAmount = snapshot.data()?['coarseAggregate'] ?? 0.0;
        });
      } else {
        // If the document doesn't exist, initialize it with default values and store in Firestore
        await firestore.collection('materials').doc('amounts').set({
          'cement': cementAmount,
          'fineAggregate': fineAggregateAmount,
          'coarseAggregate': coarseAggregateAmount,
        });
      }
    } catch (error) {
      print('Error loading material amounts: $error');
    }
  }

  // Function to update material amount for cement
  void updateCementAmount() async {
    double usedAmount = double.tryParse(_cementController.text) ?? 0.0;
    double initialAmount =
        double.tryParse(_initialCementController.text) ?? 0.0;
    if (usedAmount <= initialAmount) {
      setState(() {
        cementAmount = initialAmount - usedAmount;
        _cementController.clear();
        _initialCementController.text =
            cementAmount.toString(); // Update initial amount for next usage
      });
      // Update Firebase with the new data
      await firestore
          .collection('materials')
          .doc('amounts')
          .update({'cement': cementAmount});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Used amount cannot be greater than the initial amount of Cement.'),
            actions: <Widget>[
              TextButton(
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

  // Function to update material amount for fine aggregate
  void updateFineAggregateAmount() async {
    double usedAmount = double.tryParse(_fineAggregateController.text) ?? 0.0;
    double initialAmount =
        double.tryParse(_initialFineAggregateController.text) ?? 0.0;
    if (usedAmount <= initialAmount) {
      setState(() {
        fineAggregateAmount = initialAmount - usedAmount;
        _fineAggregateController.clear();
        _initialFineAggregateController.text = fineAggregateAmount
            .toString(); // Update initial amount for next usage
      });
      // Update Firebase with the new data
      await firestore
          .collection('materials')
          .doc('amounts')
          .update({'fineAggregate': fineAggregateAmount});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Used amount cannot be greater than the initial amount of Fine Aggregate.'),
            actions: <Widget>[
              TextButton(
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

  // Function to update material amount for coarse aggregate
  void updateCoarseAggregateAmount() async {
    double usedAmount = double.tryParse(_coarseAggregateController.text) ?? 0.0;
    double initialAmount =
        double.tryParse(_initialCoarseAggregateController.text) ?? 0.0;
    if (usedAmount <= initialAmount) {
      setState(() {
        coarseAggregateAmount = initialAmount - usedAmount;
        _coarseAggregateController.clear();
        _initialCoarseAggregateController.text = coarseAggregateAmount
            .toString(); // Update initial amount for next usage
      });
      // Update Firebase with the new data
      await firestore
          .collection('materials')
          .doc('amounts')
          .update({'coarseAggregate': coarseAggregateAmount});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Used amount cannot be greater than the initial amount of Coarse Aggregate.'),
            actions: <Widget>[
              TextButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Usage Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMaterialCard('Cement', cementAmount, _cementController,
                  updateCementAmount, _initialCementController),
              _buildMaterialCard(
                  'Fine Aggregate',
                  fineAggregateAmount,
                  _fineAggregateController,
                  updateFineAggregateAmount,
                  _initialFineAggregateController),
              _buildMaterialCard(
                  'Coarse Aggregate',
                  coarseAggregateAmount,
                  _coarseAggregateController,
                  updateCoarseAggregateAmount,
                  _initialCoarseAggregateController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(
      String materialType,
      double amount,
      TextEditingController controller,
      void Function() onPressed,
      TextEditingController initialAmountController) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materialType,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Initial Amount:'),
                      TextField(
                        controller: initialAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Initial Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remaining Amount: $amount units'),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Used Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: onPressed,
              child: Text('Update Amount'),
            ),
          ],
        ),
      ),
    );
  }
}
