import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/newPages/projectsPage.dart';
import 'package:todo/pages/onboardPage.dart';

import 'loginPage.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading state
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Projectspage(); // If logged in, show the home page
        }
        return OnboardingPage(); // If not logged in, show the login page
      },
    );
  }
}
