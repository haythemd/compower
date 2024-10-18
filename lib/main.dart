import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/pages/ProjectPage.dart';
import 'package:todo/pages/Tasks/AddTasks.dart';
import 'package:todo/pages/Tasks/listTasks.dart';
import 'package:todo/pages/authwrapper.dart';
import 'package:todo/pages/homePage.dart';
import 'package:todo/pages/loginPage.dart';
import 'package:todo/pages/new_project_screen.dart';
import 'package:todo/pages/onboardPage.dart';
import 'package:todo/pages/projectsPage.dart';
import 'package:todo/pages/registerPage.dart';

import 'models/project.dart';

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
    'home': (BuildContext)=> ProjectsListPage(),
    'login': (BuildContext)=> const LoginPage(),
    'register': (BuildContext)=> RegisterPage(),
    'newProject': (BuildContext)=> const NewProjectScreen(),
    'projects': (BuildContext)=> ProjectsPage(),
    'onboard': (BuildContext)=> AuthWrapper(),
    'addTask': (BuildContext)=> AddTaskPage(),


  },
      onGenerateRoute: (settings) {
        if (settings.name == 'project') {
          final args = settings.arguments as Project;
          return MaterialPageRoute(
            builder: (context) => ProjectPage(project: args),
          );
        } else if (settings.name == 'tasks') {
          final args = settings.arguments as Project;
          return MaterialPageRoute(
            builder: (context) => ListTasksPage(project: args),
          );
        }
        return null;
      },


      initialRoute: 'onboard',
      // Set the home page
    );
  }
}
