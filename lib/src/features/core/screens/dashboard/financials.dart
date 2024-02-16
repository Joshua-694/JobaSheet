import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/financials/transaction_log.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/financials/workers_payment.dart';

class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  int index = 0;

  final screens = [
    RegisterWorkers(),
    TransactionLogs(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          onTap: (index) => setState(() => this.index = index),
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.grey,
          color: Colors.black,
          items: [Icon(Icons.money), Icon(Icons.monetization_on_sharp)],
        ),
      ),
    );
  }
}
