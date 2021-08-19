import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:getfood_project/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getfood_project/utilities/mainscreen.dart';
// Theme and Style
import 'package:getfood_project/theme.dart';
// Imported Screen
import 'package:getfood_project/screens/loginregister.dart';

Future<void> main() async {
  // Initalize Widget Binding
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  // Store SharedPreferences
  SharedPreferences sp = await SharedPreferences.getInstance();

  // Run the application
  runApp(
    ChangeNotifierProvider(
      child: MyApp(),
      create: (BuildContext context) =>
          ThemeProvider(isDarkMode: sp.getBool('isDarkMode') ?? false),
    ),
  );
}

// Application Screen
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // User Authenication Provider
        Provider<AuthenicationService>(
          create: (_) => AuthenicationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenicationService>().authStateChanges,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme,
            title: 'GetFood',
            // Auth Wrapper
            home: AuthenicationWrapper(),
          );
        },
      ),
    );
  }
}
// End of Application Screen

// Go to specified screen based on the login session
class AuthenicationWrapper extends StatelessWidget {
  const AuthenicationWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();

    // Check if user is logged in
    if (firebaseUser != null) {
      // Display Home Screen if user is logged in
      return MainScreen();
    } else {
      // Display Login / Register Screen if user is not logged in
      return LoginRegisterScreen();
    }
  }
}
