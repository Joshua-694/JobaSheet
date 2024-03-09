import 'package:flutter/material.dart';

class _MassPaymentScreenState extends State<MassPaymentScreen> {
  List<WorkerPaymentInfo> workersInfo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mass Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Workers',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _buildWorkerSelectionList(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _openTotalPaymentScreen(context);
              },
              child: Text('View Total Payment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerSelectionList() {
    List<String> workers = ['Worker 1', 'Worker 2', 'Worker 3', 'Worker 4'];

    return Column(
      children: workers.map((worker) {
        WorkerPaymentInfo workerInfo =
            workersInfo.firstWhere((w) => w.worker == worker, orElse: () {
          WorkerPaymentInfo newWorkerInfo =
              WorkerPaymentInfo(worker, 0.0, isSelected: false);
          workersInfo.add(newWorkerInfo);
          return newWorkerInfo;
        });

        return ListTile(
          title: Row(
            children: [
              Text(worker),
              SizedBox(width: 8.0),
              Text(
                '\$${workerInfo.paymentAmount.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          trailing: Checkbox(
            value: workerInfo.isSelected,
            onChanged: (value) {
              _openAmountInputDialog(workerInfo);
            },
          ),
        );
      }).toList(),
    );
  }

  void _openAmountInputDialog(WorkerPaymentInfo workerInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Payment Amount for ${workerInfo.worker}'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(Icons.attach_money),
            ),
            onChanged: (value) {
              setState(() {
                workerInfo.paymentAmount = double.tryParse(value) ?? 0.0;
              });
            },
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
                Navigator.of(context).pop();
                _updateTotalPaymentScreen();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _updateTotalPaymentScreen() {
    setState(() {
      // Do any additional updates for the TotalPaymentScreen if needed
    });
  }

  void _openTotalPaymentScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TotalPaymentScreen(workersInfo),
      ),
    );
  }
}

class TotalPaymentScreen extends StatelessWidget {
  final List<WorkerPaymentInfo> workersInfo;

  TotalPaymentScreen(this.workersInfo);

  @override
  Widget build(BuildContext context) {
    double totalPayment =
        workersInfo.map((w) => w.paymentAmount).fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: Text('Total Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'List of Selected Workers',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            // Manually list the workers
            for (int i = 0; i < workersInfo.length; i++)
              Container(
                child: Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '${i + 1}. ${workersInfo[i].worker} - \$${workersInfo[i].paymentAmount.toStringAsFixed(2)}',
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkerPaymentInfo {
  final String worker;
  double paymentAmount;
  bool isSelected;

  WorkerPaymentInfo(this.worker, this.paymentAmount, {this.isSelected = false});
}

class MassPaymentScreen extends StatefulWidget {
  @override
  _MassPaymentScreenState createState() => _MassPaymentScreenState();
}
