import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobasheet/firebase_options.dart';
import 'package:jobasheet/src/features/authentification/screens/welcomescreen/welcome_screen.dart';
import 'package:jobasheet/src/utils/theme/widget_themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      title: 'jobasheet',
      theme: JAppTheme.LightTheme,
      darkTheme: JAppTheme.darkTheme,
      home: WelcomeScreen(),
    );
  }
}
