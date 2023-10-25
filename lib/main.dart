import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/Provider/settings_provider.dart';
import 'package:todo/ui/authentication/login-screen.dart';
import 'package:todo/ui/authentication/register_screen.dart';
import 'package:todo/ui/authentication/reset_password.dart';
import 'package:todo/ui/home_screen.dart';
import 'package:todo/ui/splash.dart';
import 'package:todo/ui/tabs/notes/update_note_screen.dart';
import 'package:todo/ui/themes/themes_class.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(
        create: (context) => SettingsProvider(
            pref.getBool('isDark'), pref.getBool('isEnglish') ?? true))
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(Provider.of<SettingsProvider>(context).local),
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: Provider.of<SettingsProvider>(context).mode,
      initialRoute: Splash.route,
      routes: {
        Splash.route: (context) => const Splash(),
        Registration.route: (context) => const Registration(),
        LoginScreen.route: (context) => const LoginScreen(),
        ResetPassword.route: (context) => ResetPassword(),
        HomeScreen.route: (context) => const HomeScreen(),
        UpdateNoteScreen.route: (context) => UpdateNoteScreen()
      },
    );
  }
}

