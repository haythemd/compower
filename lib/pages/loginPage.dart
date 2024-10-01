import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // Track loading state

  // Function to handle user sign-in
  Future<void> _signIn() async {
    // Validate input
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Email and password cannot be empty");
      return;
    }

    // Simple email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    setState(() {
      _isLoading = true; // Set loading to true
    });

    try {
      // Sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Handle successful sign-in
      print("User signed in: ${userCredential.user?.email}");

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home Page')), // Pass the title if needed
      );
    } catch (e) {
      // Handle error
      print("Error signing in: $e");
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  // Function to handle user sign-up
  Future<void> _signUp() async {
    // Validate input
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Email and password cannot be empty");
      return;
    }

    // Simple email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    setState(() {
      _isLoading = true; // Set loading to true
    });

    try {
      // Create the user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,


      );

      // Handle successful sign-up
      print("User signed up: ${userCredential.user?.email}");

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home Page')), // Pass the title if needed
      );
    } catch (e) {
      // Handle error
      print("Error signing up: $e");
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  // Show error message in a dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.blue,
          ),
          height: 800,
          width: 500,
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true, // Hide password input
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn, // Disable button if loading
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign In"),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp, // Disable button if loading
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
