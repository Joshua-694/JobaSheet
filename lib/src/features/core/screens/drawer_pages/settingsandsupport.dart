import 'package:flutter/material.dart';
import 'package:jobasheet/src/constants/image_string.dart';
import 'package:jobasheet/src/features/core/screens/drawer_pages/fqa.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsSupportPage extends StatefulWidget {
  @override
  _SettingsSupportPageState createState() => _SettingsSupportPageState();
}

class _SettingsSupportPageState extends State<SettingsSupportPage> {
  bool _notificationsEnabled = true;

  void _contactSupport() async {
    const url = 'tel:0799044673';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot launch the dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings & Support'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text('Contact Support'),
            leading: Icon(Icons.contact_support),
            onTap: _contactSupport,
          ),
          ListTile(
            title: Text('FAQ'),
            leading: Icon(Icons.question_answer),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FAQPage()),
              );
            },
          ),
          ListTile(
            title: Text('About us'),
            leading: Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  DrawerImage,
                  width: 30,
                  height: 30,
                ),
                applicationName: 'Jobasheet',
                applicationVersion: '1.0.0',
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                        'This is a simple app build by Moi University Students to help those in the construction Industry manage their workers easily'),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
