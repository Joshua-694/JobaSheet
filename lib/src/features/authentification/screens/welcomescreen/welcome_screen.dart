import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobasheet/src/constants/image_string.dart';
import 'package:jobasheet/src/features/authentification/screens/login/login_screen.dart';
import 'package:jobasheet/src/features/authentification/screens/singup/singup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage(jLoginImage), height: height * 0.5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'welcome to jobasheet',
                    style: GoogleFonts.montserrat(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sreamline your project management with powerful tools and features.Lets build success together',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          side: BorderSide(color: Colors.black)),
                      child: Text('Login'.toUpperCase()),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingUpScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder()),
                      child: Text(
                        'SingUp'.toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
