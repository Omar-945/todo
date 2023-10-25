import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/Provider/settings_provider.dart';
import 'package:todo/ui/authentication/login-screen.dart';
import 'package:todo/ui/home_screen.dart';

class Splash extends StatefulWidget {
  static const String route = 'splashScreen';

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingsProvider>(context);
    Future.delayed(const Duration(seconds: 2), () {
      Navigate(context);
    });
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(settingProvider.isDark()
                  ? 'assets/images/splash_dark.png'
                  : 'assets/images/splash_light.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  void Navigate(BuildContext context) async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLogedBefore()) {
      await authProvider.getUserData();
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.route);
    }
  }
}
