import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    subject.dispose();
    body.dispose();
  }

  sendEmail(String subject, String body, String recipientemail) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipientemail],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send an Email"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(hintText: "Enter E-mail"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: subject,
                decoration: InputDecoration(hintText: "Enter Subject"),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: body,
                decoration: InputDecoration(hintText: "Body"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    _key.currentState!.validate();
                    print("${email.text}");
                    sendEmail(
                      subject.text,
                      body.text,
                      email.text,
                    );
                  },
                  child: Text("Send Email"))
            ],
          ),
        ),
      ),
    );
  }
}
