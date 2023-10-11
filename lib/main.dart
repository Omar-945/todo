import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/authentication/login-screen.dart';
import 'package:todo/ui/authentication/register_screen.dart';
import 'package:todo/ui/authentication/reset_password.dart';
import 'package:todo/ui/themes/themes_class.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      initialRoute: LoginScreen.route,
      routes: {
        Registration.route: (context) => const Registration(),
        LoginScreen.route: (context) => const LoginScreen(),
        ResetPassword.route: (context) => ResetPassword()
      },
    );
  }
}

