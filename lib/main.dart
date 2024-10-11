import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/pages/homePage.dart';
import 'package:todo/pages/loginPage.dart';
import 'package:todo/pages/onboardPage.dart';
import 'package:todo/pages/projectsPage.dart';
import 'package:todo/pages/registerPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes:
  {
    'home': (BuildContext)=> MyHomePage(title: 'ToDo',),
    'login': (BuildContext)=> LoginPage(),
    'onboard': (BuildContext)=> ProjectsPage(),
    'register': (BuildContext)=> RegisterPage(),
    'singleToDo': (BuildContext)=> MyHomePage(title: 'ToDo',),



      },
      initialRoute: 'home',
      // Set the home page
    );
  }
}
