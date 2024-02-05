import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobasheet/src/features/authentification/screens/welcomescreen/welcome_screen.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/documents.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/financials.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/inspections.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/projects.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/report.dart';
import 'package:jobasheet/src/features/core/screens/dashboard/team_leads.dart';

import 'package:jobasheet/src/features/core/screens/drawer_pages/people_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List imgData = [
    "assets/images/documents.png",
    "assets/images/project.png",
    "assets/images/teamleads.png",
    "assets/images/Finance.png",
    "assets/images/project-manager.png",
    "assets/images/goals.png",
  ];

  List titles = [
    "Documents",
    "Projects",
    "Team Leads",
    "Financials",
    "Inspections",
    "Reports",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
            "Jobasheet",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                accountName: Text("Joshua"),
                accountEmail: Text("onyangojoshua694@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person_2_outlined),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(
                "People",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PeopleScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text(
                "Documents",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text(
                "Project Management",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.money),
              title: Text(
                "Financial",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "Settings and Support",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                "Update Profile",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.person_2_sharp),
            ),
            Divider(),
            SizedBox(height: 10),
            ListTile(
              title: GestureDetector(
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ),
                  );
                },
              ),
              leading: Icon(Icons.logout_outlined, color: Colors.red),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          mainAxisSpacing: 25),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: imgData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Documents(),
                                  ),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Projects(),
                                  ),
                                );
                                break;
                              case 2:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamLeads(),
                                  ),
                                );
                                break;
                              case 3:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Finance(),
                                  ),
                                );
                                break;
                              case 4:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Inspections(),
                                  ),
                                );
                                break;
                              case 5:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Reports(),
                                  ),
                                );
                                break;
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(imgData[index], width: 100),
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
